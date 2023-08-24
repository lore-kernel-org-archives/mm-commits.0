Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2819EC727B5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244081AbjHXXW1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244076AbjHXXV5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC321BD8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA2A265314
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACDEC433C8;
        Thu, 24 Aug 2023 23:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919310;
        bh=t8dSe+BC9jabWQiWJeDpPyz4Szm8z++20zVslemZbuU=;
        h=Date:To:From:Subject:From;
        b=LRjPXLCkx2LSDwt0Ee6VQOdy4dB+HBK9qMNeznKLTqIuvh7MBryZRG6zbK4Z82ZkF
         7ZYJ2wLEnhEsOuPAtK10dN5sl6S+So4VGYz0FtQ2XB6pZJpPpWR9+P/M98ghktbqgr
         Aq9mLshAZuR75BgUKIMaxgbtvU5JuSNjogJxLmM4=
Date:   Thu, 24 Aug 2023 16:21:49 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-flush_icache_pages-in-do_set_pmd.patch removed from -mm tree
Message-Id: <20230824232150.4ACDEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use flush_icache_pages() in do_set_pmd()
has been removed from the -mm tree.  Its filename was
     mm-use-flush_icache_pages-in-do_set_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use flush_icache_pages() in do_set_pmd()
Date: Wed, 2 Aug 2023 16:14:01 +0100

Push the iteration over each page down to the architectures (many can
flush the entire THP without iteration).

Link: https://lkml.kernel.org/r/20230802151406.3735276-34-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-use-flush_icache_pages-in-do_set_pmd
+++ a/mm/memory.c
@@ -4265,7 +4265,6 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
-	int i;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
@@ -4298,8 +4297,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (unlikely(!pmd_none(*vmf->pmd)))
 		goto out;
 
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		flush_icache_page(vma, page + i);
+	flush_icache_pages(vma, page, HPAGE_PMD_NR);
 
 	entry = mk_huge_pmd(page, vma->vm_page_prot);
 	if (write)
_

Patches currently in -mm which might be from willy@infradead.org are


