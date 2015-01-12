From: akpm@linux-foundation.org
Subject: + oom-thaw-the-oom-victim-if-it-is-frozen.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:59:55 -0800
Message-ID: <54b45ffb.b7rVJ8Ockquwcp6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbALX74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:59:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: thaw the OOM victim if it is frozen
has been added to the -mm tree.  Its filename is
     oom-thaw-the-oom-victim-if-it-is-frozen.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-thaw-the-oom-victim-if-it-is-frozen.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-thaw-the-oom-victim-if-it-is-frozen.patch

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
Subject: oom: thaw the OOM victim if it is frozen

oom_kill_process only sets TIF_MEMDIE flag and sends a signal to the
victim.  This is basically noop when the task is frozen though because the
task sleeps in the uninterruptible sleep.  The victim is eventually thawed
later when oom_scan_process_thread meets the task again in a later OOM
invocation so the OOM killer doesn't live lock.  But this is less than
optimal.

Let's add __thaw_task into mark_tsk_oom_victim after we set TIF_MEMDIE to
the victim.  We are not checking whether the task is frozen because that
would be racy and __thaw_task does that already.  oom_scan_process_thread
doesn't need to care about freezer anymore as TIF_MEMDIE and freezer are
excluded completely now.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-thaw-the-oom-victim-if-it-is-frozen mm/oom_kill.c
--- a/mm/oom_kill.c~oom-thaw-the-oom-victim-if-it-is-frozen
+++ a/mm/oom_kill.c
@@ -266,8 +266,6 @@ enum oom_scan_t oom_scan_process_thread(
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (unlikely(frozen(task)))
-			__thaw_task(task);
 		if (!force_kill)
 			return OOM_SCAN_ABORT;
 	}
@@ -423,6 +421,14 @@ void note_oom_kill(void)
 void mark_tsk_oom_victim(struct task_struct *tsk)
 {
 	set_tsk_thread_flag(tsk, TIF_MEMDIE);
+
+	/*
+	 * Make sure that the task is woken up from uninterruptible sleep
+	 * if it is frozen because OOM killer wouldn't be able to free
+	 * any memory and livelock. freezing_slow_path will tell the freezer
+	 * that TIF_MEMDIE tasks should be ignored.
+	 */
+	__thaw_task(tsk);
 }
 
 /**
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

