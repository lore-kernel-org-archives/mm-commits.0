Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9791C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352429AbiCYBdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357452AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF19BF509
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0606FB82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CAC340ED;
        Fri, 25 Mar 2022 01:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171873;
        bh=luMo5kVVl07j0sFv8Yi97IQQZsf949tTqyVF3vliGXU=;
        h=Date:To:From:Subject:From;
        b=vuCjb7435wfnJmJSvrKjdqGVwqJnRI4Q+a6ekrg0TQtUYvG/isuOfJkDoGka5cFLi
         UNZhn2elFEZXt3QGyh0r6VkHtJvw/iwRB0E2O84X7eWnGAmnrHB5tlvnlVcxV58VyB
         bi/77XRMwAWWY5Q7lHrxftsfMPc0IsWpjFx1DQos=
Date:   Thu, 24 Mar 2022 18:31:13 -0700
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmallocc-fix-unused-function-warning.patch removed from -mm tree
Message-Id: <20220325013113.B20CAC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix "unused function" warning
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-fix-unused-function-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/vmalloc.c: fix "unused function" warning

compute_subtree_max_size() is unused, when building with
DEBUG_AUGMENT_PROPAGATE_CHECK=y.

mm/vmalloc.c:785:1: warning: unused function 'compute_subtree_max_size'
[-Wunused-function].

Link: https://lkml.kernel.org/r/20220129034652.75359-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-unused-function-warning
+++ a/mm/vmalloc.c
@@ -775,17 +775,6 @@ get_subtree_max_size(struct rb_node *nod
 	return va ? va->subtree_max_size : 0;
 }
 
-/*
- * Gets called when remove the node and rotate.
- */
-static __always_inline unsigned long
-compute_subtree_max_size(struct vmap_area *va)
-{
-	return max3(va_size(va),
-		get_subtree_max_size(va->rb_node.rb_left),
-		get_subtree_max_size(va->rb_node.rb_right));
-}
-
 RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
 	struct vmap_area, rb_node, unsigned long, subtree_max_size, va_size)
 
@@ -973,6 +962,17 @@ unlink_va(struct vmap_area *va, struct r
 }
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
+/*
+ * Gets called when remove the node and rotate.
+ */
+static __always_inline unsigned long
+compute_subtree_max_size(struct vmap_area *va)
+{
+	return max3(va_size(va),
+		get_subtree_max_size(va->rb_node.rb_left),
+		get_subtree_max_size(va->rb_node.rb_right));
+}
+
 static void
 augment_tree_propagate_check(void)
 {
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are


