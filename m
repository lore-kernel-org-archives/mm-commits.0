Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803FAC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E4F2312F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389999AbhAMAms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392008AbhALXua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E61D2313B;
        Tue, 12 Jan 2021 23:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495371;
        bh=cQ8I36j8H9JUNH2R/BgaKtz/5iOLvdA2oPFMmOIDp7E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yNeel/ruxmV2U4aSEdbG0h/4v1MZdRVGXXTA+zo0xiTo89mhVAceINDQ5vYe2vyUy
         l0P1pFQl1TMBNoapzgyEh7ukGefAUD4xtQPxjYn8t8lqyY5udSxGFDjlNuLavUi1AX
         EyptjsWz2UtSnzTCrr+E0wLFoRpW5QKI0xjS72pU=
Date:   Tue, 12 Jan 2021 15:49:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dan.carpenter@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org
Subject:  [patch 09/10] mm,hwpoison: fix printing of page flags
Message-ID: <20210112234930.wzhtCPbgI%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: fix printing of page flags

Format %pG expects a lower case 'p' in order to print the flags.
Fix it.

Link: https://lkml.kernel.org/r/20210108085202.4506-1-osalvador@suse.de
Fixes: 8295d535e2aa ("mm,hwpoison: refactor get_any_page")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-fix-printing-of-page-flags
+++ a/mm/memory-failure.c
@@ -1940,7 +1940,7 @@ retry:
 			goto retry;
 		}
 	} else if (ret == -EIO) {
-		pr_info("%s: %#lx: unknown page type: %lx (%pGP)\n",
+		pr_info("%s: %#lx: unknown page type: %lx (%pGp)\n",
 			 __func__, pfn, page->flags, &page->flags);
 	}
 
_
