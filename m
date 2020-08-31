Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2EFC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE442083E
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 00:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834192;
	bh=hv2Eq6z75BmVQDqB1wUnhXP48xA1wyOnfduTODhjEoY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cgpYYuRRUUatguyedVAWGm5ksYSYdGmg9cggM6PyeEZaStQS+gvYZzJvRmCRfR5WO
	 iuRSIKSewR5zAFBX80P9e5gcQaHmZUEFKmT12uwbBAnkTUaLNEzWhZRLSPiXpAuK+1
	 WVkoGS6nCVWH+0mnb0Z0wXrUJ/23hJfaxQm/mQe4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgHaAgc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 20:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgHaAga (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 20:36:30 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0485B207EA;
        Mon, 31 Aug 2020 00:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598834190;
        bh=hv2Eq6z75BmVQDqB1wUnhXP48xA1wyOnfduTODhjEoY=;
        h=Date:From:To:Subject:From;
        b=dSGB3C4R/sKMjX9PmqyNnOgtIqfjv9aCcbPdAQ6PcGkI/4z+gt4xtsuOv6+gaqFyt
         EklxCAkcenZABHiogsyMF3oXONPFkQ/Lkf2oDTFok6datWfoxMq2AIr0GJqCJ+miSH
         oO5wWzCcyM98K9ECh2URpitDjbeqcOoBqERb4YCo=
Date:   Sun, 30 Aug 2020 17:36:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, oleg@redhat.com, hch@lst.de,
        ebiederm@xmission.com, jannh@google.com
Subject:  +
 coredump-refactor-page-range-dumping-into-common-helper.patch added to -mm
 tree
Message-ID: <20200831003629.tAEMt%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: refactor page range dumping into common helper
has been added to the -mm tree.  Its filename is
     coredump-refactor-page-range-dumping-into-common-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-refactor-page-range-dumping-into-common-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-refactor-page-range-dumping-into-common-helper.patch

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
Subject: coredump: refactor page range dumping into common helper

Both fs/binfmt_elf.c and fs/binfmt_elf_fdpic.c need to dump ranges of
pages into the coredump file.  Extract that logic into a common helper.

Link: http://lkml.kernel.org/r/20200827114932.3572699-4-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c          |   22 ++--------------------
 fs/binfmt_elf_fdpic.c    |   18 +++---------------
 fs/coredump.c            |   34 ++++++++++++++++++++++++++++++++++
 include/linux/coredump.h |    2 ++
 4 files changed, 41 insertions(+), 35 deletions(-)

--- a/fs/binfmt_elf.c~coredump-refactor-page-range-dumping-into-common-helper
+++ a/fs/binfmt_elf.c
@@ -2444,26 +2444,8 @@ static int elf_core_dump(struct coredump
 
 	for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
-		unsigned long addr;
-		unsigned long end;
-
-		end = vma->vm_start + vma_filesz[i++];
-
-		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
-			struct page *page;
-			int stop;
-
-			page = get_dump_page(addr);
-			if (page) {
-				void *kaddr = kmap(page);
-				stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-				kunmap(page);
-				put_page(page);
-			} else
-				stop = !dump_skip(cprm, PAGE_SIZE);
-			if (stop)
-				goto end_coredump;
-		}
+		if (!dump_user_range(cprm, vma->vm_start, vma_filesz[i++]))
+			goto end_coredump;
 	}
 	dump_truncate(cprm);
 
--- a/fs/binfmt_elf_fdpic.c~coredump-refactor-page-range-dumping-into-common-helper
+++ a/fs/binfmt_elf_fdpic.c
@@ -1534,21 +1534,9 @@ static bool elf_fdpic_dump_segments(stru
 		if (!maydump(vma, cprm->mm_flags))
 			continue;
 
-		for (addr = vma->vm_start; addr < vma->vm_end;
-							addr += PAGE_SIZE) {
-			bool res;
-			struct page *page = get_dump_page(addr);
-			if (page) {
-				void *kaddr = kmap(page);
-				res = dump_emit(cprm, kaddr, PAGE_SIZE);
-				kunmap(page);
-				put_page(page);
-			} else {
-				res = dump_skip(cprm, PAGE_SIZE);
-			}
-			if (!res)
-				return false;
-		}
+		if (!dump_user_range(cprm, vma->vm_start,
+				     vma->vma_end - vma->vm_start))
+			return false;
 	}
 	return true;
 }
--- a/fs/coredump.c~coredump-refactor-page-range-dumping-into-common-helper
+++ a/fs/coredump.c
@@ -876,6 +876,40 @@ int dump_skip(struct coredump_params *cp
 }
 EXPORT_SYMBOL(dump_skip);
 
+#ifdef CONFIG_ELF_CORE
+int dump_user_range(struct coredump_params *cprm, unsigned long start,
+		    unsigned long len)
+{
+	unsigned long addr;
+
+	for (addr = start; addr < start + len; addr += PAGE_SIZE) {
+		struct page *page;
+		int stop;
+
+		/*
+		 * To avoid having to allocate page tables for virtual address
+		 * ranges that have never been used yet, and also to make it
+		 * easy to generate sparse core files, use a helper that returns
+		 * NULL when encountering an empty page table entry that would
+		 * otherwise have been filled with the zero page.
+		 */
+		page = get_dump_page(addr);
+		if (page) {
+			void *kaddr = kmap(page);
+
+			stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
+			kunmap(page);
+			put_page(page);
+		} else {
+			stop = !dump_skip(cprm, PAGE_SIZE);
+		}
+		if (stop)
+			return 0;
+	}
+	return 1;
+}
+#endif
+
 int dump_align(struct coredump_params *cprm, int align)
 {
 	unsigned mod = cprm->pos & (align - 1);
--- a/include/linux/coredump.h~coredump-refactor-page-range-dumping-into-common-helper
+++ a/include/linux/coredump.h
@@ -16,6 +16,8 @@ extern int dump_skip(struct coredump_par
 extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
 extern int dump_align(struct coredump_params *cprm, int align);
 extern void dump_truncate(struct coredump_params *cprm);
+int dump_user_range(struct coredump_params *cprm, unsigned long start,
+		    unsigned long len);
 #ifdef CONFIG_COREDUMP
 extern void do_coredump(const kernel_siginfo_t *siginfo);
 #else
_

Patches currently in -mm which might be from jannh@google.com are

binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch

