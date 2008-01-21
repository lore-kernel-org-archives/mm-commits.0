From: akpm@linux-foundation.org
Subject: - git-x86-pat-fix.patch removed from -mm tree
Date: Mon, 21 Jan 2008 14:59:44 -0800
Message-ID: <200801212259.m0LMxj4f024283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbYAUXFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:05:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, ak@suse.de, mingo@elte.hu, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86: PAT fix
has been removed from the -mm tree.  Its filename was
     git-x86-pat-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86: PAT fix
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix the iounmap() to call free_matrr() unconditionally.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap_32.c |    7 +++----
 arch/x86/mm/ioremap_64.c |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/ioremap_32.c~git-x86-pat-fix arch/x86/mm/ioremap_32.c
--- a/arch/x86/mm/ioremap_32.c~git-x86-pat-fix
+++ a/arch/x86/mm/ioremap_32.c
@@ -219,12 +219,11 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
diff -puN arch/x86/mm/ioremap_64.c~git-x86-pat-fix arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c~git-x86-pat-fix
+++ a/arch/x86/mm/ioremap_64.c
@@ -190,12 +190,11 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

git-powerpc.patch
git-x86-pat-fix.patch
swapoff-scan-ptes-preemptibly.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
remove-unused-code-from-mm-tiny-shmemc.patch
memory-controller-add-documentation.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
memory-controller-bug_on.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
memory-controller-remove-control_type-feature.patch
update-documentation-controller-memorytxt.patch
