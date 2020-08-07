Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85FEC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BDE2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781190;
	bh=ItaENuLzbga2ZYUsDhfJatfHSMpzLwPFCFJTP1wRIYs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KPtpmQois2D4HJhJUnDIjWhzxEBdvNVRbc4HOQi/lyRGy99dco1azoeeQhHY/vq3r
	 nWCSEQjNOkUmw6OAuvYkYU6Bnh95F+UffVreuPlBGFHIY5Z5wPJKhNQDaTtdgD3dpv
	 HtvA63milsmL6E8hD/8odSIn/ji2mnGjcNmTaxsw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGTu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9EB221E5;
        Fri,  7 Aug 2020 06:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781189;
        bh=ItaENuLzbga2ZYUsDhfJatfHSMpzLwPFCFJTP1wRIYs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Se3yqsVe+qRWcqEugDyTGzYFzMlGA79IK0HrXfxZdk8eTN03tpned3oCWLfKz238F
         fsdYKWuydeAa0QqNRbHqyVKLtd+/OLHGvh8GVVzdkLV0yL+S9PUm6FyfU0atwMvaON
         LF+pe8fgWPsz+IcuhSlNp3LPahlAjCzanL/WtPfo=
Date:   Thu, 06 Aug 2020 23:19:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 049/163] mm/debug: print hashed address of struct
 page
Message-ID: <20200807061948.8LG6yOu9l%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print hashed address of struct page

The actual address of the struct page isn't particularly helpful, while
the hashed address helps match with other messages elsewhere.  Add the PFN
that the page refers to in order to help diagnose problems where the page
is improperly aligned for the purpose.

Link: http://lkml.kernel.org/r/20200709202117.7216-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/debug.c~mm-print-hashed-address-of-struct-page
+++ a/mm/debug.c
@@ -95,17 +95,17 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+	pr_warn("page:%p refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			page, page_ref_count(head), mapcount, mapping,
-			page_to_pgoff(page));
+			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head),
 					compound_pincount(head));
 		} else {
-			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head));
 		}
_
