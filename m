Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99905C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbjHKW6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbjHKW6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CAE2694
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA0A672B1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13658C433B9;
        Fri, 11 Aug 2023 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794713;
        bh=rOR28UdVAv5EsGsJD9WqsGlbob5ldZ/BrKC2xkP7ZPo=;
        h=Date:To:From:Subject:From;
        b=GSe1f1TxedmtVhVcRfPQzTlYS6a1fa+VZGiH8/Q5pmULBEMIJ5RshKWAIWlRXQZcm
         ub5dfclovGk0muwo/En7wSXAkivOh2Bb/+EcTyrZLkIdt/Yxg1WiCIZnKomGFRWZJX
         SNCPW+MnCQyKK/W2xD2VIEi6wBw6A9sU3zqpKmKY=
Date:   Fri, 11 Aug 2023 15:58:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_rmapping.patch removed from -mm tree
Message-Id: <20230811225833.13658C433B9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove page_rmapping()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_rmapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: remove page_rmapping()
Date: Sat, 1 Jul 2023 11:28:53 +0800

After converting the last user to folio_raw_mapping(), we can safely
remove the function.

Link: https://lkml.kernel.org/r/20230701032853.258697-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/util.c          |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_rmapping
+++ a/include/linux/mm.h
@@ -2170,7 +2170,6 @@ static inline void *folio_address(const
 	return page_address(&folio->page);
 }
 
-extern void *page_rmapping(struct page *page);
 extern pgoff_t __page_file_index(struct page *page);
 
 /*
--- a/mm/util.c~mm-remove-page_rmapping
+++ a/mm/util.c
@@ -734,12 +734,6 @@ void *vcalloc(size_t n, size_t size)
 }
 EXPORT_SYMBOL(vcalloc);
 
-/* Neutral page->mapping pointer to address_space or anon_vma or other */
-void *page_rmapping(struct page *page)
-{
-	return folio_raw_mapping(page_folio(page));
-}
-
 struct anon_vma *folio_anon_vma(struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch

