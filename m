Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1FDC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5592177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781177;
	bh=86nAWFLKlXEPp/TPLCAlfDHKQibf1P+rJgdFUDeUgF0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F5QMfAtTDpOW5zViOMXtZkgVXTtYNS3DHeXwXbkvd1N4iMUnsKiKZurOf3Jx6HZGi
	 Yzb2/L5t8no3hbXS/tEs9J8Gwm5NdGUVHipa0nWZKb91bPT3X/hhtjKqKj96gBwf3g
	 A0/cwYLfBJdd5C4Q5ItaxjK6V1lSt7p+MDVELZgE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGGTh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B57B221E5;
        Fri,  7 Aug 2020 06:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781176;
        bh=86nAWFLKlXEPp/TPLCAlfDHKQibf1P+rJgdFUDeUgF0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gjWBkB0Y3oWxX7FUGfGBpCcQInt5FCtFdKuL/p4jxe6gUWwsKoWvPgLFH5kehKDkY
         P48dy1hepKqEz4pRfRZKK3LXkJ+TC0vTG+esgWN/UXMJAEVKwY7emZDqnrV5ywq2gN
         IojXfoFcwTxnE/Jm2c8cqVyztR097S6sah4pCm/4=
Date:   Thu, 06 Aug 2020 23:19:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 045/163] mm/debug: dump compound page information
 on a second line
Message-ID: <20200807061935.l0Lk7LmQ5%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: dump compound page information on a second line

Simplify both the implementation and the output by splitting all the
compound page information onto a second line.

Link: http://lkml.kernel.org/r/20200709202117.7216-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/mm/debug.c~mm-dump-compound-page-information-on-a-second-line
+++ a/mm/debug.c
@@ -95,27 +95,21 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	if (compound)
+	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+			page, page_ref_count(head), mapcount, mapping,
+			page_to_pgoff(page));
+	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d compound_pincount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page),
-				compound_pincount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head),
+					compound_pincount(head));
 		} else {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head));
 		}
-	else
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
-			page, page_ref_count(page), mapcount,
-			mapping, page_to_pgoff(page));
+	}
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
_
