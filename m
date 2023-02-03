Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A688C64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjBCGgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjBCGf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D374ED1E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61B98CE2EC8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E624C433EF;
        Fri,  3 Feb 2023 06:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406152;
        bh=XobDwkY2dji1Cb02aqlj5lhYQ8hk3JA4DTBL9kY3/EI=;
        h=Date:To:From:Subject:From;
        b=Z0ixPmHbAHfzmOYSQ8vYh6Aa6KOzx5wlfYEPbFZGkOVm6gtlvBTCLnOrm/mA9ncqO
         wxUMQxryWCGsDZi0413hfeTM184E6H5anIkGx3tPY0cLJq6aVHzX0EpKfqooLF/ykg
         Q4/58g0fgUaSV6Div1pfIJ9lXOAW7D/o5aTIX6EQ=
Date:   Thu, 02 Feb 2023 22:35:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-is_transparent_hugepage-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230203063552.9E624C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert is_transparent_hugepage() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-is_transparent_hugepage-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert is_transparent_hugepage() to use a folio
Date: Wed, 11 Jan 2023 14:29:05 +0000

Replace a use of page->compound_dtor with its folio equivalent.

Link: https://lkml.kernel.org/r/20230111142915.1001531-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-convert-is_transparent_hugepage-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -591,12 +591,14 @@ void prep_transhuge_page(struct page *pa
 
 static inline bool is_transparent_hugepage(struct page *page)
 {
+	struct folio *folio;
+
 	if (!PageCompound(page))
 		return false;
 
-	page = compound_head(page);
-	return is_huge_zero_page(page) ||
-	       page[1].compound_dtor == TRANSHUGE_PAGE_DTOR;
+	folio = page_folio(page);
+	return is_huge_zero_page(&folio->page) ||
+	       folio->_folio_dtor == TRANSHUGE_PAGE_DTOR;
 }
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
_

Patches currently in -mm which might be from willy@infradead.org are


