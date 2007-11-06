From: akpm@linux-foundation.org
Subject: + remove-unused-code-from-mm-tiny-shmemc.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:00:35 -0800
Message-ID: <200711060000.lA600Ztf026487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294AbXKFAAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, mpm@selenic.com


The patch titled
     Remove unused code from mm/tiny-shmem.c
has been added to the -mm tree.  Its filename is
     remove-unused-code-from-mm-tiny-shmemc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unused code from mm/tiny-shmem.c
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This code in mm/tiny-shmem.c is under #if 0 - remove it.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tiny-shmem.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/tiny-shmem.c~remove-unused-code-from-mm-tiny-shmemc mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~remove-unused-code-from-mm-tiny-shmemc
+++ a/mm/tiny-shmem.c
@@ -121,18 +121,6 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
-#if 0
-int shmem_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	file_accessed(file);
-#ifndef CONFIG_MMU
-	return ramfs_nommu_mmap(file, vma);
-#else
-	return 0;
-#endif
-}
-#endif  /*  0  */
-
 #ifndef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr,
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
make-getdelays-cgroupstats-aware.patch
swap-delay-accounting-include-lock_page-delays.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
remove-unused-code-from-mm-tiny-shmemc.patch
memory-controller-add-documentation.patch
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
memory-controller-make-charging-gfp-mask-aware-fix.patch
memory-controller-bug_on.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
