Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD37C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Dec 2022 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLMArv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 19:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLMAru (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 19:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305C64FB
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 16:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68DCC612C5
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2022 00:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FF9C433D2;
        Tue, 13 Dec 2022 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670892467;
        bh=g1bfW4l0lE33qC6y0DbKiKIj1GKz3qWNq04a3H2wKsY=;
        h=Date:To:From:Subject:From;
        b=PwCDwqSDrf5q4Y4e9qlrfCYrUIPnPkdhhxCOwmE3rfxUlgoJykACxLnUAprHZ6/s2
         5J5OF68lNYMbmizYgIf4hxPyTtNsUy4zL+0LNLnAWqh9D/G3in209gR6HnSH5VopHc
         YjdV98wBP5qT4MNHMxCoh+bhaW5KMwPPNTmly2ks=
Date:   Mon, 12 Dec 2022 16:47:46 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch removed from -mm tree
Message-Id: <20221213004747.B4FF9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: set head flag before setting compound_order in __prep_compound_gigantic_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-set-head-flag-before-setting-compound_order-in-__prep_compound_gigantic_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


