Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1ECC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354593AbiCYBPE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357213AbiCYBPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C1549F1A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A32546187F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A31C340EE;
        Fri, 25 Mar 2022 01:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170808;
        bh=Bg3plHV89qnMDf1nib8RtzEZpsi+NIFHvXU485tLLC8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ArP9H+YQxuUUnT9h1UBtLOcjjk4JSjPgqboD11c42Hi+QZNfftgScDsany0xbj2tH
         gmPjONCCWvvsBbpVGCpyztawQJKhPUHaQwvdpiIAR2M9rZIdb6YToks9gwJ4DWHr44
         sALKAZCgIuBEcWMqAplA+b1OmbMrlnwtMpEDj2ec=
Date:   Thu, 24 Mar 2022 18:13:27 -0700
To:     willy@infradead.org, william.kucharski@oracle.com,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 098/114] mm/huge_memory: make is_transparent_hugepage() static
Message-Id: <20220325011328.01A31C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: make is_transparent_hugepage() static

It's only used inside the huge_memory.c now. Don't export it and make
it static. We can thus reduce the size of huge_memory.o a bit.

Without this patch:
   text	   data	    bss	    dec	    hex	filename
  32319	   2965	      4	  35288	   89d8	mm/huge_memory.o

With this patch:
   text	   data	    bss	    dec	    hex	filename
  32042	   2957	      4	  35003	   88bb	mm/huge_memory.o

Link: https://lkml.kernel.org/r/20220302082145.12028-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ------
 mm/huge_memory.c        |    3 +--
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-make-is_transparent_hugepage-static
+++ a/include/linux/huge_mm.h
@@ -183,7 +183,6 @@ unsigned long thp_get_unmapped_area(stru
 
 void prep_transhuge_page(struct page *page);
 void free_transhuge_page(struct page *page);
-bool is_transparent_hugepage(struct page *page);
 
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
@@ -341,11 +340,6 @@ static inline bool transhuge_vma_enabled
 
 static inline void prep_transhuge_page(struct page *page) {}
 
-static inline bool is_transparent_hugepage(struct page *page)
-{
-	return false;
-}
-
 #define transparent_hugepage_flags 0UL
 
 #define thp_get_unmapped_area	NULL
--- a/mm/huge_memory.c~mm-huge_memory-make-is_transparent_hugepage-static
+++ a/mm/huge_memory.c
@@ -533,7 +533,7 @@ void prep_transhuge_page(struct page *pa
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-bool is_transparent_hugepage(struct page *page)
+static inline bool is_transparent_hugepage(struct page *page)
 {
 	if (!PageCompound(page))
 		return false;
@@ -542,7 +542,6 @@ bool is_transparent_hugepage(struct page
 	return is_huge_zero_page(page) ||
 	       page[1].compound_dtor == TRANSHUGE_PAGE_DTOR;
 }
-EXPORT_SYMBOL_GPL(is_transparent_hugepage);
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len,
_
