Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B74C001DE
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjGMRSA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGMRSA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2715F1BD4
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B28A261AEF
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136D0C433C8;
        Thu, 13 Jul 2023 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268678;
        bh=ou1spfJW8v0D3L0Vwi5ozl59hTKtsJeKzD2De/ZL17w=;
        h=Date:To:From:Subject:From;
        b=2NIntiuubhnGFSocb1gf9TMN+SUbdM0fLmEYCagKXEby+lYFbEr3jKYHB/+ktByfO
         wgzY2OoX/73ieDQmNR/JQ1aGyeuypCVBu3cy3LCUXMidfUvFVkSe+aB2MTWc9X9vvP
         8f56faye7Y6kFhKl7e9gEIsMW0qGOVceZBVfM1mQ=
Date:   Thu, 13 Jul 2023 10:17:57 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch added to mm-unstable branch
Message-Id: <20230713171758.136D0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameters in page_table_check_set()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch

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
Subject: mm/page_table_check: remove unused parameters in page_table_check_set()
Date: Fri, 14 Jul 2023 01:26:30 +0800

Remove unused mm and addr in page_table_check_set().

Link: https://lkml.kernel.org/r/20230713172636.1705415-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameters-in-page_table_check_set
+++ a/mm/page_table_check.c
@@ -94,8 +94,7 @@ static void page_table_check_clear(unsig
  * verify that it is of correct type and is not being mapped with a different
  * type to a different process.
  */
-static void page_table_check_set(struct mm_struct *mm, unsigned long addr,
-				 unsigned long pfn, unsigned long pgcnt,
+static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 				 bool rw)
 {
 	struct page_ext *page_ext;
@@ -194,8 +193,7 @@ void __page_table_check_pte_set(struct m
 
 	__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 	if (pte_user_accessible_page(pte)) {
-		page_table_check_set(mm, addr, pte_pfn(pte),
-				     PAGE_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT,
 				     pte_write(pte));
 	}
 }
@@ -209,8 +207,7 @@ void __page_table_check_pmd_set(struct m
 
 	__page_table_check_pmd_clear(mm, addr, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
-		page_table_check_set(mm, addr, pmd_pfn(pmd),
-				     PMD_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
 	}
 }
@@ -224,8 +221,7 @@ void __page_table_check_pud_set(struct m
 
 	__page_table_check_pud_clear(mm, addr, *pudp);
 	if (pud_user_accessible_page(pud)) {
-		page_table_check_set(mm, addr, pud_pfn(pud),
-				     PUD_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT,
 				     pud_write(pud));
 	}
 }
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

