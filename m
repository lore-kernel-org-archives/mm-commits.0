Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5500FC001B1
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjFXAAf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjFXAAS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECE02705
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325736155E
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86506C433C8;
        Sat, 24 Jun 2023 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564816;
        bh=1ez/aNlDBWWlSrzxz7yJ80lv+A129UH50Vpkl0CE4jA=;
        h=Date:To:From:Subject:From;
        b=o3u6HDZlQ0g40uLaFr40Wsg5ln+pydgI7G2uAI5UYaA4HQ+aeDPrVRaLK1RHGnv9i
         BCudJ3AAV8PrndBNZDoDqQniPWv3y/uA6PIf5gy6ZO5iw5XuAaEXq7bPXI6tdQF6fg
         bxJAMcM0QbVkoPhipMkmKB1TfPniK7xSxsA4BQ4s=
Date:   Fri, 23 Jun 2023 17:00:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch removed from -mm tree
Message-Id: <20230624000016.86506C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: afs: convert pagevec to folio_batch in afs_extend_writeback()
has been removed from the -mm tree.  Its filename was
     afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: afs: convert pagevec to folio_batch in afs_extend_writeback()
Date: Wed, 21 Jun 2023 17:45:45 +0100

Patch series "Remove pagevecs".

Removes a folio->page->folio conversion for each folio that's involved. 
More importantly, removes one of the last few uses of a pagevec.

Link: https://lkml.kernel.org/r/20230621164557.3510324-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230621164557.3510324-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/afs/write.c~afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback
+++ a/fs/afs/write.c
@@ -465,7 +465,7 @@ static void afs_extend_writeback(struct
 				 bool caching,
 				 unsigned int *_len)
 {
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	struct folio *folio;
 	unsigned long priv;
 	unsigned int psize, filler = 0;
@@ -476,7 +476,7 @@ static void afs_extend_writeback(struct
 	unsigned int i;
 
 	XA_STATE(xas, &mapping->i_pages, index);
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 	do {
 		/* Firstly, we gather up a batch of contiguous dirty pages
@@ -535,7 +535,7 @@ static void afs_extend_writeback(struct
 				stop = false;
 
 			index += folio_nr_pages(folio);
-			if (!pagevec_add(&pvec, &folio->page))
+			if (!folio_batch_add(&fbatch, folio))
 				break;
 			if (stop)
 				break;
@@ -545,14 +545,14 @@ static void afs_extend_writeback(struct
 			xas_pause(&xas);
 		rcu_read_unlock();
 
-		/* Now, if we obtained any pages, we can shift them to being
+		/* Now, if we obtained any folios, we can shift them to being
 		 * writable and mark them for caching.
 		 */
-		if (!pagevec_count(&pvec))
+		if (!folio_batch_count(&fbatch))
 			break;
 
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			folio = page_folio(pvec.pages[i]);
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			folio = fbatch.folios[i];
 			trace_afs_folio_dirty(vnode, tracepoint_string("store+"), folio);
 
 			if (!folio_clear_dirty_for_io(folio))
@@ -565,7 +565,7 @@ static void afs_extend_writeback(struct
 			folio_unlock(folio);
 		}
 
-		pagevec_release(&pvec);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	} while (!stop);
 
_

Patches currently in -mm which might be from willy@infradead.org are


