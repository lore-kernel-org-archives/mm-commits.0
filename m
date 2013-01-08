From: akpm@linux-foundation.org
Subject: + mm-remove-flags-argument-to-mmap_region.patch added to -mm tree
Date: Tue, 08 Jan 2013 15:42:44 -0800
Message-ID: <20130108234245.65A1E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62704 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3AHXmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 18:42:47 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so155765qcq.5
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 15:42:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com


The patch titled
     Subject: mm: remove flags argument to mmap_region
has been added to the -mm tree.  Its filename is
     mm-remove-flags-argument-to-mmap_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: remove flags argument to mmap_region

After the MAP_POPULATE handling has been moved to mmap_region() call sites,
the only remaining use of the flags argument is to pass the MAP_NORESERVE
flag. This can be just as easily handled by do_mmap_pgoff(), so do that
and remove the mmap_region() flags parameter.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/elf.c |    1 -
 include/linux/mm.h |    3 +--
 mm/fremap.c        |    3 +--
 mm/mmap.c          |   33 ++++++++++++++++-----------------
 4 files changed, 18 insertions(+), 22 deletions(-)

diff -puN arch/tile/mm/elf.c~mm-remove-flags-argument-to-mmap_region arch/tile/mm/elf.c
--- a/arch/tile/mm/elf.c~mm-remove-flags-argument-to-mmap_region
+++ a/arch/tile/mm/elf.c
@@ -130,7 +130,6 @@ int arch_setup_additional_pages(struct l
 	if (!retval) {
 		unsigned long addr = MEM_USER_INTRPT;
 		addr = mmap_region(NULL, addr, INTRPT_SIZE,
-				   MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE,
 				   VM_READ|VM_EXEC|
 				   VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC, 0);
 		if (addr > (unsigned long) -PAGE_SIZE)
diff -puN include/linux/mm.h~mm-remove-flags-argument-to-mmap_region include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-flags-argument-to-mmap_region
+++ a/include/linux/mm.h
@@ -1474,8 +1474,7 @@ extern int install_special_mapping(struc
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
-	unsigned long len, unsigned long flags,
-	vm_flags_t vm_flags, unsigned long pgoff);
+	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff);
 extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	unsigned long pgoff, bool *populate);
diff -puN mm/fremap.c~mm-remove-flags-argument-to-mmap_region mm/fremap.c
--- a/mm/fremap.c~mm-remove-flags-argument-to-mmap_region
+++ a/mm/fremap.c
@@ -204,9 +204,8 @@ get_write_lock:
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
 
-			flags = (flags & MAP_NONBLOCK) | MAP_POPULATE;
 			addr = mmap_region(file, start, size,
-					flags, vma->vm_flags, pgoff);
+					vma->vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
diff -puN mm/mmap.c~mm-remove-flags-argument-to-mmap_region mm/mmap.c
--- a/mm/mmap.c~mm-remove-flags-argument-to-mmap_region
+++ a/mm/mmap.c
@@ -1290,7 +1290,21 @@ unsigned long do_mmap_pgoff(struct file 
 		}
 	}
 
-	addr = mmap_region(file, addr, len, flags, vm_flags, pgoff);
+	/*
+	 * Set 'VM_NORESERVE' if we should not account for the
+	 * memory use of this mapping.
+	 */
+	if ((flags & MAP_NORESERVE)) {
+		/* We honor MAP_NORESERVE if allowed to overcommit */
+		if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
+			vm_flags |= VM_NORESERVE;
+
+		/* hugetlb applies strict overcommit unless MAP_NORESERVE */
+		if (file && is_file_hugepages(file))
+			vm_flags |= VM_NORESERVE;
+	}
+
+	addr = mmap_region(file, addr, len, vm_flags, pgoff);
 	if (!IS_ERR_VALUE(addr) &&
 	    ((vm_flags & VM_LOCKED) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
@@ -1410,8 +1424,7 @@ static inline int accountable_mapping(st
 }
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
-			  unsigned long len, unsigned long flags,
-			  vm_flags_t vm_flags, unsigned long pgoff)
+		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -1435,20 +1448,6 @@ munmap_back:
 		return -ENOMEM;
 
 	/*
-	 * Set 'VM_NORESERVE' if we should not account for the
-	 * memory use of this mapping.
-	 */
-	if ((flags & MAP_NORESERVE)) {
-		/* We honor MAP_NORESERVE if allowed to overcommit */
-		if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
-			vm_flags |= VM_NORESERVE;
-
-		/* hugetlb applies strict overcommit unless MAP_NORESERVE */
-		if (file && is_file_hugepages(file))
-			vm_flags |= VM_NORESERVE;
-	}
-
-	/*
 	 * Private writable mapping: check memory availability
 	 */
 	if (accountable_mapping(file, vm_flags)) {
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

