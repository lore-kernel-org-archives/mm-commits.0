From: akpm@linux-foundation.org
Subject: + slab-print-slabinfo-header-in-seq-show.patch added to -mm tree
Date: Mon, 27 Oct 2014 16:01:29 -0700
Message-ID: <544ecec9.th07wy5m43NOWGVD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaJ0XB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 19:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: print slabinfo header in seq show
has been added to the -mm tree.  Its filename is
     slab-print-slabinfo-header-in-seq-show.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-print-slabinfo-header-in-seq-show.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-print-slabinfo-header-in-seq-show.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: print slabinfo header in seq show

Currently we print the slabinfo header in the seq start method, which
makes it unusable for showing leaks, so we have leaks_show, which does
practically the same as s_show except it doesn't show the header. 
However, we can print the header in the seq show method - we only need to
check if the current element is the first on the list.  This will allow us
to use the same set of seq iterators for both leaks and slabinfo
reporting, which is nice.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    8 +-------
 mm/slab.h        |    1 +
 mm/slab_common.c |   15 ++++++---------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN mm/slab.c~slab-print-slabinfo-header-in-seq-show mm/slab.c
--- a/mm/slab.c~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab.c
@@ -4043,12 +4043,6 @@ ssize_t slabinfo_write(struct file *file
 
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 
-static void *leaks_start(struct seq_file *m, loff_t *pos)
-{
-	mutex_lock(&slab_mutex);
-	return seq_list_start(&slab_caches, *pos);
-}
-
 static inline int add_caller(unsigned long *n, unsigned long v)
 {
 	unsigned long *p;
@@ -4170,7 +4164,7 @@ static int leaks_show(struct seq_file *m
 }
 
 static const struct seq_operations slabstats_op = {
-	.start = leaks_start,
+	.start = slab_start,
 	.next = slab_next,
 	.stop = slab_stop,
 	.show = leaks_show,
diff -puN mm/slab.h~slab-print-slabinfo-header-in-seq-show mm/slab.h
--- a/mm/slab.h~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab.h
@@ -357,6 +357,7 @@ static inline struct kmem_cache_node *ge
 
 #endif
 
+void *slab_start(struct seq_file *m, loff_t *pos);
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
 
diff -puN mm/slab_common.c~slab-print-slabinfo-header-in-seq-show mm/slab_common.c
--- a/mm/slab_common.c~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab_common.c
@@ -830,14 +830,9 @@ void print_slabinfo_header(struct seq_fi
 	seq_putc(m, '\n');
 }
 
-static void *s_start(struct seq_file *m, loff_t *pos)
+void *slab_start(struct seq_file *m, loff_t *pos)
 {
-	loff_t n = *pos;
-
 	mutex_lock(&slab_mutex);
-	if (!n)
-		print_slabinfo_header(m);
-
 	return seq_list_start(&slab_caches, *pos);
 }
 
@@ -899,10 +894,12 @@ int cache_show(struct kmem_cache *s, str
 	return 0;
 }
 
-static int s_show(struct seq_file *m, void *p)
+static int slab_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
 
+	if (p == slab_caches.next)
+		print_slabinfo_header(m);
 	if (!is_root_cache(s))
 		return 0;
 	return cache_show(s, m);
@@ -922,10 +919,10 @@ static int s_show(struct seq_file *m, vo
  * + further values on SMP and with statistics enabled
  */
 static const struct seq_operations slabinfo_op = {
-	.start = s_start,
+	.start = slab_start,
 	.next = slab_next,
 	.stop = slab_stop,
-	.show = s_show,
+	.show = slab_show,
 };
 
 static int slabinfo_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
mm-rmap-split-out-page_remove_file_rmap.patch
cpuset-convert-callback_mutex-to-a-spinlock.patch
cpuset-simplify-cpuset_node_allowed-api.patch
cpuset-simplify-cpuset_node_allowed-api-fix.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch

