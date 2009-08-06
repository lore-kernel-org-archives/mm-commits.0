From: akpm@linux-foundation.org
Subject: [folded] mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2.patch removed from -mm tree
Date: Thu, 06 Aug 2009 15:03:52 -0700
Message-ID: <200908062203.n76M3qMC030512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZHFWEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 18:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2
has been removed from the -mm tree.  Its filename was
     mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2.patch

This patch was dropped because it was folded into mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

up_write() can be called without down_write() in error path.
fix it.

Reported-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2 mm/mempolicy.c
--- a/mm/mempolicy.c~mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2
+++ a/mm/mempolicy.c
@@ -1033,12 +1033,13 @@ static long do_mbind(unsigned long start
 			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
 			task_unlock(current);
+			if (err)
+				up_write(&mm->mmap_sem);
 		} else
 			err = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
 	if (err) {
-		up_write(&mm->mmap_sem);
 		mpol_put(new);
 		return err;
 	}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix-2.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
oom-move-oom_adj-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
kcore-fix-proc-kcores-statst_size.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch

