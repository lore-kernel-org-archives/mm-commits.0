Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219D9C64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbjBCGgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjBCGf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF018BDF5
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F4C5CE2EA1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E36C4339C;
        Fri,  3 Feb 2023 06:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406143;
        bh=NjN2mEh1aCL53j9KER4rguvChMCClAfvUzcXiFkFDak=;
        h=Date:To:From:Subject:From;
        b=r7POrJagvo/tilt5/32tlbUi8kxh+poW6CIhNWSl0m0zVfOsr3ukzzXjCpKcGKvtP
         FQ2WTydYfksaWq6BH6ScUomQp+uOicGt9rTl/IczXhRuOfLzoe6yrfE3zOl9Yubawo
         toPZcS7Zjv72GvkaOciUzZV0Xop3dyu6In0cL31Q=
Date:   Thu, 02 Feb 2023 22:35:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-entire_mapcount-in-__page_dup_rmap.patch removed from -mm tree
Message-Id: <20230203063543.D3E36C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use entire_mapcount in __page_dup_rmap()
has been removed from the -mm tree.  Its filename was
     mm-use-entire_mapcount-in-__page_dup_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use entire_mapcount in __page_dup_rmap()
Date: Wed, 11 Jan 2023 14:28:57 +0000

Remove the use of the compound_mapcount_ptr() wrapper, and add an
assertion that we're not passing a tail page if we're duplicating a PMD.

Link: https://lkml.kernel.org/r/20230111142915.1001531-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/rmap.h~mm-use-entire_mapcount-in-__page_dup_rmap
+++ a/include/linux/rmap.h
@@ -208,7 +208,14 @@ void hugepage_add_new_anon_rmap(struct p
 
 static inline void __page_dup_rmap(struct page *page, bool compound)
 {
-	atomic_inc(compound ? compound_mapcount_ptr(page) : &page->_mapcount);
+	if (compound) {
+		struct folio *folio = (struct folio *)page;
+
+		VM_BUG_ON_PAGE(compound && !PageHead(page), page);
+		atomic_inc(&folio->_entire_mapcount);
+	} else {
+		atomic_inc(&page->_mapcount);
+	}
 }
 
 static inline void page_dup_file_rmap(struct page *page, bool compound)
_

Patches currently in -mm which might be from willy@infradead.org are


