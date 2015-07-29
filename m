From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch removed from -mm tree
Date: Wed, 29 Jul 2015 11:08:48 -0700
Message-ID: <55b916b0.j/40GlCIMP1BF/nP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbbG2SIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: add mmap flag to request VM_LOCKONFAULT
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mmap: add mmap flag to request VM_LOCKONFAULT

The cost of faulting in all memory to be locked can be very high when
working with large mappings.  If only portions of the mapping will be used
this can incur a high penalty for locking.

Now that we have the new VMA flag for the locked but not present state,
expose it as an mmap option like MAP_LOCKED -> VM_LOCKED.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h   |    1 +
 arch/mips/include/uapi/asm/mman.h    |    1 +
 arch/parisc/include/uapi/asm/mman.h  |    1 +
 arch/powerpc/include/uapi/asm/mman.h |    1 +
 arch/sparc/include/uapi/asm/mman.h   |    1 +
 arch/xtensa/include/uapi/asm/mman.h  |    1 +
 include/linux/mman.h                 |    3 ++-
 include/uapi/asm-generic/mman.h      |    1 +
 mm/mmap.c                            |    2 +-
 9 files changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -30,6 +30,7 @@
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
 #define MAP_STACK	0x80000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x100000	/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x200000	/* Lock pages after they are faulted in, do not prefault */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -48,6 +48,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x100000	/* Lock pages after they are faulted in, do not prefault */
 
 /*
  * Flags for msync
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -24,6 +24,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x100000	/* Lock pages after they are faulted in, do not prefault */
 
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
diff -puN arch/powerpc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/powerpc/include/uapi/asm/mman.h
--- a/arch/powerpc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/powerpc/include/uapi/asm/mman.h
@@ -31,5 +31,6 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x80000		/* Lock pages after they are faulted in, do not prefault */
 
 #endif /* _UAPI_ASM_POWERPC_MMAN_H */
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -26,6 +26,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x8000		/* Lock pages after they are faulted in, do not prefault */
 
 
 #endif /* _UAPI__SPARC_MMAN_H__ */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -55,6 +55,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x100000	/* Lock pages after they are faulted in, do not prefault */
 #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
 # define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be
 					 * uninitialized */
diff -puN include/linux/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault include/linux/mman.h
--- a/include/linux/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/include/linux/mman.h
@@ -86,7 +86,8 @@ calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
-	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
+	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
+	       _calc_vm_trans(flags, MAP_LOCKONFAULT,VM_LOCKONFAULT);
 }
 
 unsigned long vm_commit_limit(void);
diff -puN include/uapi/asm-generic/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/include/uapi/asm-generic/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_LOCKONFAULT	0x80000		/* Lock pages after they are faulted in, do not prefault */
 
 /* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
 
diff -puN mm/mmap.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault mm/mmap.c
--- a/mm/mmap.c~mm-mmap-add-mmap-flag-to-request-vm_lockonfault
+++ a/mm/mmap.c
@@ -1314,7 +1314,7 @@ unsigned long do_mmap_pgoff(struct file
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
-	if (flags & MAP_LOCKED)
+	if (flags & (MAP_LOCKED | MAP_LOCKONFAULT))
 		if (!can_do_mlock())
 			return -EPERM;
 
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-gup-add-mm_lock_present-checkpatch-fixes.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch

