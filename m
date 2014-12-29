From: akpm@linux-foundation.org
Subject: + oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
 added to -mm tree
Date: Mon, 29 Dec 2014 13:58:23 -0800
Message-ID: <54a1ce7f.OtD7oC2jKf1jS0oa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaL2V6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 16:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: make sure that TIF_MEMDIE is set under task_lock
has been added to the -mm tree.  Its filename is
     oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: make sure that TIF_MEMDIE is set under task_lock

OOM killer tries to exclude tasks which do not have mm_struct associated
because killing such a task wouldn't help much.  The OOM victim gets
TIF_MEMDIE set to disable OOM killer while the current victim releases the
memory and then enables the OOM killer again by dropping the flag.

oom_kill_process is currently prone to a race condition when the OOM
victim is already exiting and TIF_MEMDIE is set after the task releases
its address space.  This might theoretically lead to OOM livelock if the
OOM victim blocks on an allocation later during exiting because it
wouldn't kill any other process and the exiting one won't be able to exit.
 The situation is highly unlikely because the OOM victim is expected to
release some memory which should help to sort out OOM situation.

Fix this by checking task->mm and setting TIF_MEMDIE flag under task_lock
which will serialize the OOM killer with exit_mm which sets task->mm to
NULL.  Setting the flag for current is not necessary because check and set
is not racy.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-make-sure-that-tif_memdie-is-set-under-task_lock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-sure-that-tif_memdie-is-set-under-task_lock
+++ a/mm/oom_kill.c
@@ -438,11 +438,14 @@ void oom_kill_process(struct task_struct
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (task_will_free_mem(p)) {
+	task_lock(p);
+	if (p->mm && task_will_free_mem(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
+		task_unlock(p);
 		put_task_struct(p);
 		return;
 	}
+	task_unlock(p);
 
 	if (__ratelimit(&oom_rs))
 		dump_header(p, gfp_mask, order, memcg, nodemask);
@@ -492,6 +495,7 @@ void oom_kill_process(struct task_struct
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
+	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
 		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
@@ -522,7 +526,6 @@ void oom_kill_process(struct task_struct
 		}
 	rcu_read_unlock();
 
-	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-prevent-endless-growth-of-anon_vma-hierarchy.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

