Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF090C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 19:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjAPT7s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 14:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjAPT7s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 14:59:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B6B24121
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 11:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA6661018
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 19:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A38C433EF;
        Mon, 16 Jan 2023 19:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899186;
        bh=R+unTX9O+9AzBRWkt0mcabomJY53ir5NdTi3UsNCYWo=;
        h=Date:To:From:Subject:From;
        b=ESzpyc02Opy/bmNSMIF2aZSeu9IRFYRuF4iqWtQxNV3lAsczvnG8auAzt222yvZ3C
         RCLypnCWJncPvQGC2LCbE9ib4aeAJD/7FzfAD3+uq54noTeUz1KzslJvNN70oJDAbe
         ugkw5vsdCNNeMQgxPvshaDfSyObs5wK53wjqX61Q=
Date:   Mon, 16 Jan 2023 11:59:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        bagasdotme@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] swap_state-update-shadow_nodes-for-anonymous-page.patch removed from -mm tree
Message-Id: <20230116195945.F1A38C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap_state: update shadow_nodes for anonymous page
has been removed from the -mm tree.  Its filename was
     swap_state-update-shadow_nodes-for-anonymous-page.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: swap_state: update shadow_nodes for anonymous page
Date: Fri, 13 Jan 2023 17:36:45 +0800 (CST)

Shadow_nodes is for handling reclaiming of shadow nodes working set.  It
is updated during page cache addition and or deletion.  For a long time
workingset only supported page cache.  But when workingset was changed to
support anonymous page detection, we failed to update shadow nodes for it.
This meant that shadow nodes holding anonymous page will never be
reclaimd by scan_shadow_nodes() even they use much memory and system
memory is tense.

So update shadow_nodes of anonymous page when swap cache is added or
deleted by calling xas_set_update(..workingset_update_node).

Link: https://lkml.kernel.org/r/202301131736452546903@zte.com.cn
Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/xarray.h~swap_state-update-shadow_nodes-for-anonymous-page
+++ a/include/linux/xarray.h
@@ -1643,7 +1643,8 @@ static inline void xas_set_order(struct
  * @update: Function to call when updating a node.
  *
  * The XArray can notify a caller after it has updated an xa_node.
- * This is advanced functionality and is only needed by the page cache.
+ * This is advanced functionality and is only needed by the page cache
+ * and swap cache.
  */
 static inline void xas_set_update(struct xa_state *xas, xa_update_node_t update)
 {
--- a/mm/swap_state.c~swap_state-update-shadow_nodes-for-anonymous-page
+++ a/mm/swap_state.c
@@ -94,6 +94,8 @@ int add_to_swap_cache(struct folio *foli
 	unsigned long i, nr = folio_nr_pages(folio);
 	void *old;
 
+	xas_set_update(&xas, workingset_update_node);
+
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
@@ -145,6 +147,8 @@ void __delete_from_swap_cache(struct fol
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE(xas, &address_space->i_pages, idx);
 
+	xas_set_update(&xas, workingset_update_node);
+
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
@@ -252,6 +256,8 @@ void clear_shadow_from_swap_cache(int ty
 		struct address_space *address_space = swap_address_space(entry);
 		XA_STATE(xas, &address_space->i_pages, curr);
 
+		xas_set_update(&xas, workingset_update_node);
+
 		xa_lock_irq(&address_space->i_pages);
 		xas_for_each(&xas, old, end) {
 			if (!xa_is_value(old))
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


