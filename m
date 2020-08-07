Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF82C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C79932177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781180;
	bh=hcjiEN1mC7jp49mnfMnVEO2vmtArkqbgEDjs37HuOMQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ri2UnIWP60N3shcGdZNmTbtILhd9lkNiG5A9pKrHtFu6GO/3nVuqbjgQwEyEj+KMa
	 tYRk+AVnr18oPmqVwr0OOO1BEPKM/ISW/lwobqRDeZBHXjuTDsWn+/3QRaDvRC6nEq
	 cjFKNRBeoxWDgerqlI783OeYkl2TwG/w7NOG+3aw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGTk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96BE1221E5;
        Fri,  7 Aug 2020 06:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781180;
        bh=hcjiEN1mC7jp49mnfMnVEO2vmtArkqbgEDjs37HuOMQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AiqF741cpSznTP/wzTjW3LjLDPCIoUE5GUe6vK6sOj8twiO/TBmXR/EBcjT99Rari
         lnvx35MOGfrm5VqMglEJkAxGXRPP8PvzKu4YbhdimYYvCev5sTRVAWRYTZ7uOXaJHE
         WykvXC+LYU3HFRiKb4tUyNlQzNpH4X6puNf8+4W0=
Date:   Thu, 06 Aug 2020 23:19:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 046/163] mm/debug: print head flags in dump_page
Message-ID: <20200807061939.k2nP4sOpR%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print head flags in dump_page

Tail page flags contain very little useful information.  Print the head
page's flags instead.  While the flags will contain "head" for tail pages,
this should not be too confusing as the previous line starts with the word
"head:" and so the flags should be interpreted as belonging to the head
page.

Link: http://lkml.kernel.org/r/20200709202117.7216-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-print-head-flags-in-dump_page
+++ a/mm/debug.c
@@ -168,7 +168,7 @@ void __dump_page(struct page *page, cons
 out_mapping:
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
-	pr_warn("%sflags: %#lx(%pGp)%s\n", type, page->flags, &page->flags,
+	pr_warn("%sflags: %#lx(%pGp)%s\n", type, head->flags, &head->flags,
 		page_cma ? " CMA" : "");
 
 hex_only:
_
