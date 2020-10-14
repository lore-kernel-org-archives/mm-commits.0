Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC14C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B603A214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709427;
	bh=eYVz9Vj7g4yxKt+Jy5yerf7R4XR45wrgOgy91ckX33M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=elOy0pZ4FopR33tUM2hJGoyQeXolzWCqrBa5VLCdPWqY5uyjGibc2IhtLI6a95fd8
	 rdxH961989tHZgMtQhr/GE51EBCef5XNcO/5yhRWBSlamB8BfnKkXzmzzOLr+4uGiy
	 vy9oV/wtnJzRyBymfa7heoOKz9v3UUdy57BXTY1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgJNVDr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97348206B2;
        Wed, 14 Oct 2020 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709426;
        bh=eYVz9Vj7g4yxKt+Jy5yerf7R4XR45wrgOgy91ckX33M=;
        h=Date:From:To:Subject:From;
        b=bBO/imHMOg74y1moPbcxFUwGWJckHPPV3jx6cNMjnDu53FljcG0rKr+Kb2Tvg4hJL
         sVnouMn4UoB3TtyfrMBtN7TftTcalqaAor3Yey6zycWALnNkkJ2oK1356tAp/jAMxC
         oY5jryQqVTlaw0GA/tynEa+noK8ldrrd9kSimbOA=
Date:   Wed, 14 Oct 2020 14:03:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  [merged]
 mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch removed from -mm
 tree
Message-ID: <20201014210346.rEwZUTPbq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: use xx_zalloc instead xx_alloc and memset
has been removed from the -mm tree.  Its filename was
     mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/z3fold.c: use xx_zalloc instead xx_alloc and memset

alloc_slots() allocates memory for slots using kmem_cache_alloc(), then
memsets it.  We can just use kmem_cache_zalloc().

Link: https://lkml.kernel.org/r/20200926100834.GA184671@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~mmz3fold-use-xx_zalloc-instead-xx_alloc-and-memset
+++ a/mm/z3fold.c
@@ -212,13 +212,12 @@ static inline struct z3fold_buddy_slots
 {
 	struct z3fold_buddy_slots *slots;
 
-	slots = kmem_cache_alloc(pool->c_handle,
+	slots = kmem_cache_zalloc(pool->c_handle,
 				 (gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE)));
 
 	if (slots) {
 		/* It will be freed separately in free_handle(). */
 		kmemleak_not_leak(slots);
-		memset(slots->slot, 0, sizeof(slots->slot));
 		slots->pool = (unsigned long)pool;
 		rwlock_init(&slots->lock);
 	}
_

Patches currently in -mm which might be from sh_def@163.com are


