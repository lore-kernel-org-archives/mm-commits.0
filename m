Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C6CC6379F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjBMXzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjBMXzc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F222A1817C
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5715B81A2C
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57444C4339C;
        Mon, 13 Feb 2023 23:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332528;
        bh=wreSVnn6VKaeyOOIIhj7rNWJ5YNrRqc/Arrle1bJMMY=;
        h=Date:To:From:Subject:From;
        b=1gzY0SZpXPsl4Ty2plimUfYgk8ljZlxlpPQz4Af6JgJGuLLDW8rHsqNWm8xbSISkc
         CKITEPxVd4k3bIqof+S5dbMQGvc54a2XY7j/izoniZt2G6W4oYt5L9cKmGXbxDq9no
         SKuXVpIOUcvwfZUc+bQcs5zOE++mQvBQ9YptqTis=
Date:   Mon, 13 Feb 2023 15:55:27 -0800
To:     mm-commits@vger.kernel.org, jane.chu@oracle.com,
        fengwei.yin@intel.com, david@redhat.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_estimated_sharers.patch removed from -mm tree
Message-Id: <20230213235528.57444C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_estimated_sharers()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_estimated_sharers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: add folio_estimated_sharers()
Date: Mon, 30 Jan 2023 12:18:28 -0800

Patch series "Convert various mempolicy.c functions to use folios", v4.

This patch series converts migrate_page_add() and queue_pages_required()
to migrate_folio_add() and queue_page_required().  It also converts the
callers of the functions to use folios as well, and introduces a helper
function to estimate the number of sharers of a folio.


This patch (of 6):

folio_estimated_sharers() takes in a folio and returns the precise number
of times the first subpage of the folio is mapped.

This function aims to provide an estimate for the number of sharers of a
folio.  This is necessary for folio conversions where we care about the
number of processes that share a folio, but don't necessarily want to
check every single page within that folio.

This is in contrast to folio_mapcount() which calculates the total number
of the times a folio and all its subpages are mapped.

Link: https://lkml.kernel.org/r/20230130201833.27042-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230130201833.27042-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-add-folio_estimated_sharers
+++ a/include/linux/mm.h
@@ -1916,6 +1916,24 @@ static inline size_t folio_size(struct f
 	return PAGE_SIZE << folio_order(folio);
 }
 
+/**
+ * folio_estimated_sharers - Estimate the number of sharers of a folio.
+ * @folio: The folio.
+ *
+ * folio_estimated_sharers() aims to serve as a function to efficiently
+ * estimate the number of processes sharing a folio. This is done by
+ * looking at the precise mapcount of the first subpage in the folio, and
+ * assuming the other subpages are the same. This may not be true for large
+ * folios. If you want exact mapcounts for exact calculations, look at
+ * page_mapcount() or folio_total_mapcount().
+ *
+ * Return: The estimated number of processes sharing a folio.
+ */
+static inline int folio_estimated_sharers(struct folio *folio)
+{
+	return page_mapcount(folio_page(folio, 0));
+}
+
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 static inline int arch_make_page_accessible(struct page *page)
 {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


