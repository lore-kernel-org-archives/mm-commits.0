Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CFFC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBCGkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjBCGjq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:39:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844738F252
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01547CE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C87C433D2;
        Fri,  3 Feb 2023 06:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406231;
        bh=KXqoGRe5BXvjb8QReZVxqaL52OCAEcFGRKunV70hNuE=;
        h=Date:To:From:Subject:From;
        b=qlqT8VBAlSFFmYjgTCB5mOYQRGr8Xl5kmWBCYBiwWFx1XumA6RhHNhXw6xzxlfdRS
         Z4ZgC1Ir3ABNza4PF+v8LiUwkVLPa2uuy8xOZNlJT3CLhvugmg96m6lJChHRZdRX4b
         oTKsvtFN2N+FOIjzPpndJLu+8US+jlRzxEHll3W0=
Date:   Thu, 02 Feb 2023 22:37:10 -0800
To:     mm-commits@vger.kernel.org, tom@talpey.com, pc@cjr.nz,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch removed from -mm tree
Message-Id: <20230203063711.59C87C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cifs: convert wdata_alloc_and_fillpages() to use filemap_get_folios_tag()
has been removed from the -mm tree.  Its filename was
     cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: cifs: convert wdata_alloc_and_fillpages() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:34 -0800

This is in preparation for the removal of find_get_pages_range_tag().  Now
also supports the use of large folios.

Since tofind might be larger than the max number of folios in a
folio_batch (15), we loop through filling in wdata->pages pulling more
batches until we either reach tofind pages or run out of folios.

This function may not return all pages in the last found folio before
tofind pages are reached.

Link: https://lkml.kernel.org/r/20230104211448.4804-10-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: Tom Talpey <tom@talpey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/cifs/file.c~cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag
+++ a/fs/cifs/file.c
@@ -2527,14 +2527,40 @@ wdata_alloc_and_fillpages(pgoff_t tofind
 			  unsigned int *found_pages)
 {
 	struct cifs_writedata *wdata;
-
+	struct folio_batch fbatch;
+	unsigned int i, idx, p, nr;
 	wdata = cifs_writedata_alloc((unsigned int)tofind,
 				     cifs_writev_complete);
 	if (!wdata)
 		return NULL;
 
-	*found_pages = find_get_pages_range_tag(mapping, index, end,
-				PAGECACHE_TAG_DIRTY, tofind, wdata->pages);
+	folio_batch_init(&fbatch);
+	*found_pages = 0;
+
+again:
+	nr = filemap_get_folios_tag(mapping, index, end,
+				PAGECACHE_TAG_DIRTY, &fbatch);
+	if (!nr)
+		goto out; /* No dirty pages left in the range */
+
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = fbatch.folios[i];
+
+		idx = 0;
+		p = folio_nr_pages(folio);
+add_more:
+		wdata->pages[*found_pages] = folio_page(folio, idx);
+		folio_get(folio);
+		if (++*found_pages == tofind) {
+			folio_batch_release(&fbatch);
+			goto out;
+		}
+		if (++idx < p)
+			goto add_more;
+	}
+	folio_batch_release(&fbatch);
+	goto again;
+out:
 	return wdata;
 }
 
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

