Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73858C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjBCGgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBCGf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D1C8B326
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CEBFB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD69C433D2;
        Fri,  3 Feb 2023 06:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406146;
        bh=TYDIzcXkvFnpOarc9kXmu/3I56ykh5BgX8IKXU5nVdI=;
        h=Date:To:From:Subject:From;
        b=qSAoufhN0eyV8kn1dNq9s4DuVIJI9bdnjQ2gXaNFJRtqipoycmODr62hSiJz9JoG3
         E7VP/X9U7Et8CzOYALWjdHcWacPVt/QL0UGFdHQ73f3J9QfPQHQpv5hlyxLsxsid2O
         kW5MmSszH/ENuUTHvmnWqbefSBWY10Rk0lRF6Ldk=
Date:   Thu, 02 Feb 2023 22:35:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch removed from -mm tree
Message-Id: <20230203063546.CAD69C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_mapcount() to use folio_entire_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_mapcount() to use folio_entire_mapcount()
Date: Wed, 11 Jan 2023 14:29:00 +0000

Remove a use of head_compound_mapcount().

Link: https://lkml.kernel.org/r/20230111142915.1001531-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-convert-page_mapcount-to-use-folio_entire_mapcount
+++ a/include/linux/mm.h
@@ -853,22 +853,26 @@ static inline void page_mapcount_reset(s
 	atomic_set(&(page)->_mapcount, -1);
 }
 
-/*
- * Mapcount of 0-order page; when compound sub-page, includes
- * compound_mapcount of compound_head of page.
+/**
+ * page_mapcount() - Number of times this precise page is mapped.
+ * @page: The page.
  *
- * Result is undefined for pages which cannot be mapped into userspace.
+ * The number of times this page is mapped.  If this page is part of
+ * a large folio, it includes the number of times this page is mapped
+ * as part of that folio.
+ *
+ * The result is undefined for pages which cannot be mapped into userspace.
  * For example SLAB or special types of pages. See function page_has_type().
- * They use this place in struct page differently.
+ * They use this field in struct page differently.
  */
 static inline int page_mapcount(struct page *page)
 {
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
-	if (likely(!PageCompound(page)))
-		return mapcount;
-	page = compound_head(page);
-	return head_compound_mapcount(page) + mapcount;
+	if (unlikely(PageCompound(page)))
+		mapcount += folio_entire_mapcount(page_folio(page));
+
+	return mapcount;
 }
 
 int folio_total_mapcount(struct folio *folio);
_

Patches currently in -mm which might be from willy@infradead.org are


