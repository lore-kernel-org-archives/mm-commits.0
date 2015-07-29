From: akpm@linux-foundation.org
Subject: + mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
 added to -mm tree
Date: Wed, 29 Jul 2015 11:21:17 -0700
Message-ID: <55b9199d.G7mZbBJrEMX9xGzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbG2SVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: add mlock flags to enable VM_LOCKONFAULT usage
has been added to the -mm tree.  Its filename is
     mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: add mlock flags to enable VM_LOCKONFAULT usage

The previous patch introduced a flag that specified pages in a VMA should
be placed on the unevictable LRU, but they should not be made present when
the area is created.  This patch adds the ability to set this state via
the new mlock system calls.

We add MLOCK_ONFAULT for mlock2 and MCL_ONFAULT for mlockall. 
MLOCK_ONFAULT will set the VM_LOCKONFAULT modifier for VM_LOCKED. 
MCL_ONFAULT should be used as a modifier to the two other mlockall flags. 
When used with MCL_CURRENT, all current mappings will be marked with
VM_LOCKED | VM_LOCKONFAULT.  When used with MCL_FUTURE, the mm->def_flags
will be marked with VM_LOCKED | VM_LOCKONFAULT.  When used with both
MCL_CURRENT and MCL_FUTURE, all current mappings and mm->def_flags will be
marked with VM_LOCKED | VM_LOCKONFAULT.

Prior to this patch, mlockall() will unconditionally clear the
mm->def_flags any time it is called without MCL_FUTURE.  This behavior is
maintained after adding MCL_ONFAULT.  If a call to mlockall(MCL_FUTURE) is
followed by mlockall(MCL_CURRENT), the mm->def_flags will be cleared and
new VMAs will be unlocked.  This remains true with or without MCL_ONFAULT
in either mlockall() invocation.

munlock() will unconditionally clear both vma flags.  munlockall()
unconditionally clears for VMA flags on all VMAs and in the mm->def_flags
field.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    3 +
 arch/mips/include/uapi/asm/mman.h      |    6 ++
 arch/parisc/include/uapi/asm/mman.h    |    3 +
 arch/powerpc/include/uapi/asm/mman.h   |    1 
 arch/sparc/include/uapi/asm/mman.h     |    1 
 arch/tile/include/uapi/asm/mman.h      |    1 
 arch/xtensa/include/uapi/asm/mman.h    |    6 ++
 include/uapi/asm-generic/mman-common.h |    5 ++
 include/uapi/asm-generic/mman.h        |    1 
 mm/mlock.c                             |   55 +++++++++++++++++------
 10 files changed, 70 insertions(+), 12 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -37,6 +37,9 @@
 
 #define MCL_CURRENT	 8192		/* lock all currently mapped pages */
 #define MCL_FUTURE	16384		/* lock all additions to address space */
+#define MCL_ONFAULT	32768		/* lock all pages that are faulted in */
+
+#define MLOCK_ONFAULT	0x01		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -61,6 +61,12 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
+
+/*
+ * Flags for mlock
+ */
+#define MLOCK_ONFAULT	0x01		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -31,6 +31,9 @@
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
+
+#define MLOCK_ONFAULT	0x01		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL     0               /* no further special treatment */
 #define MADV_RANDOM     1               /* expect random page references */
diff -puN arch/powerpc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/powerpc/include/uapi/asm/mman.h
--- a/arch/powerpc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/powerpc/include/uapi/asm/mman.h
@@ -22,6 +22,7 @@
 
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -17,6 +17,7 @@
 
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
diff -puN arch/tile/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/tile/include/uapi/asm/mman.h
--- a/arch/tile/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/tile/include/uapi/asm/mman.h
@@ -36,6 +36,7 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 
 #endif /* _ASM_TILE_MMAN_H */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -74,6 +74,12 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
+
+/*
+ * Flags for mlock
+ */
+#define MLOCK_ONFAULT	0x01		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN include/uapi/asm-generic/mman-common.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/include/uapi/asm-generic/mman-common.h
@@ -25,6 +25,11 @@
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
 
+/*
+ * Flags for mlock
+ */
+#define MLOCK_ONFAULT	0x01		/* Lock pages in range after they are faulted in, do not prefault */
+
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
 #define MS_SYNC		4		/* synchronous memory sync */
diff -puN include/uapi/asm-generic/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/include/uapi/asm-generic/mman.h
@@ -17,5 +17,6 @@
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 #endif /* __ASM_GENERIC_MMAN_H */
diff -puN mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage mm/mlock.c
--- a/mm/mlock.c~mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage
+++ a/mm/mlock.c
@@ -506,7 +506,8 @@ static int mlock_fixup(struct vm_area_st
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
-		goto out;	/* don't set VM_LOCKED,  don't count */
+		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
+		goto out;
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
@@ -577,7 +578,7 @@ static int apply_vma_lock_flags(unsigned
 		prev = vma;
 
 	for (nstart = start ; ; ) {
-		vm_flags_t newflags = vma->vm_flags & ~VM_LOCKED;
+		vm_flags_t newflags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 		newflags |= flags;
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
@@ -646,9 +647,12 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 {
 	vm_flags_t vm_flags = VM_LOCKED;
-	if (flags)
+	if (flags & ~MLOCK_ONFAULT)
 		return -EINVAL;
 
+	if (flags & MLOCK_ONFAULT)
+		vm_flags |= VM_LOCKONFAULT;
+
 	return do_mlock(start, len, vm_flags);
 }
 
@@ -666,24 +670,50 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	return ret;
 }
 
+/*
+ * Take the MCL_* flags passed into mlockall (or 0 if called from munlockall)
+ * and translate into the appropriate modifications to mm->def_flags and/or the
+ * flags for all current VMAs.
+ *
+ * There are a couple of sublties with this.  If mlockall() is called multiple
+ * times with different flags, the values do not necessarily stack.  If mlockall
+ * is called once including the MCL_FUTURE flag and then a second time without
+ * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_flags.
+ */
 static int apply_mlockall_flags(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
+	vm_flags_t to_add = 0;
 
-	if (flags & MCL_FUTURE)
+	current->mm->def_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+	if (flags & MCL_FUTURE) {
 		current->mm->def_flags |= VM_LOCKED;
-	else
-		current->mm->def_flags &= ~VM_LOCKED;
 
-	if (flags == MCL_FUTURE)
-		goto out;
+		if (flags & MCL_ONFAULT)
+			current->mm->def_flags |= VM_LOCKONFAULT;
+
+		/*
+		 * When there were only two flags, we used to early out if only
+		 * MCL_FUTURE was set.  Now that we have MCL_ONFAULT, we can
+		 * only early out if MCL_FUTURE is set, but MCL_CURRENT is not.
+		 * This is done, even though it promotes odd behavior, to
+		 * maintain behavior from older kernels
+		 */
+		if (!(flags & MCL_CURRENT))
+			goto out;
+	}
+
+	if (flags & MCL_CURRENT) {
+		to_add |= VM_LOCKED;
+		if (flags & MCL_ONFAULT)
+			to_add |= VM_LOCKONFAULT;
+	}
 
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags & ~VM_LOCKED;
-		if (flags & MCL_CURRENT)
-			newflags |= VM_LOCKED;
+		newflags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+		newflags |= to_add;
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
@@ -698,7 +728,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	unsigned long lock_limit;
 	int ret = -EINVAL;
 
-	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE)))
+	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT)) ||
+	    flags == MCL_ONFAULT)
 		goto out;
 
 	ret = -EPERM;
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

