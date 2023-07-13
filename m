Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E59EC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjGMRR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGMRR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:17:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8F2110
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00AB61AE3
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D88C433C7;
        Thu, 13 Jul 2023 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268676;
        bh=ObigR0w2RpjCKQDbGUuszBKsyJ0bxt6ZgXShlVcKRQg=;
        h=Date:To:From:Subject:From;
        b=G+l/QC0PrjuM8Yt/zqjWO/J9HuSSZEnAKW4KVq25PFG6VXhH253b99SoaEd0U7thk
         kLGnGiLXQSB8mInEHBuQtMdUK3KU6e9jhmVXXRyb7zrGua+hQI8Rlo2PDsefd9XLKu
         kC8Og4pGUMIn+LNaSbgrfSYs2Gk6siQbEpJMqF8c=
Date:   Thu, 13 Jul 2023 10:17:55 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch added to mm-unstable branch
Message-Id: <20230713171756.45D88C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameters in page_table_check_clear()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameters in page_table_check_clear()
Date: Fri, 14 Jul 2023 01:26:29 +0800

Patch series "Remove unused parameters in page_table_check".

This series remove unused parameters in functions from page_table_check. 
The first 2 patches remove unused mm and addr parameters in static common
functions page_table_check_clear and page_table_check_set.  The last 6
patches remove unused addr parameter in some externed functions which only
need addr for cleaned page_table_check_clear or page_table_check_set. 
There is no intended functional change.  


This patch (of 8):

Remove unused mm and addr in function page_table_check_clear().

Link: https://lkml.kernel.org/r/20230713172636.1705415-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230713172636.1705415-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameters-in-page_table_check_clear
+++ a/mm/page_table_check.c
@@ -58,8 +58,7 @@ static struct page_table_check *get_page
  * An entry is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
  */
-static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
-				   unsigned long pfn, unsigned long pgcnt)
+static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 {
 	struct page_ext *page_ext;
 	struct page *page;
@@ -158,8 +157,7 @@ void __page_table_check_pte_clear(struct
 		return;
 
 	if (pte_user_accessible_page(pte)) {
-		page_table_check_clear(mm, addr, pte_pfn(pte),
-				       PAGE_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
@@ -171,8 +169,7 @@ void __page_table_check_pmd_clear(struct
 		return;
 
 	if (pmd_user_accessible_page(pmd)) {
-		page_table_check_clear(mm, addr, pmd_pfn(pmd),
-				       PMD_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
@@ -184,8 +181,7 @@ void __page_table_check_pud_clear(struct
 		return;
 
 	if (pud_user_accessible_page(pud)) {
-		page_table_check_clear(mm, addr, pud_pfn(pud),
-				       PUD_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch

