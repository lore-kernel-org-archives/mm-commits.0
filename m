From: akpm@linux-foundation.org
Subject: [merged] oom-thaw-the-oom-victim-if-it-is-frozen.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:03 -0800
Message-ID: <54dd00df.08dZ62b7P2lmlIIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbBLThE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: thaw the OOM victim if it is frozen
has been removed from the -mm tree.  Its filename was
     oom-thaw-the-oom-victim-if-it-is-frozen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

