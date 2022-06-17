Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41F5C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379803AbiFQCtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379805AbiFQCt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE6264D3D
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B835B825FA
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B397C3411A;
        Fri, 17 Jun 2022 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434165;
        bh=ETkvyHqFVmuua5EEDZrocw+1t2N4oD8/lcgMwn4bjkw=;
        h=Date:To:From:Subject:From;
        b=fAb0Q6iYYHFlt/BqCnROXIRBhxTpp1iqSwdahoUDiK24UWKRicaOsvQ9Aj7SpuZ97
         dP3xAasFVOn1xdRMaJWd7LIbD1Sj/7JSnOayJ3qVb82Lu2CkgbSPxyY7jFDmkz3LCx
         EoL53rXeBOeT6KLxQRUPTbLPVlB5JBk6F7XzqT/8=
Date:   Thu, 16 Jun 2022 19:49:24 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch removed from -mm tree
Message-Id: <20220617024925.3B397C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: add code comment for find_vmap_area_exceed_addr()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: add code comment for find_vmap_area_exceed_addr()
Date: Tue, 7 Jun 2022 18:59:58 +0800

Its behaviour is like find_vma() which finds an area above the specified
address, add comment to make it easier to understand.

And also fix two places of grammer mistake/typo.

Link: https://lkml.kernel.org/r/20220607105958.382076-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr
+++ a/mm/vmalloc.c
@@ -790,6 +790,7 @@ unsigned long vmalloc_nr_pages(void)
 	return atomic_long_read(&nr_vmalloc_pages);
 }
 
+/* Look up the first VA which satisfies addr < va_end, NULL if none. */
 static struct vmap_area *find_vmap_area_exceed_addr(unsigned long addr)
 {
 	struct vmap_area *va = NULL;
@@ -929,7 +930,7 @@ link_va(struct vmap_area *va, struct rb_
 		 * Some explanation here. Just perform simple insertion
 		 * to the tree. We do not set va->subtree_max_size to
 		 * its current size before calling rb_insert_augmented().
-		 * It is because of we populate the tree from the bottom
+		 * It is because we populate the tree from the bottom
 		 * to parent levels when the node _is_ in the tree.
 		 *
 		 * Therefore we set subtree_max_size to zero after insertion,
@@ -1655,7 +1656,7 @@ static atomic_long_t vmap_lazy_nr = ATOM
 
 /*
  * Serialize vmap purging.  There is no actual critical section protected
- * by this look, but we want to avoid concurrent calls for performance
+ * by this lock, but we want to avoid concurrent calls for performance
  * reasons and to make the pcpu_get_vm_areas more deterministic.
  */
 static DEFINE_MUTEX(vmap_purge_lock);
_

Patches currently in -mm which might be from bhe@redhat.com are


