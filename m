Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A27CC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjHKXBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE203A91
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C997363246
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3044BC433C7;
        Fri, 11 Aug 2023 23:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794816;
        bh=CQlMvKZUiKPLpLqZENIBADQ97cJsivx9PtA2rxIYtV0=;
        h=Date:To:From:Subject:From;
        b=Z5vLs5RE69qTu4CGFZe7WfC1ohnJwB9IqHjPeOM3V/GXK/08Ew7cqgm1VjgIrVRK1
         V6yOiCzXcGiJ/1LAwxHQ9KyUQlmXKEOAAOpVceLaAq4+8vRsWQWnk5hFj2VZnqHHmF
         LH4RpVAG7kArg0bmd3zEMshTGAL8VxIdoOJaQV4Q=
Date:   Fri, 11 Aug 2023 16:00:15 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch removed from -mm tree
Message-Id: <20230811230016.3044BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: don't use MAPLE_ARANGE64_META_MAX to indicate no gap
has been removed from the -mm tree.  Its filename was
     maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: don't use MAPLE_ARANGE64_META_MAX to indicate no gap
Date: Tue, 11 Jul 2023 11:54:38 +0800

Patch series "Improve the validation for maple tree and some cleanup", v2.


This patch (of 7):

Do not use a special offset to indicate that there is no gap.  When there
is no gap, offset can point to any valid slots because its gap is 0.

Link: https://lkml.kernel.org/r/20230711035444.526-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230711035444.526-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 --
 lib/maple_tree.c           |   13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap
+++ a/include/linux/maple_tree.h
@@ -29,14 +29,12 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ARANGE64_META_MAX	15	/* Out of range for metadata */
 #define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ARANGE64_META_MAX	31	/* Out of range for metadata */
 #define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
--- a/lib/maple_tree.c~maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap
+++ a/lib/maple_tree.c
@@ -1610,8 +1610,6 @@ ma_max_gap(struct maple_node *node, unsi
  * mas_max_gap() - find the largest gap in a non-leaf node and set the slot.
  * @mas: The maple state.
  *
- * If the metadata gap is set to MAPLE_ARANGE64_META_MAX, there is no gap.
- *
  * Return: The gap value.
  */
 static inline unsigned long mas_max_gap(struct ma_state *mas)
@@ -1628,9 +1626,6 @@ static inline unsigned long mas_max_gap(
 	node = mas_mn(mas);
 	MAS_BUG_ON(mas, mt != maple_arange_64);
 	offset = ma_meta_gap(node, mt);
-	if (offset == MAPLE_ARANGE64_META_MAX)
-		return 0;
-
 	gaps = ma_gaps(node, mt);
 	return gaps[offset];
 }
@@ -1662,10 +1657,7 @@ static inline void mas_parent_gap(struct
 ascend:
 	MAS_BUG_ON(mas, pmt != maple_arange_64);
 	meta_offset = ma_meta_gap(pnode, pmt);
-	if (meta_offset == MAPLE_ARANGE64_META_MAX)
-		meta_gap = 0;
-	else
-		meta_gap = pgaps[meta_offset];
+	meta_gap = pgaps[meta_offset];
 
 	pgaps[offset] = new;
 
@@ -1678,7 +1670,6 @@ ascend:
 
 		ma_set_meta_gap(pnode, pmt, offset);
 	} else if (new < meta_gap) {
-		meta_offset = 15;
 		new = ma_max_gap(pnode, pgaps, pmt, &meta_offset);
 		ma_set_meta_gap(pnode, pmt, meta_offset);
 	}
@@ -2076,7 +2067,7 @@ static inline void mab_mas_cp(struct map
 	end = j - 1;
 	if (likely(!ma_is_leaf(mt) && mt_is_alloc(mas->tree))) {
 		unsigned long max_gap = 0;
-		unsigned char offset = 15;
+		unsigned char offset = 0;
 
 		gaps = ma_gaps(node, mt);
 		do {
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


