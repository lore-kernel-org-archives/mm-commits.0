Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0ECC636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjBJAwY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBJAwX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A559C6A73E
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C781B82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37E6C4339C;
        Fri, 10 Feb 2023 00:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990340;
        bh=IldnxbjrjGLA96+mnpEOsoJlJKHf0JDp69sNZHD8bOM=;
        h=Date:To:From:Subject:From;
        b=jzrXIIWgbzTl2PBWk5HX2+MX7pj46EOnSsfW0Go3862e0F9piEK2VDkPJY4k2KlgE
         PwypCYZFdDb9gum3G5gp1S7jOF81J4qtUUF2WjhjbbmasBG6D/88GMaOQnWdIDsWo6
         tNAuzyDxmP1Mcqc/gYSVmvSMR8LsFy7/xAU5rQc4=
Date:   Thu, 09 Feb 2023 16:52:19 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-memcpy_from_file_folio.patch removed from -mm tree
Message-Id: <20230210005219.F37E6C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix memcpy_from_file_folio() integer underflow
has been removed from the -mm tree.  Its filename was
     mm-add-memcpy_from_file_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix memcpy_from_file_folio() integer underflow
Date: Fri, 3 Feb 2023 16:28:40 -0500

If we have a HIGHMEM system with a large folio, 'offset' may be larger
than PAGE_SIZE, and so min_t will cap at 'len' instead of the intended
end-of-page.  That can overflow into the next page which is likely to be
unmapped and fault, but could theoretically copy the wrong data.

Link: https://lkml.kernel.org/r/Y919vmSrtAgsf6K3@casper.infradead.org
Fixes: 00cdf76012ab ("mm: add memcpy_from_file_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-add-memcpy_from_file_folio
+++ a/include/linux/highmem.h
@@ -431,9 +431,10 @@ static inline size_t memcpy_from_file_fo
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
_

Patches currently in -mm which might be from willy@infradead.org are


