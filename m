Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3718ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJ1VaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJ1VaQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75031719B0
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5333B82BE2
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C87C433D6;
        Fri, 28 Oct 2022 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666992612;
        bh=5+0RGYu6Skn6C+KAZtCWgwVwA0/8t9AZ7QtW+sxBJvE=;
        h=Date:To:From:Subject:From;
        b=mcdAHi4CRCsXWUIgAsO3VEpXYHOkUG/3H6r3Oog7iWmBIToXF5u5KbXnFCRVYXhHy
         0hZ9rTwvtgfi3A/1yxKx3yiaNQQRYVpPhU4fWOy6tZIcKSI5G7lTzYRLVJYJZcx6Ma
         n0L8ZPKLjCs+wG/S7p6IMpYlMGLeP0x/Yyrk+GV8=
Date:   Fri, 28 Oct 2022 14:30:11 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch removed from -mm tree
Message-Id: <20221028213012.49C87C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempool: use kmalloc_size_roundup() to match ksize() usage
has been removed from the -mm tree.  Its filename was
     mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mempool: use kmalloc_size_roundup() to match ksize() usage
Date: Tue, 18 Oct 2022 02:03:29 -0700

Round up allocations with kmalloc_size_roundup() so that mempool's use of
ksize() is always accurate and no special handling of the memory is needed
by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Link: https://lkml.kernel.org/r/20221018090323.never.897-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mempool-use-kmalloc_size_roundup-to-match-ksize-usage
+++ a/mm/mempool.c
@@ -526,7 +526,7 @@ EXPORT_SYMBOL(mempool_free_slab);
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t)pool_data;
+	size_t size = kmalloc_size_roundup((size_t)pool_data);
 	return kmalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kmalloc);
_

Patches currently in -mm which might be from keescook@chromium.org are

mempool-do-not-use-ksize-for-poisoning.patch

