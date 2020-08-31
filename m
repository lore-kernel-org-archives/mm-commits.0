Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4DAC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C039207EA
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834188;
	bh=kr0rPZLV57q71vAI2lN3jikhDb2TcxcfyMG+2TOV2ec=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RbgOXHT9eUa4eSZCIKukAltHNZkOkRqw5qJS0gxmDltXhjEEnCVdDC9YgVfSEB6fF
	 yxtAhR3DV2yAXbMCpXooboANyfbkp9Zf+rQQjq3ULA0vF/aIn9OUUEJdFmUdS+63aq
	 JvR3D+F3rpNYxOPvDpuxMy6JuNaXfDchJAW8c0ic=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgHaAg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgHaAg1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 20:36:27 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B26912076D;
        Mon, 31 Aug 2020 00:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834184;
        bh=kr0rPZLV57q71vAI2lN3jikhDb2TcxcfyMG+2TOV2ec=;
        h=Date:From:To:Subject:From;
        b=BAll3nyDJPG+QdlJLA6MFFItNlQBfmrGQTO90Z6T6Y1O+mBCnj337BYEf8qNhRQQG
         /f3Y4MtvXhEjsLb6ox7/6oACcrQb6EzSB2SnhaL+24fqIFveiszh0jvzfFkp4JX5/v
         Ugm030gdOIGba/yNZw9SBTTax1qc748ZbF8/6/V0=
Date:   Sun, 30 Aug 2020 17:36:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, oleg@redhat.com, hch@lst.de,
        ebiederm@xmission.com, jannh@google.com
Subject:  +
 binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch added to
 -mm tree
Message-ID: <20200831003622.7pTEH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf_fdpic: stop using dump_emit() on user pointers on !MMU
has been added to the -mm tree.  Its filename is
     binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1495,35 +1495,6 @@ int __mm_populate(unsigned long start, u
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
@@ -1569,6 +1540,34 @@ finish_or_fault:
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

Patches currently in -mm which might be from jannh@google.com are

binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

