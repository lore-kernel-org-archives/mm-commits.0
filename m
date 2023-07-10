Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CC5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjGJXbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjGJXbd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33298
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB0C61261
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E5FC433C7;
        Mon, 10 Jul 2023 23:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031891;
        bh=NqKGOE/Q7C/jouOxferFyiBPD+bO8nYfHQBwzzCQarA=;
        h=Date:To:From:Subject:From;
        b=eV11NjmN3HgS11ZyF2DIfztZp1wvGY64+GmjEbM0q8efiW4RHwvBnMXhUB0HPSu7+
         29UqPJY+C2Vj595P6CT0F4VOq5n9uM/4eQf5A89fakFJDvTzrZD5X80zLr2mq3hDcw
         wMY7DiU+826eFqMC1bddupcc32OIsSF2lYdgc8gI=
Date:   Mon, 10 Jul 2023 16:31:30 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-flush_icache_pages-in-do_set_pmd.patch added to mm-unstable branch
Message-Id: <20230710233131.72E5FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use flush_icache_pages() in do_set_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-flush_icache_pages-in-do_set_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-flush_icache_pages-in-do_set_pmd.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use flush_icache_pages() in do_set_pmd()
Date: Mon, 10 Jul 2023 21:43:34 +0100

Push the iteration over each page down to the architectures (many can
flush the entire THP without iteration).

Link: https://lkml.kernel.org/r/20230710204339.3554919-34-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-use-flush_icache_pages-in-do_set_pmd
+++ a/mm/memory.c
@@ -4258,7 +4258,6 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
-	int i;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
@@ -4291,8 +4290,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (unlikely(!pmd_none(*vmf->pmd)))
 		goto out;
 
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		flush_icache_page(vma, page + i);
+	flush_icache_pages(vma, page, HPAGE_PMD_NR);
 
 	entry = mk_huge_pmd(page, vma->vm_page_prot);
 	if (write)
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

