Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFEBC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBCGh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjBCGgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485618D627
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A0B61DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A57C433D2;
        Fri,  3 Feb 2023 06:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406175;
        bh=Xd4VE+4E4uZdUGOD4YYhcfFlrB6vtPQHQZZ+9WhgS6k=;
        h=Date:To:From:Subject:From;
        b=Vf41g9H9SXN2t+gLxtrbxTOWlZvutmeW6A4U9AjbK5pqJCsuH78ARMf3MioaPXR1F
         BsmjgkLsEi9OuJT7YcPwN+UQJ/KfjRJ+Mc5GcxsodRPhrpXwYPoQ0AYTSQEN9kt3V5
         MjJLiyEprnN/HVh4vzuTC0vjc9BxBIMR0C0I4IQA=
Date:   Thu, 02 Feb 2023 22:36:14 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        hughd@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_write_end-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230203063614.E6A57C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_write_end() to use a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_write_end-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_write_end() to use a folio
Date: Thu, 12 Jan 2023 13:10:31 +0000

Use a folio internally to shmem_write_end() which saves a number of calls
to compound_head() and lets us get rid of the custom code to zero out the
rest of a THP and supports folios of arbitrary size.

Link: https://lkml.kernel.org/r/20230112131031.1209553-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-convert-shmem_write_end-to-use-a-folio
+++ a/mm/shmem.c
@@ -2578,33 +2578,23 @@ shmem_write_end(struct file *file, struc
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
 
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
-	if (!PageUptodate(page)) {
-		struct page *head = compound_head(page);
-		if (PageTransCompound(page)) {
-			int i;
-
-			for (i = 0; i < HPAGE_PMD_NR; i++) {
-				if (head + i == page)
-					continue;
-				clear_highpage(head + i);
-				flush_dcache_page(head + i);
-			}
-		}
-		if (copied < PAGE_SIZE) {
-			unsigned from = pos & (PAGE_SIZE - 1);
-			zero_user_segments(page, 0, from,
-					from + copied, PAGE_SIZE);
+	if (!folio_test_uptodate(folio)) {
+		if (copied < folio_size(folio)) {
+			size_t from = offset_in_folio(folio, pos);
+			folio_zero_segments(folio, 0, from,
+					from + copied, folio_size(folio));
 		}
-		SetPageUptodate(head);
+		folio_mark_uptodate(folio);
 	}
-	set_page_dirty(page);
-	unlock_page(page);
-	put_page(page);
+	folio_mark_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return copied;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


