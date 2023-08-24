Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3866EE49B8
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbjHXXVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjHXXVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3E9A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C14E646AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C69EC433C7;
        Thu, 24 Aug 2023 23:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919276;
        bh=+0GJQyRHJb6ovDXCvFVnGyHEG9H8G+tY/ozVplxaJKY=;
        h=Date:To:From:Subject:From;
        b=VNCAtfRKxj8wucVY237dEIcdd+eIG3BgwtgakHpyYcqj4LnHIbhCsZtgKETxcPeio
         yyWI6EQbxpU6xlqRgBLOK2nFdZAj4toNJBAcnR3E2fXWAuQVJCOPgEenYwl4cBGlFm
         vWhptI77Y7kHuCZM/hqaMpfEBmN0SWTqsLrOveRE=
Date:   Thu, 24 Aug 2023 16:21:15 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_flush_mapping.patch removed from -mm tree
Message-Id: <20230824232116.7C69EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_flush_mapping()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_flush_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_flush_mapping()
Date: Wed, 2 Aug 2023 16:13:32 +0100

This is the folio equivalent of page_mapping_file(), but rename it to make
it clear that it's very different from page_file_mapping(). 
Theoretically, there's nothing flush-only about it, but there are no other
users today, and I doubt there will be; it's almost always more useful to
know the swapfile's mapping or the swapcache's mapping.

Link: https://lkml.kernel.org/r/20230802151406.3735276-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-add-folio_flush_mapping
+++ a/include/linux/pagemap.h
@@ -389,6 +389,26 @@ static inline struct address_space *foli
 	return folio->mapping;
 }
 
+/**
+ * folio_flush_mapping - Find the file mapping this folio belongs to.
+ * @folio: The folio.
+ *
+ * For folios which are in the page cache, return the mapping that this
+ * page belongs to.  Anonymous folios return NULL, even if they're in
+ * the swap cache.  Other kinds of folio also return NULL.
+ *
+ * This is ONLY used by architecture cache flushing code.  If you aren't
+ * writing cache flushing code, you want either folio_mapping() or
+ * folio_file_mapping().
+ */
+static inline struct address_space *folio_flush_mapping(struct folio *folio)
+{
+	if (unlikely(folio_test_swapcache(folio)))
+		return NULL;
+
+	return folio_mapping(folio);
+}
+
 static inline struct address_space *page_file_mapping(struct page *page)
 {
 	return folio_file_mapping(page_folio(page));
@@ -399,11 +419,7 @@ static inline struct address_space *page
  */
 static inline struct address_space *page_mapping_file(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-
-	if (unlikely(folio_test_swapcache(folio)))
-		return NULL;
-	return folio_mapping(folio);
+	return folio_flush_mapping(page_folio(page));
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


