Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B9DCCA48A
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiGYTTW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiGYTTV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B193D1FCD2
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 612E9B810E5
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022C1C341C6;
        Mon, 25 Jul 2022 19:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658776758;
        bh=HlxtS2DjNBnzPNyl6LM9TSBBfBOtsXCh/D+yd4q/Lbw=;
        h=Date:To:From:Subject:From;
        b=0OSHZLCZegIZHg8KGB+MwRZ2Y2cIgKxNzTAUJxpIcuAWyUqes+4FqJShjH8fcQOgT
         spT05BmzHJNIA3lkkIzJYnUTxNdwCisswXnjoQFjUZiCfaahqFQ8Trl65aY0KJD7t2
         1LDUQYYIIJvo/vKto0lnjo9/0H2h1x5pvxzcpuT4=
Date:   Mon, 25 Jul 2022 12:19:17 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to mm-unstable branch
Message-Id: <20220725191918.022C1C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_expected_entries() off by one
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_expected_entries() off by one
Date: Fri, 22 Jul 2022 16:06:03 +0000

When inserting nodes, a final call to split the nodes will require a new
parent.  Add this as the working area for mas_expected_entries().

Add a maple state flag which will WARN_ON() if there is insufficient
nodes allocated.

Export mas_is_err() to be used in checking mas_store() returns
externally.

Link: https://lkml.kernel.org/r/20220722160546.1478722-2-Liam.Howlett@oracle.com
Fixes: 06b152b7980a (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    1 +
 lib/maple_tree.c           |   26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix
+++ a/include/linux/maple_tree.h
@@ -457,6 +457,7 @@ void mas_store_prealloc(struct ma_state
 void *mas_find(struct ma_state *mas, unsigned long max);
 void *mas_find_rev(struct ma_state *mas, unsigned long min);
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp);
+bool mas_is_err(struct ma_state *mas);
 
 bool mas_nomem(struct ma_state *mas, gfp_t gfp);
 void mas_pause(struct ma_state *mas);
--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -64,9 +64,15 @@
 
 #define MA_ROOT_PARENT 1
 
-/* Maple state flags */
+/*
+ * Maple state flags
+ * * MA_STATE_BULK		- Bulk insert mode
+ * * MA_STATE_REBALANCE		- Indicate a rebalance during bulk insert
+ * * MA_STATE_PREALLOC		- Preallocated nodes, WARN_ON allocation
+ */
 #define MA_STATE_BULK		1
 #define MA_STATE_REBALANCE	2
+#define MA_STATE_PREALLOC	4
 
 #define ma_parent_ptr(x) ((struct maple_pnode *)(x))
 #define ma_mnode_ptr(x) ((struct maple_node *)(x))
@@ -243,7 +249,7 @@ static inline bool mas_is_start(struct m
 	return mas->node == MAS_START;
 }
 
-static inline bool mas_is_err(struct ma_state *mas)
+bool mas_is_err(struct ma_state *mas)
 {
 	return xa_is_err(mas->node);
 }
@@ -1215,6 +1221,12 @@ static inline void mas_alloc_nodes(struc
 		return;
 
 	mas_set_alloc_req(mas, 0);
+	if (mas->mas_flags & MA_STATE_PREALLOC) {
+		if (allocated)
+			return;
+		WARN_ON(!allocated);
+	}
+
 	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS - 1) {
 		node = (struct maple_alloc *)mt_alloc_one(gfp);
 		if (!node)
@@ -5694,6 +5706,7 @@ int mas_preallocate(struct ma_state *mas
 	int ret;
 
 	mas_node_count_gfp(mas, 1 + mas_mt_height(mas) * 3, gfp);
+	mas->mas_flags |= MA_STATE_PREALLOC;
 	if (likely(!mas_is_err(mas)))
 		return 0;
 
@@ -5743,7 +5756,6 @@ int mas_expected_entries(struct ma_state
 	 * insertion of entries.
 	 */
 	nr_nodes = max(nr_entries, nr_entries * 2 + 1);
-
 	if (!mt_is_alloc(mas->tree))
 		nonleaf_cap = MAPLE_RANGE64_SLOTS - 2;
 
@@ -5751,7 +5763,11 @@ int mas_expected_entries(struct ma_state
 	nr_nodes = DIV_ROUND_UP(nr_nodes, MAPLE_RANGE64_SLOTS - 1);
 	/* Internal nodes */
 	nr_nodes += DIV_ROUND_UP(nr_nodes, nonleaf_cap);
-	mas_node_count(mas, nr_nodes);
+	/* Add one for working room */
+	mas_node_count(mas, nr_nodes + 1);
+
+	/* Detect if allocations run out */
+	mas->mas_flags |= MA_STATE_PREALLOC;
 
 	if (!mas_is_err(mas))
 		return 0;
@@ -5793,7 +5809,7 @@ void mas_destroy(struct ma_state *mas)
 
 		mas->mas_flags &= ~MA_STATE_REBALANCE;
 	}
-	mas->mas_flags &= ~MA_STATE_BULK;
+	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
 
 	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
 		node = mas->alloc;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

