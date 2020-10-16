Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EFAC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CB220878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817963;
	bh=mcabKatnSrGv9eQwPptKXwhqXaLyNcySWns1IXkEmLc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LsFsouwdLaWGgqjYAUm3dlQ7KEMnDIco9jqETh0pBWgwyMsPkqcpLrYFrmPVGk+jy
	 zKFXBpsGC9IPuQTDtUj/MNr+9Pyft5qYPgInXUQdP0MHJhrcUf0L3rOmMEJJ3HmrYA
	 ajcS3hvx1bN3y8GPXN14PgrF16SCcNoFR6HPdIt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390131AbgJPDMn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389908AbgJPDMn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC6E20789;
        Fri, 16 Oct 2020 03:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817961;
        bh=mcabKatnSrGv9eQwPptKXwhqXaLyNcySWns1IXkEmLc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GK2akWmTAmm32khTpqyunvFhhvYhZU2bLW/zNAGUaYQ3VC6c47hvIxn7B0/zsUlTU
         54dgzcwoIzA6j6D6+ytuoQbXW6ep1EDuSD6Eb5Anb2XNhFOCB9VFQ2Yptspc8Lm/gE
         WWnj7AXhDckxwKHFhcGwaycyDFXnX3REMH/Z6ZqY=
Date:   Thu, 15 Oct 2020 20:12:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        hughd@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 136/156] binfmt_elf_fdpic: stop using dump_emit()
 on user pointers on !MMU
Message-ID: <20201016031240.Y1PFKQJQU%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jann Horn <jannh@google.com>
Subject: binfmt_elf_fdpic: stop using dump_emit() on user pointers on !MMU

Patch series "Fix ELF / FDPIC ELF core dumping, and use mmap_lock properly in there", v5.

At the moment, we have that rather ugly mmget_still_valid() helper to work
around <https://crbug.com/project-zero/1790>: ELF core dumping doesn't
take the mmap_sem while traversing the task's VMAs, and if anything (like
userfaultfd) then remotely messes with the VMA tree, fireworks ensue.  So
at the moment we use mmget_still_valid() to bail out in any writers that
might be operating on a remote mm's VMAs.

With this series, I'm trying to get rid of the need for that as cleanly as
possible.  ("cleanly" meaning "avoid holding the mmap_lock across
unbounded sleeps".)


Patches 1, 2, 3 and 4 are relatively unrelated cleanups in the core
dumping code.

Patches 5 and 6 implement the main change: Instead of repeatedly accessing
the VMA list with sleeps in between, we snapshot it at the start with
proper locking, and then later we just use our copy of the VMA list.  This
ensures that the kernel won't crash, that VMA metadata in the coredump is
consistent even in the presence of concurrent modifications, and that any
virtual addresses that aren't being concurrently modified have their
contents show up in the core dump properly.

The disadvantage of this approach is that we need a bit more memory during
core dumping for storing metadata about all VMAs.

At the end of the series, patch 7 removes the old workaround for this
issue (mmget_still_valid()).


I have tested:

 - Creating a simple core dump on X86-64 still works.
 - The created coredump on X86-64 opens in GDB and looks plausible.
 - X86-64 core dumps contain the first page for executable mappings at
   offset 0, and don't contain the first page for non-executable file
   mappings or executable mappings at offset !=0.
 - NOMMU 32-bit ARM can still generate plausible-looking core dumps
   through the FDPIC implementation. (I can't test this with GDB because
   GDB is missing some structure definition for nommu ARM, but I've
   poked around in the hexdump and it looked decent.)


This patch (of 7):

dump_emit() is for kernel pointers, and VMAs describe userspace memory. 
Let's be tidy here and avoid accessing userspace pointers under KERNEL_DS,
even if it probably doesn't matter much on !MMU systems - especially given
that it looks like we can just use the same get_dump_page() as on MMU if
we move it out of the CONFIG_MMU block.

One small change we have to make in get_dump_page() is to use
__get_user_pages_locked() instead of __get_user_pages(), since the latter
doesn't exist on nommu.  On mmu builds, __get_user_pages_locked() will
just call __get_user_pages() for us.

Link: http://lkml.kernel.org/r/20200827114932.3572699-1-jannh@google.com
Link: http://lkml.kernel.org/r/20200827114932.3572699-2-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    8 -----
 mm/gup.c              |   57 +++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 37 deletions(-)

--- a/fs/binfmt_elf_fdpic.c~binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu
+++ a/fs/binfmt_elf_fdpic.c
@@ -1529,14 +1529,11 @@ static bool elf_fdpic_dump_segments(stru
 	struct vm_area_struct *vma;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
-#ifdef CONFIG_MMU
 		unsigned long addr;
-#endif
 
 		if (!maydump(vma, cprm->mm_flags))
 			continue;
 
-#ifdef CONFIG_MMU
 		for (addr = vma->vm_start; addr < vma->vm_end;
 							addr += PAGE_SIZE) {
 			bool res;
@@ -1552,11 +1549,6 @@ static bool elf_fdpic_dump_segments(stru
 			if (!res)
 				return false;
 		}
-#else
-		if (!dump_emit(cprm, (void *) vma->vm_start,
-				vma->vm_end - vma->vm_start))
-			return false;
-#endif
 	}
 	return true;
 }
--- a/mm/gup.c~binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu
+++ a/mm/gup.c
@@ -1490,35 +1490,6 @@ int __mm_populate(unsigned long start, u
 		mmap_read_unlock(mm);
 	return ret;	/* 0 or negative error code */
 }
-
-/**
- * get_dump_page() - pin user page in memory while writing it to core dump
- * @addr: user address
- *
- * Returns struct page pointer of user page pinned for dump,
- * to be freed afterwards by put_page().
- *
- * Returns NULL on any kind of failure - a hole must then be inserted into
- * the corefile, to preserve alignment with its headers; and also returns
- * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
- * allowing a hole to be left in the corefile to save diskspace.
- *
- * Called without mmap_lock, but after all other threads have been killed.
- */
-#ifdef CONFIG_ELF_CORE
-struct page *get_dump_page(unsigned long addr)
-{
-	struct vm_area_struct *vma;
-	struct page *page;
-
-	if (__get_user_pages(current->mm, addr, 1,
-			     FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma,
-			     NULL) < 1)
-		return NULL;
-	flush_cache_page(vma, addr, page_to_pfn(page));
-	return page;
-}
-#endif /* CONFIG_ELF_CORE */
 #else /* CONFIG_MMU */
 static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		unsigned long nr_pages, struct page **pages,
@@ -1564,6 +1535,34 @@ finish_or_fault:
 }
 #endif /* !CONFIG_MMU */
 
+/**
+ * get_dump_page() - pin user page in memory while writing it to core dump
+ * @addr: user address
+ *
+ * Returns struct page pointer of user page pinned for dump,
+ * to be freed afterwards by put_page().
+ *
+ * Returns NULL on any kind of failure - a hole must then be inserted into
+ * the corefile, to preserve alignment with its headers; and also returns
+ * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
+ * allowing a hole to be left in the corefile to save diskspace.
+ *
+ * Called without mmap_lock, but after all other threads have been killed.
+ */
+#ifdef CONFIG_ELF_CORE
+struct page *get_dump_page(unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	struct page *page;
+
+	if (__get_user_pages_locked(current->mm, addr, 1, &page, &vma, NULL,
+				    FOLL_FORCE | FOLL_DUMP | FOLL_GET) < 1)
+		return NULL;
+	flush_cache_page(vma, addr, page_to_pfn(page));
+	return page;
+}
+#endif /* CONFIG_ELF_CORE */
+
 #if defined(CONFIG_FS_DAX) || defined (CONFIG_CMA)
 static bool check_dax_vmas(struct vm_area_struct **vmas, long nr_pages)
 {
_
