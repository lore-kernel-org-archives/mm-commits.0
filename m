From: akpm@linux-foundation.org
Subject: +
 debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch
 added to -mm tree
Date: Thu, 05 Jan 2017 14:43:17 -0800
Message-ID: <586ecc05.xsunX+UQJ5UbxQIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754239AbdAEXGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:06:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: longman@redhat.com, borntraeger@de.ibm.com, changbin.du@intel.com, jstancek@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: track number of kmem_cache_alloc/kmem_cache_free done
has been added to the -mm tree.  Its filename is
     debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: debugobjects: track number of kmem_cache_alloc/kmem_cache_free done

Patch series "debugobjects: Reduce global pool_lock contention", v2.

This patchset aims to reduce contention of the global pool_lock while
improving performance at the same time.  It is done to resolve the
following soft lockup problem with a debug kernel in some of the large SMP
systems:

 NMI watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [rcuos/1:21]
 ...
 RIP: 0010:[<ffffffff817c216b>]  [<ffffffff817c216b>]
	_raw_spin_unlock_irqrestore+0x3b/0x60
 ...
 Call Trace:
  [<ffffffff813f40d1>] free_object+0x81/0xb0
  [<ffffffff813f4f33>] debug_check_no_obj_freed+0x193/0x220
  [<ffffffff81101a59>] ? trace_hardirqs_on_caller+0xf9/0x1c0
  [<ffffffff81284996>] ? file_free_rcu+0x36/0x60
  [<ffffffff81251712>] kmem_cache_free+0xd2/0x380
  [<ffffffff81284960>] ? fput+0x90/0x90
  [<ffffffff81284996>] file_free_rcu+0x36/0x60
  [<ffffffff81124c23>] rcu_nocb_kthread+0x1b3/0x550
  [<ffffffff81124b71>] ? rcu_nocb_kthread+0x101/0x550
  [<ffffffff81124a70>] ? sync_exp_work_done.constprop.63+0x50/0x50
  [<ffffffff810c59d1>] kthread+0x101/0x120
  [<ffffffff81101a59>] ? trace_hardirqs_on_caller+0xf9/0x1c0
  [<ffffffff817c2d32>] ret_from_fork+0x22/0x50

On a 8-socket IvyBridge-EX system (120 cores, 240 threads), the elapsed
time of a 4.9-rc7 kernel parallel build (make -j 240) was reduced from
7m57s to 7m19s with a patched 4.9-rc7 kernel.  There was also about a 10X
reduction in the number of debug objects being allocated from or freed to
the kmemcache during the kernel build.


This patch (of 3):

New debugfs stat counters are added to track the numbers of
kmem_cache_alloc() and kmem_cache_free() function calls to get a sense of
how the internal debug objects cache management is performing.

Link: http://lkml.kernel.org/r/1483647425-4135-2-git-send-email-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Du Changbin" <changbin.du@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN lib/debugobjects.c~debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done
+++ a/lib/debugobjects.c
@@ -55,6 +55,12 @@ static int			debug_objects_enabled __rea
 
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
+/*
+ * Track numbers of kmem_cache_alloc and kmem_cache_free done.
+ */
+static int			debug_objects_alloc;
+static int			debug_objects_freed;
+
 static void free_obj_work(struct work_struct *work);
 static DECLARE_WORK(debug_obj_work, free_obj_work);
 
@@ -102,6 +108,7 @@ static void fill_pool(void)
 
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
+		debug_objects_alloc++;
 		obj_pool_free++;
 		raw_spin_unlock_irqrestore(&pool_lock, flags);
 	}
@@ -173,6 +180,7 @@ static void free_obj_work(struct work_st
 		obj = hlist_entry(obj_pool.first, typeof(*obj), node);
 		hlist_del(&obj->node);
 		obj_pool_free--;
+		debug_objects_freed++;
 		/*
 		 * We release pool_lock across kmem_cache_free() to
 		 * avoid contention on pool_lock.
@@ -758,6 +766,8 @@ static int debug_stats_show(struct seq_f
 	seq_printf(m, "pool_min_free :%d\n", obj_pool_min_free);
 	seq_printf(m, "pool_used     :%d\n", obj_pool_used);
 	seq_printf(m, "pool_max_used :%d\n", obj_pool_max_used);
+	seq_printf(m, "objects_alloc :%d\n", debug_objects_alloc);
+	seq_printf(m, "objects_freed :%d\n", debug_objects_freed);
 	return 0;
 }
 
_

Patches currently in -mm which might be from longman@redhat.com are

debugobjects-track-number-of-kmem_cache_alloc-kmem_cache_free-done.patch
debugobjects-scale-thresholds-with-of-cpus.patch
debugobjects-reduce-contention-on-the-global-pool_lock.patch

