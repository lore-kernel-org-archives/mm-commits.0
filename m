Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515FCC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10C14221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781451;
	bh=bKRS2E2NSJm5l9hlRu7PtmqXf8IADNxbLGGc4LTR+OM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YwBYPF/9XzH1IR8EblHQlWxxyOWWfUveTPPJJaktwxvOqiJZgQYJOlygV+OvDfm4C
	 Yk4iE4PRcj5D7GxbJ+G7fGUqklyNsUDOvqBxKxcdSkcbK1BM6IqufuKmGuBi0xCarS
	 WyZ8GP6we9FN/7itsthjyUYFnAO3WrKldLeSex+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgHGGYK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE0F22C9F;
        Fri,  7 Aug 2020 06:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781449;
        bh=bKRS2E2NSJm5l9hlRu7PtmqXf8IADNxbLGGc4LTR+OM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QtHat6zkUiYVHiLelPEn94+T4a8fgas/JOXEHoHCU3Ta77D6t8UtYWAyu/w+GrleG
         hRV9PF9vVsMkz3MRmwn8vqMLB7rXH1EXj71/zGj4acygDHS/P+dkz9iCFmUFYESozm
         Z9jQNeQ5Fn0zx1STo+5CvEaKHt326jER6RF1wF7w=
Date:   Thu, 06 Aug 2020 23:24:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 122/163] mm/vmalloc: simplify
 merge_or_add_vmap_area()
Message-ID: <20200807062409.LB5mTxlwD%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: simplify merge_or_add_vmap_area()

Currently when a VA is deallocated and is about to be placed back to the
tree, it can be either: merged with next/prev neighbors or inserted if not
coalesced.

On those steps the tree can be populated several times.  For example when
both neighbors are merged.  It can be avoided and simplified in fact.

Therefore do it only once when VA points to final merged area, after all
manipulations: merging/removing/inserting.

Link: http://lkml.kernel.org/r/20200527205054.1696-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-simplify-merge_or_add_vmap_area-func
+++ a/mm/vmalloc.c
@@ -797,9 +797,6 @@ merge_or_add_vmap_area(struct vmap_area
 		if (sibling->va_start == va->va_end) {
 			sibling->va_start = va->va_start;
 
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -819,14 +816,18 @@ merge_or_add_vmap_area(struct vmap_area
 	if (next->prev != head) {
 		sibling = list_entry(next->prev, struct vmap_area, list);
 		if (sibling->va_end == va->va_start) {
-			sibling->va_end = va->va_end;
-
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
+			/*
+			 * If both neighbors are coalesced, it is important
+			 * to unlink the "next" node first, followed by merging
+			 * with "previous" one. Otherwise the tree might not be
+			 * fully populated if a sibling's augmented value is
+			 * "normalized" because of rotation operations.
+			 */
 			if (merged)
 				unlink_va(va, root);
 
+			sibling->va_end = va->va_end;
+
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -837,11 +838,13 @@ merge_or_add_vmap_area(struct vmap_area
 	}
 
 insert:
-	if (!merged) {
+	if (!merged)
 		link_va(va, root, parent, link, head);
-		augment_tree_propagate_from(va);
-	}
 
+	/*
+	 * Last step is to check and update the tree.
+	 */
+	augment_tree_propagate_from(va);
 	return va;
 }
 
_
