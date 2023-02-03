Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EAAC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjBCGmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBCGlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E08B326
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7573A61DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAE8C4339B;
        Fri,  3 Feb 2023 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406276;
        bh=K2RfGcwW0//2+SylnxYnRU0C99K0Xjetf20+MjmxTjQ=;
        h=Date:To:From:Subject:From;
        b=w6x8Ln8beJuTU+gyQgt9TRXT9/ClBaSvMkEV+T301rrdkgeQOZbclVjuZ6wim05Zt
         tBxlO4Xrj0XqwkXkQ3miFaYmpTr4MiHkcdAsZ3AN1OSQnDlqc8omKr/+Hd1CUfc/m0
         AshliFVqMcDdrV0rZjzSDSlH9f1mX0F0ZH/+BZn4=
Date:   Thu, 02 Feb 2023 22:37:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        bagasdotme@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap_state-update-shadow_nodes-for-anonymous-page.patch removed from -mm tree
Message-Id: <20230203063756.CDAE8C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap_state: update shadow_nodes for anonymous page
has been removed from the -mm tree.  Its filename was
     swap_state-update-shadow_nodes-for-anonymous-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: swap_state: update shadow_nodes for anonymous page
Date: Wed, 18 Jan 2023 20:13:03 +0800 (CST)

Shadow_nodes is for shadow nodes reclaiming of workingset handling, it is
updated when page cache add or delete since long time ago workingset only
supported page cache.  But when workingset supports anonymous page
detection, we missied updating shadow nodes for it.  This caused that
shadow nodes of anonymous page will never be reclaimd by
scan_shadow_nodes() even they use much memory and system memory is tense.

So update shadow_nodes of anonymous page when swap cache is add or delete
by calling xas_set_update(..workingset_update_node).

Link: https://lkml.kernel.org/r/202301182013032211005@zte.com.cn
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
+ * This is advanced functionality and is only needed by the page
+ * cache and swap cache.
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
--- a/mm/workingset.c~swap_state-update-shadow_nodes-for-anonymous-page
+++ a/mm/workingset.c
@@ -657,11 +657,14 @@ static enum lru_status shadow_lru_isolat
 		goto out;
 	}
 
-	if (!spin_trylock(&mapping->host->i_lock)) {
-		xa_unlock(&mapping->i_pages);
-		spin_unlock_irq(lru_lock);
-		ret = LRU_RETRY;
-		goto out;
+	/* For page cache we need to hold i_lock */
+	if (mapping->host != NULL) {
+		if (!spin_trylock(&mapping->host->i_lock)) {
+			xa_unlock(&mapping->i_pages);
+			spin_unlock_irq(lru_lock);
+			ret = LRU_RETRY;
+			goto out;
+		}
 	}
 
 	list_lru_isolate(lru, item);
@@ -683,9 +686,11 @@ static enum lru_status shadow_lru_isolat
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
-	if (mapping_shrinkable(mapping))
-		inode_add_lru(mapping->host);
-	spin_unlock(&mapping->host->i_lock);
+	if (mapping->host != NULL) {
+		if (mapping_shrinkable(mapping))
+			inode_add_lru(mapping->host);
+		spin_unlock(&mapping->host->i_lock);
+	}
 	ret = LRU_REMOVED_RETRY;
 out:
 	cond_resched();
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


