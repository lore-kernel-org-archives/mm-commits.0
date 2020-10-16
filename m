Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953B9C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3142D21D41
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881682;
	bh=En4tvZI32Bv6DNm+G1qDy+aWRNc3GzVH5RtMLSWATG4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qW4jTvNpUNoHFAx+8W8EBHFbFup4DwSBiwvayjsUw0PSWFmOZJdprn305lUXRDGgQ
	 8lpmHVjrWltZLGzgAMCcyleBMsulr48b9eP3mDs+kwNn6xHnb1+j+iRtRhnKa8Av5u
	 AykAeYHUzu2C4HqCbjvwnKEpSQlLN4nUXaa5ZBMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409421AbgJPUyl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391502AbgJPUyl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9089C21775;
        Fri, 16 Oct 2020 20:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881679;
        bh=En4tvZI32Bv6DNm+G1qDy+aWRNc3GzVH5RtMLSWATG4=;
        h=Date:From:To:Subject:From;
        b=oGx8EwZ+mXiChOIZBkMlklbVfaDAsdG6lOPGlBpgSi916qjz4rOU+xqjBTQeHWgx8
         4ALHNBPe1GZL3DiXnIU6f81FzBPrMkiLYB/+bYLQfHenbOSfCHnjFlGBI9VlbsxGvP
         1dsI1Wud9WPlNEN23qXCExh0UZDGBO6GwDtAyyv8=
Date:   Fri, 16 Oct 2020 13:54:38 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, hch@lst.de, hughd@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
 removed from -mm tree
Message-ID: <20201016205438.h6ukKZkYA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: rework elf/elf_fdpic vma_dump_size() into common helper
has been removed from the -mm tree.  Its filename was
     coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: coredump: rework elf/elf_fdpic vma_dump_size() into common helper

At the moment, the binfmt_elf and binfmt_elf_fdpic code have slightly
different code to figure out which VMAs should be dumped, and if so,
whether the dump should contain the entire VMA or just its first page.

Eliminate duplicate code by reworking the binfmt_elf version into a
generic core dumping helper in coredump.c.

As part of that, change the heuristic for detecting executable/library
header pages to check whether the inode is executable instead of looking
at the file mode.

This is less problematic in terms of locking because it lets us avoid
get_user() under the mmap_sem.  (And arguably it looks nicer and makes
more sense in generic code.)

Adjust a little bit based on the binfmt_elf_fdpic version: ->anon_vma is
only meaningful under CONFIG_MMU, otherwise we have to assume that the VMA
has been written to.

Link: http://lkml.kernel.org/r/20200827114932.3572699-5-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c          |  120 -------------------------------------
 fs/binfmt_elf_fdpic.c    |   83 +------------------------
 fs/coredump.c            |  101 +++++++++++++++++++++++++++++++
 include/linux/coredump.h |    1 
 4 files changed, 106 insertions(+), 199 deletions(-)

--- a/fs/binfmt_elf.c~coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper
+++ a/fs/binfmt_elf.c
@@ -1414,126 +1414,6 @@ out:
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
 
-/*
- * The purpose of always_dump_vma() is to make sure that special kernel mappings
- * that are useful for post-mortem analysis are included in every core dump.
- * In that way we ensure that the core dump is fully interpretable later
- * without matching up the same kernel and hardware config to see what PC values
- * meant. These special mappings include - vDSO, vsyscall, and other
- * architecture specific mappings
- */
-static bool always_dump_vma(struct vm_area_struct *vma)
-{
-	/* Any vsyscall mappings? */
-	if (vma == get_gate_vma(vma->vm_mm))
-		return true;
-
-	/*
-	 * Assume that all vmas with a .name op should always be dumped.
-	 * If this changes, a new vm_ops field can easily be added.
-	 */
-	if (vma->vm_ops && vma->vm_ops->name && vma->vm_ops->name(vma))
-		return true;
-
-	/*
-	 * arch_vma_name() returns non-NULL for special architecture mappings,
-	 * such as vDSO sections.
-	 */
-	if (arch_vma_name(vma))
-		return true;
-
-	return false;
-}
-
-/*
- * Decide what to dump of a segment, part, all or none.
- */
-static unsigned long vma_dump_size(struct vm_area_struct *vma,
-				   unsigned long mm_flags)
-{
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
-
-	/* always dump the vdso and vsyscall sections */
-	if (always_dump_vma(vma))
-		goto whole;
-
-	if (vma->vm_flags & VM_DONTDUMP)
-		return 0;
-
-	/* support for DAX */
-	if (vma_is_dax(vma)) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(DAX_SHARED))
-			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(DAX_PRIVATE))
-			goto whole;
-		return 0;
-	}
-
-	/* Hugetlb memory check */
-	if (is_vm_hugetlb_page(vma)) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
-			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
-			goto whole;
-		return 0;
-	}
-
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
-		return 0;
-
-	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
-		if (file_inode(vma->vm_file)->i_nlink == 0 ?
-		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
-			goto whole;
-		return 0;
-	}
-
-	/* Dump segments that have been written to.  */
-	if (vma->anon_vma && FILTER(ANON_PRIVATE))
-		goto whole;
-	if (vma->vm_file == NULL)
-		return 0;
-
-	if (FILTER(MAPPED_PRIVATE))
-		goto whole;
-
-	/*
-	 * If this looks like the beginning of a DSO or executable mapping,
-	 * check for an ELF header.  If we find one, dump the first page to
-	 * aid in determining what was mapped here.
-	 */
-	if (FILTER(ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
-		u32 __user *header = (u32 __user *) vma->vm_start;
-		u32 word;
-		/*
-		 * Doing it this way gets the constant folded by GCC.
-		 */
-		union {
-			u32 cmp;
-			char elfmag[SELFMAG];
-		} magic;
-		BUILD_BUG_ON(SELFMAG != sizeof word);
-		magic.elfmag[EI_MAG0] = ELFMAG0;
-		magic.elfmag[EI_MAG1] = ELFMAG1;
-		magic.elfmag[EI_MAG2] = ELFMAG2;
-		magic.elfmag[EI_MAG3] = ELFMAG3;
-		if (unlikely(get_user(word, header)))
-			word = 0;
-		if (word == magic.cmp)
-			return PAGE_SIZE;
-	}
-
-#undef	FILTER
-
-	return 0;
-
-whole:
-	return vma->vm_end - vma->vm_start;
-}
-
 /* An ELF note in memory */
 struct memelfnote
 {
--- a/fs/binfmt_elf_fdpic.c~coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper
+++ a/fs/binfmt_elf_fdpic.c
@@ -1215,76 +1215,6 @@ struct elf_prstatus_fdpic
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
 
-/*
- * Decide whether a segment is worth dumping; default is yes to be
- * sure (missing info is worse than too much; etc).
- * Personally I'd include everything, and use the coredump limit...
- *
- * I think we should skip something. But I am not sure how. H.J.
- */
-static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
-{
-	int dump_ok;
-
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO) {
-		kdcore("%08lx: %08lx: no (IO)", vma->vm_start, vma->vm_flags);
-		return 0;
-	}
-
-	/* If we may not read the contents, don't allow us to dump
-	 * them either. "dump_write()" can't handle it anyway.
-	 */
-	if (!(vma->vm_flags & VM_READ)) {
-		kdcore("%08lx: %08lx: no (!read)", vma->vm_start, vma->vm_flags);
-		return 0;
-	}
-
-	/* support for DAX */
-	if (vma_is_dax(vma)) {
-		if (vma->vm_flags & VM_SHARED) {
-			dump_ok = test_bit(MMF_DUMP_DAX_SHARED, &mm_flags);
-			kdcore("%08lx: %08lx: %s (DAX shared)", vma->vm_start,
-			       vma->vm_flags, dump_ok ? "yes" : "no");
-		} else {
-			dump_ok = test_bit(MMF_DUMP_DAX_PRIVATE, &mm_flags);
-			kdcore("%08lx: %08lx: %s (DAX private)", vma->vm_start,
-			       vma->vm_flags, dump_ok ? "yes" : "no");
-		}
-		return dump_ok;
-	}
-
-	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
-		if (file_inode(vma->vm_file)->i_nlink == 0) {
-			dump_ok = test_bit(MMF_DUMP_ANON_SHARED, &mm_flags);
-			kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
-			       vma->vm_flags, dump_ok ? "yes" : "no");
-			return dump_ok;
-		}
-
-		dump_ok = test_bit(MMF_DUMP_MAPPED_SHARED, &mm_flags);
-		kdcore("%08lx: %08lx: %s (share)", vma->vm_start,
-		       vma->vm_flags, dump_ok ? "yes" : "no");
-		return dump_ok;
-	}
-
-#ifdef CONFIG_MMU
-	/* By default, if it hasn't been written to, don't write it out */
-	if (!vma->anon_vma) {
-		dump_ok = test_bit(MMF_DUMP_MAPPED_PRIVATE, &mm_flags);
-		kdcore("%08lx: %08lx: %s (!anon)", vma->vm_start,
-		       vma->vm_flags, dump_ok ? "yes" : "no");
-		return dump_ok;
-	}
-#endif
-
-	dump_ok = test_bit(MMF_DUMP_ANON_PRIVATE, &mm_flags);
-	kdcore("%08lx: %08lx: %s", vma->vm_start, vma->vm_flags,
-	       dump_ok ? "yes" : "no");
-	return dump_ok;
-}
-
 /* An ELF note in memory */
 struct memelfnote
 {
@@ -1529,13 +1459,9 @@ static bool elf_fdpic_dump_segments(stru
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
-		unsigned long addr;
-
-		if (!maydump(vma, cprm->mm_flags))
-			continue;
+		unsigned long size = vma_dump_size(vma, cprm->mm_flags);
 
-		if (!dump_user_range(cprm, vma->vm_start,
-				     vma->vma_end - vma->vm_start))
+		if (!dump_user_range(cprm, vma->vm_start, size))
 			return false;
 	}
 	return true;
@@ -1547,8 +1473,7 @@ static size_t elf_core_vma_data_size(uns
 	size_t size = 0;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next)
-		if (maydump(vma, mm_flags))
-			size += vma->vm_end - vma->vm_start;
+		size += vma_dump_size(vma, mm_flags);
 	return size;
 }
 
@@ -1694,7 +1619,7 @@ static int elf_fdpic_core_dump(struct co
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = maydump(vma, cprm->mm_flags) ? sz : 0;
+		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
 		phdr.p_memsz = sz;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
--- a/fs/coredump.c~coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper
+++ a/fs/coredump.c
@@ -936,3 +936,104 @@ void dump_truncate(struct coredump_param
 	}
 }
 EXPORT_SYMBOL(dump_truncate);
+
+/*
+ * The purpose of always_dump_vma() is to make sure that special kernel mappings
+ * that are useful for post-mortem analysis are included in every core dump.
+ * In that way we ensure that the core dump is fully interpretable later
+ * without matching up the same kernel and hardware config to see what PC values
+ * meant. These special mappings include - vDSO, vsyscall, and other
+ * architecture specific mappings
+ */
+static bool always_dump_vma(struct vm_area_struct *vma)
+{
+	/* Any vsyscall mappings? */
+	if (vma == get_gate_vma(vma->vm_mm))
+		return true;
+
+	/*
+	 * Assume that all vmas with a .name op should always be dumped.
+	 * If this changes, a new vm_ops field can easily be added.
+	 */
+	if (vma->vm_ops && vma->vm_ops->name && vma->vm_ops->name(vma))
+		return true;
+
+	/*
+	 * arch_vma_name() returns non-NULL for special architecture mappings,
+	 * such as vDSO sections.
+	 */
+	if (arch_vma_name(vma))
+		return true;
+
+	return false;
+}
+
+/*
+ * Decide how much of @vma's contents should be included in a core dump.
+ */
+unsigned long vma_dump_size(struct vm_area_struct *vma, unsigned long mm_flags)
+{
+#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
+
+	/* always dump the vdso and vsyscall sections */
+	if (always_dump_vma(vma))
+		goto whole;
+
+	if (vma->vm_flags & VM_DONTDUMP)
+		return 0;
+
+	/* support for DAX */
+	if (vma_is_dax(vma)) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(DAX_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(DAX_PRIVATE))
+			goto whole;
+		return 0;
+	}
+
+	/* Hugetlb memory check */
+	if (is_vm_hugetlb_page(vma)) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
+			goto whole;
+		return 0;
+	}
+
+	/* Do not dump I/O mapped devices or special mappings */
+	if (vma->vm_flags & VM_IO)
+		return 0;
+
+	/* By default, dump shared memory if mapped from an anonymous file. */
+	if (vma->vm_flags & VM_SHARED) {
+		if (file_inode(vma->vm_file)->i_nlink == 0 ?
+		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
+			goto whole;
+		return 0;
+	}
+
+	/* Dump segments that have been written to.  */
+	if ((!IS_ENABLED(CONFIG_MMU) || vma->anon_vma) && FILTER(ANON_PRIVATE))
+		goto whole;
+	if (vma->vm_file == NULL)
+		return 0;
+
+	if (FILTER(MAPPED_PRIVATE))
+		goto whole;
+
+	/*
+	 * If this is the beginning of an executable file mapping,
+	 * dump the first page to aid in determining what was mapped here.
+	 */
+	if (FILTER(ELF_HEADERS) &&
+	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ) &&
+	    (READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
+		return PAGE_SIZE;
+
+#undef	FILTER
+
+	return 0;
+
+whole:
+	return vma->vm_end - vma->vm_start;
+}
--- a/include/linux/coredump.h~coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper
+++ a/include/linux/coredump.h
@@ -16,6 +16,7 @@ extern int dump_skip(struct coredump_par
 extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 extern int dump_align(struct coredump_params *cprm, int align);
 extern void dump_truncate(struct coredump_params *cprm);
+unsigned long vma_dump_size(struct vm_area_struct *vma, unsigned long mm_flags);
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len);
 #ifdef CONFIG_COREDUMP
_

Patches currently in -mm which might be from jannh@google.com are

mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

