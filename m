Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016F4EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjGKTOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjGKTOT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6CBEA
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E93F7615CD
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BFDC433C8;
        Tue, 11 Jul 2023 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102857;
        bh=HhoGcIGn6iKpf5QRVG17k3wjorNTAFTQ52mwxyvkr/k=;
        h=Date:To:From:Subject:From;
        b=Xa6uZjcfkdebHZxTU/imWcR2lKA6CmKTa41n+do3xnFPCykbEaUTbvdpvEcCEjNRs
         6SELYTQBBRurq2L9K5H+15igsLFMGZ5MHqkYUjQJLNtitF9/ofh1uvHuQapWQbYIhx
         TW6bRhh9CNpaMyvT6RNkQv8o+z7dcyQoTlR8mGQc=
Date:   Tue, 11 Jul 2023 12:14:16 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch added to mm-unstable branch
Message-Id: <20230711191417.49BFDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: don't use MAPLE_ARANGE64_META_MAX to indicate no gap
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch

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

maple_tree-set-the-node-limit-when-creating-a-new-root-node.patch
maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch
maple_tree-dont-use-maple_arange64_meta_max-to-indicate-no-gap.patch
maple_tree-make-mas_validate_gaps-to-check-metadata.patch
maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch
maple_tree-make-mas_validate_limits-check-root-node-and-node-limit.patch
maple_tree-update-mt_validate.patch
maple_tree-replace-mas_logical_pivot-with-mas_safe_pivot.patch
maple_tree-drop-mas_first_entry.patch

