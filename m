From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:44:46 -0700
Message-ID: <559adaae.eJJmcFSrkR0sBK5O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbbGFTor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c             |    6 ------
 include/asm-generic/barrier.h |    9 ---------
 scripts/kconfig/Makefile      |    8 +-------
 3 files changed, 1 insertion(+), 22 deletions(-)

diff -puN fs/xfs/xfs_file.c~linux-next-git-rejects fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_file.c
@@ -1516,15 +1516,9 @@ xfs_filemap_fault(
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(vma->vm_file));
 	int			ret;
-<<<<<<< HEAD
 
 	trace_xfs_filemap_fault(ip);
 
-=======
-
-	trace_xfs_filemap_fault(ip);
-
->>>>>>> linux-next/akpm-base
 	/* DAX can shortcut the normal fault path on write faults! */
 	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(VFS_I(ip)))
 		return xfs_filemap_page_mkwrite(vma, vmf);
diff -puN include/asm-generic/barrier.h~linux-next-git-rejects include/asm-generic/barrier.h
--- a/include/asm-generic/barrier.h~linux-next-git-rejects
+++ a/include/asm-generic/barrier.h
@@ -72,12 +72,7 @@
 #define smp_read_barrier_depends()	read_barrier_depends()
 #endif
 
-<<<<<<< HEAD
-#else	/* !CONFIG_SMP */
-
-=======
 #else
->>>>>>> linux-next/akpm-base
 #ifndef smp_mb
 #define smp_mb()	barrier()
 #endif
@@ -94,11 +89,7 @@
 #define smp_read_barrier_depends()	do { } while (0)
 #endif
 
-<<<<<<< HEAD
-#endif	/* CONFIG_SMP */
-=======
 #endif
->>>>>>> linux-next/akpm-base
 
 #ifndef smp_store_mb
 #define smp_store_mb(var, value)  do { WRITE_ONCE(var, value); mb(); } while (0)
diff -puN scripts/kconfig/Makefile~linux-next-git-rejects scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~linux-next-git-rejects
+++ a/scripts/kconfig/Makefile
@@ -125,7 +125,7 @@ tinyconfig:
 
 # Help text used by make help
 help:
-	@echo  '  config	  - Update current config utilising a line-oriented program'
+	@echo  '  config	  - Update current conqfig utilising a line-oriented program'
 	@echo  '  nconfig         - Update current config utilising a ncurses menu based'
 	@echo  '                    program'
 	@echo  '  menuconfig	  - Update current config utilising a menu based program'
@@ -143,15 +143,9 @@ help:
 	@echo  '  alldefconfig    - New config with all symbols set to default'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
-<<<<<<< HEAD
-	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
-	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
-	@echo  '  xenconfig       - Enable additional options for xen dom0 and guest kernel support'
-=======
 	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their'
 	@echo  '                    default value'
 	@echo  '  kvmconfig	  - Enable additional options for guest kernel support'
->>>>>>> linux-next/akpm-base
 	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
 
 # lxdialog stuff
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

