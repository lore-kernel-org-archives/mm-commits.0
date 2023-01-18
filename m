Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58535C38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjARV0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjARV0N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:26:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B203A64D9A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:25:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EE861A39
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59530C433EF;
        Wed, 18 Jan 2023 21:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674077155;
        bh=BBRQnULbHAKdUk4zD01ZZ3brw6qVNfxc7dWk+FDzNTE=;
        h=Date:To:From:Subject:From;
        b=CYVYLpyCGCvk7Hg4XDa85ZpHGM7tLq5SwwT9wCknJnxVRK1WcKX7IspYrANTCpULv
         q2sYCmgBKPXEOsCQplxaFg296l4W1c9o5xqhWR0AimTgF0xWGvQyMIZwsPD6HKxm1a
         O/89nZsPJpB0K0O+LXgeWsfISTTTfcBCbAm0aWXI=
Date:   Wed, 18 Jan 2023 13:25:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ran.xiaokai@zte.com.cn, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        bagasdotme@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap_state-update-shadow_nodes-for-anonymous-page.patch added to mm-unstable branch
Message-Id: <20230118212555.59530C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap_state: update shadow_nodes for anonymous page
has been added to the -mm mm-unstable branch.  Its filename is
     swap_state-update-shadow_nodes-for-anonymous-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap_state-update-shadow_nodes-for-anonymous-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 include/linux/xarray.h |    3 ++-
 mm/swap_state.c        |    6 ++++++
 mm/workingset.c        |   21 +++++++++++++--------
 3 files changed, 21 insertions(+), 9 deletions(-)

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

swap_state-update-shadow_nodes-for-anonymous-page.patch

