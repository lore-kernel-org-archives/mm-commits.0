Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DA4C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiAWX64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiAWX6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AEBC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CF1FB80E44
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC62CC340E3;
        Sun, 23 Jan 2022 23:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982333;
        bh=zqsbCFx8sL4k9oAGaoofdKrdCpQWpPgrk2rXT55jw6Q=;
        h=Date:From:To:Subject:From;
        b=Cb0kpCDajuTxSkCKT39rYgD/h70UjpJ287bR57XTlJ7lBpox53COhXSgjpkU2Jni9
         5BQ9Cubx253vSff+bGoflSGvoOkCbWn0IoMmC0eIS3B8tYVhLFUG1qYZlFZcoqJDuB
         wi8qmp8VxKlkOsl/l0qwlcFN1uCL8C8t2k8u2Jl4=
Date:   Sun, 23 Jan 2022 15:58:52 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged] frontswap-simplify-frontswap_register_ops.patch
 removed from -mm tree
Message-ID: <20220123235852.2Q2O5fNp8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: simplify frontswap_register_ops
has been removed from the -mm tree.  Its filename was
     frontswap-simplify-frontswap_register_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


