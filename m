Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0C5C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhL0AIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhL0AIe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32748C061401
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4C3360EFC
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC2BC36AE9;
        Mon, 27 Dec 2021 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563713;
        bh=WFPaJ6vxjFMT6RoEv/DTNXrOWm05ngxecnKVVR0irZI=;
        h=Date:From:To:Subject:From;
        b=TMZ+u3l7QDVML0ld/xKJR988o1VVkygd7nfMcPSUJu3nkCg3M1XBkqHKgvksjy6Cf
         8happN+Nj8BSO2o0XUO20VLuMAqNdpPmYySLQIP3rVD6yLjda6DnV8W1tv3LlfqDEQ
         io8bJfw/thnzRUpWzcilJKs5Qlk+LbbWmGQmFdPo=
Date:   Sun, 26 Dec 2021 16:08:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + frontswap-simplify-frontswap_register_ops.patch added to
 -mm tree
Message-ID: <20211227000832.A05Mc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: simplify frontswap_register_ops
has been added to the -mm tree.  Its filename is
     frontswap-simplify-frontswap_register_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/frontswap-simplify-frontswap_register_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/frontswap-simplify-frontswap_register_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-remove-cleancache.patch
frontswap-remove-frontswap_writethrough.patch
frontswap-remove-frontswap_tmem_exclusive_gets.patch
frontswap-remove-frontswap_shrink.patch
frontswap-remove-frontswap_curr_pages.patch
frontswap-simplify-frontswap_init.patch
frontswap-remove-the-frontswap-exports.patch
mm-simplify-try_to_unuse.patch
frontswap-remove-frontswap_test.patch
frontswap-simplify-frontswap_register_ops.patch
mm-mark-swap_lock-and-swap_active_head-static.patch
frontswap-remove-support-for-multiple-ops.patch
mm-hide-the-frontswap-kconfig-symbol.patch

