Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3306C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835E82087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817969;
	bh=RMS12A4AtH/1vvv7s/wdNxUJAowc/hTRWWqacDlOe7A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=I3hTnrFYO/yQL7SWIHtJHfmDHOpXb7hYCvumaCkrCNoBKdNfeAPAxe/G5PlZVhJyo
	 urOPgKBK66+Nl3NnlLD7aFWsrRCvMzbBkvcwTxSDKeKCVdrOxhb9REKFkNPqqG8V2j
	 Xya2YFX7wu0DOIKIdr7/anNZFUrGrdtbjxJiv/0M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbgJPDMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389908AbgJPDMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A4C2083B;
        Fri, 16 Oct 2020 03:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817967;
        bh=RMS12A4AtH/1vvv7s/wdNxUJAowc/hTRWWqacDlOe7A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rnYx+1pkDodi/6kjLRqwvlhaclQrVkyH3L3eT8lOd8kLIfKTT+EImhbAfNEkR4XUj
         5NW3pkaER6I7WDKCU3BYLyCAShiJK8nRj7cWUDUp8ugyxTlWzivqIwxhl1Dc5CVhYl
         L6DjyvKG6P+A4FEUuEddpC5W3johIZNJlfC/X3aQ=
Date:   Thu, 15 Oct 2020 20:12:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        hughd@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 138/156] coredump: refactor page range dumping
 into common helper
Message-ID: <20201016031246.pQ_cwOgRv%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Cc: Hugh Dickins <hughd@google.com>
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
