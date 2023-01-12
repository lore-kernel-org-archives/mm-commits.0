Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E47C63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjALVcp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjALVcT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE5395F5
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A4BB8202F
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9E3C433EF;
        Thu, 12 Jan 2023 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558201;
        bh=8+mPDRWLEEOX6dNJfOgbfNPxxkv3p3rErADDH1b0Iek=;
        h=Date:To:From:Subject:From;
        b=i+SRrn6Bo4EgeKiaN/rJZd0dWWS9dp85SoZymDpraLoRn+Q8dVsJA0fofcfg0mfOo
         1W+ox8GCtfieSXuLlERxBLIjl/C5XTUNHdrHWrVaorIs6VH7eA3So5NgMenmzv/gGd
         TtN+vEXJkdDUakImx4LmQ+sha3NxNf6pb0asMNPA=
Date:   Thu, 12 Jan 2023 13:16:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-unpoison_memory-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211641.6C9E3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert unpoison_memory() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-unpoison_memory-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-unpoison_memory-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert unpoison_memory() to folios
Date: Thu, 12 Jan 2023 14:46:08 -0600

Use a folio inside unpoison_memory which replaces a compound_head() call
with a call to page_folio().

Link: https://lkml.kernel.org/r/20230112204608.80136-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-unpoison_memory-to-folios
+++ a/mm/memory-failure.c
@@ -2335,7 +2335,6 @@ core_initcall(memory_failure_init);
  */
 int unpoison_memory(unsigned long pfn)
 {
-	struct page *page;
 	struct folio *folio;
 	struct page *p;
 	int ret = -EBUSY;
@@ -2348,7 +2347,6 @@ int unpoison_memory(unsigned long pfn)
 		return -ENXIO;
 
 	p = pfn_to_page(pfn);
-	page = compound_head(p);
 	folio = page_folio(p);
 
 	mutex_lock(&mf_mutex);
@@ -2360,31 +2358,31 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!PageHWPoison(p)) {
+	if (!folio_test_hwpoison(folio)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_count(page) > 1) {
+	if (folio_ref_count(folio) > 1) {
 		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_mapped(page)) {
+	if (folio_mapped(folio)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (page_mapping(page)) {
+	if (folio_mapping(folio)) {
 		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
-	if (PageSlab(page) || PageTable(page) || PageReserved(page))
+	if (folio_test_slab(folio) || PageTable(&folio->page) || folio_test_reserved(folio))
 		goto unlock_mutex;
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
@@ -2397,7 +2395,7 @@ int unpoison_memory(unsigned long pfn)
 				goto unlock_mutex;
 			}
 		}
-		ret = TestClearPageHWPoison(page) ? 0 : -EBUSY;
+		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
 	} else if (ret < 0) {
 		if (ret == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
@@ -2410,14 +2408,14 @@ int unpoison_memory(unsigned long pfn)
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
 				ret = -EBUSY;
-				put_page(page);
+				folio_put(folio);
 				goto unlock_mutex;
 			}
 		}
 
-		put_page(page);
+		folio_put(folio);
 		if (TestClearPageHWPoison(p)) {
-			put_page(page);
+			folio_put(folio);
 			ret = 0;
 		}
 	}
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch

