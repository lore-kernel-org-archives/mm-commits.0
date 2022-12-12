Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EE9C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 23:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiLLXCJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 18:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiLLXCI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 18:02:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61A915813
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 15:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CD87B80E9B
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 23:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0592EC433EF;
        Mon, 12 Dec 2022 23:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670886125;
        bh=E0Oxr35xmltyG23duG9I62NULnLDZC6xtFu6MirZfh0=;
        h=Date:To:From:Subject:From;
        b=OKF3KzL5pFUXP+V0vt77Y1VvEg9T9fgIKz/oUdsZ5KczfkWS2qHV/xRuEa8xwv3Rk
         Qj8RKPLdD3RKJaFU/bfEjMxYRxW0tS5UMG4xW1u7hR6BUxSKA7jTz1a23jcxnN6Fba
         OQoRUH3yBW5+Uv+bX2SAgPr75BPnDPWOLiNX/s2E=
Date:   Mon, 12 Dec 2022 15:02:04 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch added to mm-unstable branch
Message-Id: <20221212230205.0592EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: set head flag before setting compound_order in __prep_compound_gigantic_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch

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
Subject: mm/hugetlb: set head flag before setting compound_order in __prep_compound_gigantic_folio
Date: Mon, 12 Dec 2022 14:55:29 -0800

folio_set_compound_order() checks if the passed in folio is a large folio.
A large folio is indicated by the PG_head flag.  Call __folio_set_head()
before setting the order.

Link: https://lkml.kernel.org/r/20221212225529.22493-1-sidhartha.kumar@oracle.com
Fixes: d1c6095572d0 ("mm/hugetlb: convert hugetlb prep functions to folios")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio
+++ a/mm/hugetlb.c
@@ -1805,10 +1805,10 @@ static bool __prep_compound_gigantic_fol
 	int nr_pages = 1 << order;
 	struct page *p;
 
-	/* we rely on prep_new_hugetlb_folio to set the destructor */
-	folio_set_compound_order(folio, order);
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
+	/* we rely on prep_new_hugetlb_folio to set the destructor */
+	folio_set_compound_order(folio, order);
 	for (i = 0; i < nr_pages; i++) {
 		p = folio_page(folio, i);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch

