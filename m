Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BBAC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2815060F21
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347940AbhIBV7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348060AbhIBV7S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA0FF6056B;
        Thu,  2 Sep 2021 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619900;
        bh=tcYDePsJXOgKfFVlykrCWnHLSrKWRARiWMeKK2k+CHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Eiknu+S1yMZ/tEUE7XD8R1F7jeYO20LEcfcjqkD0YogXCzuvMoywjjNPBZbAldMX7
         rCsfLO2KmmPyk443YNzGaKX1Tyfkdrd9Y3+3EDaBmd1x5SGeh2RJ6OGvfVtRm0EOQj
         Er/plK/4ABsvwKo9oeesqnrfyeY/31ipfRxiwLE0=
Date:   Thu, 02 Sep 2021 14:58:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 158/212] mm/hwpoison: remove unneeded variable
 unmap_success
Message-ID: <20210902215819.1naFcw3F7%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: remove unneeded variable unmap_success

Patch series "Cleanups and fixup for hwpoison"

This series contains cleanups to remove unneeded variable, fix some
obsolete comments and so on.  Also we fix potential pte_unmap_unlock on
wrong pte.  More details can be found in the respective changelogs.


This patch (of 4):

unmap_success is used to indicate whether page is successfully unmapped
but it's irrelated with ZONE_DEVICE page and unmap_success is always true
here.  Remove this unneeded one.

Link: https://lkml.kernel.org/r/20210814105131.48814-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210814105131.48814-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-unneeded-variable-unmap_success
+++ a/mm/memory-failure.c
@@ -1518,7 +1518,6 @@ static int memory_failure_dev_pagemap(un
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
-	const bool unmap_success = true;
 	unsigned long size = 0;
 	struct to_kill *tk;
 	LIST_HEAD(tokill);
@@ -1590,7 +1589,7 @@ static int memory_failure_dev_pagemap(un
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
+	kill_procs(&tokill, flags & MF_MUST_KILL, false, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
_
