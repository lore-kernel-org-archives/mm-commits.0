Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3834C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjBCGkf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCGjh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AEB8EB7C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01109CE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C53FC433EF;
        Fri,  3 Feb 2023 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406223;
        bh=6yXSqbpE/O+wcyuH17jEVBOczddXgAJy2BU7XoYtv4g=;
        h=Date:To:From:Subject:From;
        b=rl+TIGhg9K6CctFN1B5Kkv4tmxVQS6UZtw83GU+43ZYjDPVFQWPo2rIgGq8+A/nRi
         fsTnHJIIqLHW6Ie1nnhNJhcFHuqo3MUfhuPvMt6D+wfngftxKwoSYseBbGtACXXmc+
         crC0T9vmJUZTHMIFdTkA9fn64uwOuqkPWBIo6Azc=
Date:   Thu, 02 Feb 2023 22:37:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagemap-add-filemap_grab_folio.patch removed from -mm tree
Message-Id: <20230203063703.3C53FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pagemap: add filemap_grab_folio()
has been removed from the -mm tree.  Its filename was
     pagemap-add-filemap_grab_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: pagemap: add filemap_grab_folio()
Date: Wed, 4 Jan 2023 13:14:26 -0800

Patch series "Convert to filemap_get_folios_tag()", v5.

This patch series replaces find_get_pages_range_tag() with
filemap_get_folios_tag().  This also allows the removal of multiple calls
to compound_head() throughout.

It also makes a good chunk of the straightforward conversions to folios,
and takes the opportunity to introduce a function that grabs a folio from
the pagecache.


This patch (of 23):

Add function filemap_grab_folio() to grab a folio from the page cache. 
This function is meant to serve as a folio replacement for
grab_cache_page, and is used to facilitate the removal of
find_get_pages_range_tag().

Link: https://lkml.kernel.org/r/20230104211448.4804-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230104211448.4804-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/pagemap.h~pagemap-add-filemap_grab_folio
+++ a/include/linux/pagemap.h
@@ -547,6 +547,26 @@ static inline struct folio *filemap_lock
 }
 
 /**
+ * filemap_grab_folio - grab a folio from the page cache
+ * @mapping: The address space to search
+ * @index: The page index
+ *
+ * Looks up the page cache entry at @mapping & @index. If no folio is found,
+ * a new folio is created. The folio is locked, marked as accessed, and
+ * returned.
+ *
+ * Return: A found or created folio. NULL if no folio is found and failed to
+ * create a folio.
+ */
+static inline struct folio *filemap_grab_folio(struct address_space *mapping,
+					pgoff_t index)
+{
+	return __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+			mapping_gfp_mask(mapping));
+}
+
+/**
  * find_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

