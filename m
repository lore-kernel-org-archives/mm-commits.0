Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302DFEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjFUUOQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFUUON (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFFC199B
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C10E616C0
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E9C433C0;
        Wed, 21 Jun 2023 20:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378451;
        bh=Wn6ROtjv9C+7LMSbJJl00S6OWI6sDWPT7xNimqgcdVs=;
        h=Date:To:From:Subject:From;
        b=y4xsNcByr74uLxXbO550VB2ZpkMrEeCqGnhdJt0b23slyjR5DO8Ely+b58XStCsrR
         CM8ryFw8oGZLUXgIj54vEH2r3BKBHf+GzhhwUKkB+BzkhcFdn5BH2fcld9SDuHdQYL
         TXtJeputeyd2YwNIpaf3rQdwFCSgvjDlAAtJ+pzA=
Date:   Wed, 21 Jun 2023 13:14:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch added to mm-unstable branch
Message-Id: <20230621201411.5F2E9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: afs: convert pagevec to folio_batch in afs_extend_writeback()
has been added to the -mm mm-unstable branch.  Its filename is
     afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

