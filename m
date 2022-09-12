Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3F9ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiILDdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiILDcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202651D0E8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 745E2B80C7B
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEC4C433C1;
        Mon, 12 Sep 2022 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953400;
        bh=6sdJIg5ccURnC/xcd/ajyhiLlTQ+16tPbK0Yd8UplIE=;
        h=Date:To:From:Subject:From;
        b=G4coALWjEWZBDxhn0K6hhD4H1wEeXmq3+DPvS+K4LeJK4+QSWCx6sbX1PcwIPGlDw
         2t9OdJDV4XPqc0Ggz6M+XLRmCF2fgzQ9B7EiyFc5hWDRSoiXEn4XtN02jERo5B0/ub
         eTHoZj9JOQ3KZw59xVvD9fdnYCHBmI+0yYN4rGZ0=
Date:   Sun, 11 Sep 2022 20:29:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-add-filemap_get_folios_contig.patch removed from -mm tree
Message-Id: <20220912033000.2BEC4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: add filemap_get_folios_contig()
has been removed from the -mm tree.  Its filename was
     filemap-add-filemap_get_folios_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: filemap: add filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:17 -0700

Patch series "Convert to filemap_get_folios_contig()", v3.

This patch series replaces find_get_pages_contig() with
filemap_get_folios_contig().


This patch (of 7):

This function is meant to replace find_get_pages_contig().

Unlike find_get_pages_contig(), filemap_get_folios_contig() no longer
takes in a target number of pages to find - It returns up to 15 contiguous
folios.

To be more consistent with filemap_get_folios(),
filemap_get_folios_contig() now also updates the start index passed in,
and takes an end index.

Link: https://lkml.kernel.org/r/20220824004023.77310-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20220824004023.77310-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Sterba <dsterb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +
 mm/filemap.c            |   73 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

--- a/include/linux/pagemap.h~filemap-add-filemap_get_folios_contig
+++ a/include/linux/pagemap.h
@@ -718,6 +718,8 @@ static inline struct page *find_subpage(
 
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
+unsigned filemap_get_folios_contig(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_range_tag(struct address_space *mapping, pgoff_t *index,
--- a/mm/filemap.c~filemap-add-filemap_get_folios_contig
+++ a/mm/filemap.c
@@ -2197,6 +2197,79 @@ bool folio_more_pages(struct folio *foli
 }
 
 /**
+ * filemap_get_folios_contig - Get a batch of contiguous folios
+ * @mapping:	The address_space to search
+ * @start:	The starting page index
+ * @end:	The final page index (inclusive)
+ * @fbatch:	The batch to fill
+ *
+ * filemap_get_folios_contig() works exactly like filemap_get_folios(),
+ * except the returned folios are guaranteed to be contiguous. This may
+ * not return all contiguous folios if the batch gets filled up.
+ *
+ * Return: The number of folios found.
+ * Also update @start to be positioned for traversal of the next folio.
+ */
+
+unsigned filemap_get_folios_contig(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, *start);
+	unsigned long nr;
+	struct folio *folio;
+
+	rcu_read_lock();
+
+	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
+			folio = xas_next(&xas)) {
+		if (xas_retry(&xas, folio))
+			continue;
+		/*
+		 * If the entry has been swapped out, we can stop looking.
+		 * No current caller is looking for DAX entries.
+		 */
+		if (xa_is_value(folio))
+			goto update_start;
+
+		if (!folio_try_get_rcu(folio))
+			goto retry;
+
+		if (unlikely(folio != xas_reload(&xas)))
+			goto put_folio;
+
+		if (!folio_batch_add(fbatch, folio)) {
+			nr = folio_nr_pages(folio);
+
+			if (folio_test_hugetlb(folio))
+				nr = 1;
+			*start = folio->index + nr;
+			goto out;
+		}
+		continue;
+put_folio:
+		folio_put(folio);
+
+retry:
+		xas_reset(&xas);
+	}
+
+update_start:
+	nr = folio_batch_count(fbatch);
+
+	if (nr) {
+		folio = fbatch->folios[nr - 1];
+		if (folio_test_hugetlb(folio))
+			*start = folio->index + 1;
+		else
+			*start = folio->index + folio_nr_pages(folio);
+	}
+out:
+	rcu_read_unlock();
+	return folio_batch_count(fbatch);
+}
+EXPORT_SYMBOL(filemap_get_folios_contig);
+
+/**
  * find_get_pages_contig - gang contiguous pagecache lookup
  * @mapping:	The address_space to search
  * @index:	The starting page index
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-convert-filemap_range_has_writeback-to-use-folios.patch

