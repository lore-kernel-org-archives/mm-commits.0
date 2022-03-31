Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E0AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 05:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiCaFIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 01:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCaFIa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 01:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9303542EE6
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 22:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C3E61565
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 05:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D34C340ED;
        Thu, 31 Mar 2022 05:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648703202;
        bh=1EVdpdy3n703MubyUFujSo+XyoUEY8Zm8ce7xfG2So4=;
        h=Date:To:From:Subject:From;
        b=xGIgIcHwEq8FGXIz/HrfcqEOaOqKqnEWbXYqtdl6eQUOQ+b1E//mKJuwDAboAdUWT
         bVSJeMO/Gp6w5bEdniHMBw4Qiye+Fn7XULBlVRx1Iy69foNQ7Yg+cs6GlkbnBumzHZ
         4q8TXHD7n+mJgEloo+7N7s5YWqxWX6qfWL30XcYo=
Date:   Wed, 30 Mar 2022 22:06:41 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-fix-missing-writeprotect-the-pte-entry-v6.patch added to -mm tree
Message-Id: <20220331050642.29D34C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax-fix-missing-writeprotect-the-pte-entry-v6
has been added to the -mm tree.  Its filename is
     dax-fix-missing-writeprotect-the-pte-entry-v6.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-fix-missing-writeprotect-the-pte-entry-v6.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-missing-writeprotect-the-pte-entry-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: dax-fix-missing-writeprotect-the-pte-entry-v6

fold dax_entry_mkclean() into dax_writeback_one()

Link: https://lkml.kernel.org/r/20220329134853.68403-6-songmuchun@bytedance.com
Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/fs/dax.c~dax-fix-missing-writeprotect-the-pte-entry-v6
+++ a/fs/dax.c
@@ -790,26 +790,12 @@ static void *dax_insert_entry(struct xa_
 	return entry;
 }
 
-/* Walk all mappings of a given index of a file and writeprotect them */
-static void dax_entry_mkclean(struct address_space *mapping, unsigned long pfn,
-			      unsigned long npfn, pgoff_t start)
-{
-	struct vm_area_struct *vma;
-	pgoff_t end = start + npfn - 1;
-
-	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
-		pfn_mkclean_range(pfn, npfn, start, vma);
-		cond_resched();
-	}
-	i_mmap_unlock_read(mapping);
-}
-
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		struct address_space *mapping, void *entry)
 {
-	unsigned long pfn, index, count;
+	unsigned long pfn, index, count, end;
 	long ret = 0;
+	struct vm_area_struct *vma;
 
 	/*
 	 * A page got tagged dirty in DAX mapping? Something is seriously
@@ -867,8 +853,16 @@ static int dax_writeback_one(struct xa_s
 	pfn = dax_to_pfn(entry);
 	count = 1UL << dax_entry_order(entry);
 	index = xas->xa_index & ~(count - 1);
+	end = index + count - 1;
+
+	/* Walk all mappings of a given index of a file and writeprotect them */
+	i_mmap_lock_read(mapping);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, end) {
+		pfn_mkclean_range(pfn, count, index, vma);
+		cond_resched();
+	}
+	i_mmap_unlock_read(mapping);
 
-	dax_entry_mkclean(mapping, pfn, count, index);
 	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), count * PAGE_SIZE);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kfence-fix-objcgs-vector-allocation.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
dax-fix-missing-writeprotect-the-pte-entry-v6.patch
mm-simplify-follow_invalidate_pte.patch

