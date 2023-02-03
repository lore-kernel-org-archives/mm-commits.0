Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7CDC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 22:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCWPO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 17:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjBCWOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 17:14:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEC1AF50D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 14:13:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA26B82C2A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 22:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E596C433D2;
        Fri,  3 Feb 2023 22:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675462426;
        bh=1iWzk2KavpLoJK5p82ahS7/RHM/4/fObC7e3mL6ywA8=;
        h=Date:To:From:Subject:From;
        b=vuklxjO7FuP09D9iDd8A60HLR6numhAQoTE3kPZ0NfYazEwk48v0ijliweAaNt87A
         rJYMRLlNjSFZdkE9pDj4SFJe3ASDpu1rn3CBIal0oEIa4xLps0dB/R8F17I8RvE7Nt
         iDdZX4zbN0N0T8/eotLMO66U/mevqZ8lsp0Xbq4k=
Date:   Fri, 03 Feb 2023 14:13:45 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-memcpy_from_file_folio.patch added to mm-unstable branch
Message-Id: <20230203221346.3E596C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memcpy_from_file_folio() integer underflow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-memcpy_from_file_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-memcpy_from_file_folio.patch

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

mm-add-memcpy_from_file_folio.patch

