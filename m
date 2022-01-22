Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFE0C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiAVGPG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiAVGPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:15:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDD0C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B181361148
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6058C004E1;
        Sat, 22 Jan 2022 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832105;
        bh=CjdfayaxQpo4siA/aoCkWt4E8aKCKMd7twpl/LcaJh0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q+FM57iqcXQiBzXZfddSHdmxDY21KUaDzbY9pYpFgI0VQ6FmhOT47VQS1snl5ae0z
         JN0BKJpF1SmyU2zCZ4WY3hYDuBHTEhfXZB9b5PpyPYZLcqdTkS/PWAeWAjexf2ops8
         KGUEaBIUZjOi8cWPFjoPFNBUuePqaM8oCODZ804s=
Date:   Fri, 21 Jan 2022 22:15:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 66/69] frontswap: simplify frontswap_register_ops
Message-ID: <20220122061504.4JqqECbOV%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: simplify frontswap_register_ops

Given that frontswap_register_ops must be called from built-in code,
there is no need to handle the case of swapfiles coming online before
or during it, so delete the code that deals with that case.

Link: https://lkml.kernel.org/r/20211224062246.1258487-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |   41 -----------------------------------------
 1 file changed, 41 deletions(-)

--- a/mm/frontswap.c~frontswap-simplify-frontswap_register_ops
+++ a/mm/frontswap.c
@@ -99,25 +99,6 @@ static inline void inc_frontswap_invalid
  */
 void frontswap_register_ops(struct frontswap_ops *ops)
 {
-	DECLARE_BITMAP(a, MAX_SWAPFILES);
-	DECLARE_BITMAP(b, MAX_SWAPFILES);
-	struct swap_info_struct *si;
-	unsigned int i;
-
-	bitmap_zero(a, MAX_SWAPFILES);
-	bitmap_zero(b, MAX_SWAPFILES);
-
-	spin_lock(&swap_lock);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if (!WARN_ON(!si->frontswap_map))
-			__set_bit(si->type, a);
-	}
-	spin_unlock(&swap_lock);
-
-	/* the new ops needs to know the currently active swap devices */
-	for_each_set_bit(i, a, MAX_SWAPFILES)
-		ops->init(i);
-
 	/*
 	 * Setting frontswap_ops must happen after the ops->init() calls
 	 * above; cmpxchg implies smp_mb() which will ensure the init is
@@ -128,28 +109,6 @@ void frontswap_register_ops(struct front
 	} while (cmpxchg(&frontswap_ops, ops->next, ops) != ops->next);
 
 	static_branch_inc(&frontswap_enabled_key);
-
-	spin_lock(&swap_lock);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if (si->frontswap_map)
-			__set_bit(si->type, b);
-	}
-	spin_unlock(&swap_lock);
-
-	/*
-	 * On the very unlikely chance that a swap device was added or
-	 * removed between setting the "a" list bits and the ops init
-	 * calls, we re-check and do init or invalidate for any changed
-	 * bits.
-	 */
-	if (unlikely(!bitmap_equal(a, b, MAX_SWAPFILES))) {
-		for (i = 0; i < MAX_SWAPFILES; i++) {
-			if (!test_bit(i, a) && test_bit(i, b))
-				ops->init(i);
-			else if (test_bit(i, a) && !test_bit(i, b))
-				ops->invalidate_area(i);
-		}
-	}
 }
 
 /*
_
