Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE339C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92FF9206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027135;
	bh=fU0BMahTbl1U9MpWQ6WzWxG7BXyZfOL+Q4sXc0oBjIA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yR1GRZCnDLaT2ltTckB+TH2rLDkF/m3XSqKSNNZ51VoZshXVW1O3WSHyWQezoqMbe
	 C9FD8ckcfp3a9timHSm899COpNhMlBsGOveaZq/qd9N99Gh6gnQrIRjlvXMKnPEW7y
	 XaCge+AtXgQk930paJmJ1v3JaQ6ak2rA7+8Lm8+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgHJCiz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F1D2065D;
        Mon, 10 Aug 2020 02:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027133;
        bh=fU0BMahTbl1U9MpWQ6WzWxG7BXyZfOL+Q4sXc0oBjIA=;
        h=Date:From:To:Subject:From;
        b=MztwhHS2ykk4Vu3pyc8m6d1lam67l/U1+eFQ/W/ZNrusHHP8qIU788q8JmgcHyoWj
         hDLUR68B3603sHqgUDr991ZevCwMHctrjzq/6WBHVBt2dEKq86R7W2jy7FVQpUR+5B
         E4xLQTCoXZrtUB6u9bOWuP3IfiOmIp094PCG6Rfk=
Date:   Sun, 09 Aug 2020 19:38:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-simplify-augment_tree_propagate_check-func.patch removed from
 -mm tree
Message-ID: <20200810023853.kQ3rjQ25k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: simplify augment_tree_propagate_check()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-simplify-augment_tree_propagate_check-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: simplify augment_tree_propagate_check()

This function is for debug purpose only.  Currently it uses recursion for
tree traversal, checking an augmented value of each node to find out if it
is valid or not.

The recursion can corrupt the stack because the tree can be huge if
synthetic tests are applied.  To prevent it, navigate the tree from bottom
to upper levels using a regular list instead, because nodes are linked
among each other also.  It is faster and without recursion.

Link: http://lkml.kernel.org/r/20200527205054.1696-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   42 ++++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-simplify-augment_tree_propagate_check-func
+++ a/mm/vmalloc.c
@@ -633,43 +633,17 @@ unlink_va(struct vmap_area *va, struct r
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
 static void
-augment_tree_propagate_check(struct rb_node *n)
+augment_tree_propagate_check(void)
 {
 	struct vmap_area *va;
-	struct rb_node *node;
-	unsigned long size;
-	bool found = false;
-
-	if (n == NULL)
-		return;
-
-	va = rb_entry(n, struct vmap_area, rb_node);
-	size = va->subtree_max_size;
-	node = n;
+	unsigned long computed_size;
 
-	while (node) {
-		va = rb_entry(node, struct vmap_area, rb_node);
-
-		if (get_subtree_max_size(node->rb_left) == size) {
-			node = node->rb_left;
-		} else {
-			if (va_size(va) == size) {
-				found = true;
-				break;
-			}
-
-			node = node->rb_right;
-		}
+	list_for_each_entry(va, &free_vmap_area_list, list) {
+		computed_size = compute_subtree_max_size(va);
+		if (computed_size != va->subtree_max_size)
+			pr_emerg("tree is corrupted: %lu, %lu\n",
+				va_size(va), va->subtree_max_size);
 	}
-
-	if (!found) {
-		va = rb_entry(n, struct vmap_area, rb_node);
-		pr_emerg("tree is corrupted: %lu, %lu\n",
-			va_size(va), va->subtree_max_size);
-	}
-
-	augment_tree_propagate_check(n->rb_left);
-	augment_tree_propagate_check(n->rb_right);
 }
 #endif
 
@@ -724,7 +698,7 @@ augment_tree_propagate_from(struct vmap_
 	}
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
-	augment_tree_propagate_check(free_vmap_area_root.rb_node);
+	augment_tree_propagate_check();
 #endif
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are


