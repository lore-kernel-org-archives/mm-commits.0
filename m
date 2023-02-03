Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328A7C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 21:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjBCVd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 16:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjBCVd6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 16:33:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C21A77B1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 13:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gjgHXyqSezMmfpOnSST6z/ghRUhO2fHsX3RKkSvEtA8=; b=mlYma5yFDo0XXecinrWxiymLaA
        4HeWVVHRQ/paFoYmn4J1Roi/x+HyAMadofZPBcsGHPucMJ7oocQE7kVknyfGsEuWVoG3euvk9Ytim
        T7+Mz1cHkJnVX1d5x60gN7LdqB/cY85UIpS7/Sd1rOmbj7sAyM41QP8AzqwLezQnv/AZdlmQD36bB
        le3rkBYprODQ4Nnwhu03xbwnKtauSyCCHbd2nLVNMuEUFGfkVbjj0NgzRSRG5+OPpEm6+cG9lG5ku
        uE/ijq0F+7ilTmHfDTGDy7Tbjpzy6ziJlFQ1ez09wBA8BD/eWdihPzh/TBYxMnQ0MDGywNnK8+J5L
        6cmv9s/g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pO3gs-00Eekg-Sx; Fri, 03 Feb 2023 21:33:50 +0000
Date:   Fri, 3 Feb 2023 21:33:50 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, linux-mm@kvack.org
Subject: Re: [merged mm-stable] mm-add-memcpy_from_file_folio.patch removed
 from -mm tree
Message-ID: <Y919vmSrtAgsf6K3@casper.infradead.org>
References: <20230203063850.3246FC4339C@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203063850.3246FC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Feb 02, 2023 at 10:38:49PM -0800, Andrew Morton wrote:
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I pick the worst time to find bugs in my own code.

From cf8f62107c965eafc2fa9ad0f839269fcb11991d Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 3 Feb 2023 16:28:40 -0500
Subject: [PATCH] mm: Fix memcpy_from_file_folio() integer underflow

If we have a HIGHMEM system with a large folio, 'offset' may be larger
than PAGE_SIZE, and so min_t will cap at 'len' instead of the intended
end-of-page.  That can overflow into the next page which is likely to
be unmapped and fault, but could theoretically copy the wrong data.

Fixes: [no commit ID yet] ("mm: add memcpy_from_file_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/highmem.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 348701dae77f..b06254e76d99 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -431,9 +431,10 @@ static inline size_t memcpy_from_file_folio(char *to, struct folio *folio,
 	size_t offset = offset_in_folio(folio, pos);
 	char *from = kmap_local_folio(folio, offset);
 
-	if (folio_test_highmem(folio))
+	if (folio_test_highmem(folio)) {
+		offset = offset_in_page(offset);
 		len = min_t(size_t, len, PAGE_SIZE - offset);
-	else
+	} else
 		len = min(len, folio_size(folio) - offset);
 
 	memcpy(to, from, len);
-- 
2.35.1

