Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091E3C04FE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjHKXNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbjHKXNB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A26A3AB0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A590067B04
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A86C433C7;
        Fri, 11 Aug 2023 23:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794974;
        bh=WHiniVT/3gy+84Iwz9vdsnB+RnHVs8uWzwrVIH9dZ/U=;
        h=Date:To:From:Subject:From;
        b=NsV8TrGI5BjVESKVGiMNm/AED1ZpBIW7tKGKsYqNL4RczPuQxrED+lpHtRSmOxLfn
         pZu2UakcC+Ybs/JcUJf7ROFDuP3fyzbdazIFZ6FHmMYOIhH9X15Ef/bsAi9FmQIJI+
         hybVk6YzI3TsjxCbw5chW/271/AuWW+u8WNyvYJE=
Date:   Fri, 11 Aug 2023 16:02:53 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-reduce-resets-during-store-setup.patch removed from -mm tree
Message-Id: <20230811230254.07A86C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: reduce resets during store setup
has been removed from the -mm tree.  Its filename was
     maple_tree-reduce-resets-during-store-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: reduce resets during store setup
Date: Mon, 24 Jul 2023 14:31:56 -0400

mas_prealloc() may walk partially down the tree before finding that a
split or spanning store is needed.  When the write occurs, relax the
logic on resetting the walk so that partial walks will not restart, but
walks that have gone too far (a store that affects beyond the current
node) should be restarted.

Link: https://lkml.kernel.org/r/20230724183157.3939892-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reduce-resets-during-store-setup
+++ a/lib/maple_tree.c
@@ -5424,19 +5424,34 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (mas_is_start(wr_mas->mas))
+		return;
+
 	if (unlikely(mas_is_paused(wr_mas->mas)))
-		mas_reset(wr_mas->mas);
+		goto reset;
+
+	if (unlikely(mas_is_none(wr_mas->mas)))
+		goto reset;
+
+	/*
+	 * A less strict version of mas_is_span_wr() where we allow spanning
+	 * writes within this node.  This is to stop partial walks in
+	 * mas_prealloc() from being reset.
+	 */
+	if (wr_mas->mas->last > wr_mas->mas->max)
+		goto reset;
+
+	if (wr_mas->entry)
+		return;
+
+	if (mte_is_leaf(wr_mas->mas->node) &&
+	    wr_mas->mas->last == wr_mas->mas->max)
+		goto reset;
+
+	return;
 
-	if (!mas_is_start(wr_mas->mas)) {
-		if (mas_is_none(wr_mas->mas)) {
-			mas_reset(wr_mas->mas);
-		} else {
-			wr_mas->r_max = wr_mas->mas->max;
-			wr_mas->type = mte_node_type(wr_mas->mas->node);
-			if (mas_is_span_wr(wr_mas))
-				mas_reset(wr_mas->mas);
-		}
-	}
+reset:
+	mas_reset(wr_mas->mas);
 }
 
 /* Interface */
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

