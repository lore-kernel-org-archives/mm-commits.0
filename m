Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCB7C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA2B221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781454;
	bh=j9rfOf1i9aY8clSti7KMu0L/ZNbCwlPflgWZOj9u9nE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AIzA0h9dHI9nxefwa+KR2FqYwcrwUTPt/eV9tsn28yzZWg4jZBaQg3nxMsZi8YBFM
	 zkr/Yl+tbYqKV4juRf75UZycmZCHOP6ORgsVhVxa/I4oi+dTJfXMqDkiXAogbCV2oK
	 PGARnoMBvJWptmd1VUAOM3JTHnvGcnSbseqiVIpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGGYN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgHGGYN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DD922CAF;
        Fri,  7 Aug 2020 06:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781453;
        bh=j9rfOf1i9aY8clSti7KMu0L/ZNbCwlPflgWZOj9u9nE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R8NOOWMm4UwEW+0CZ087l1MPSavvV1+0uKnPUm4l9PComutC0ZpauILMofULtDUfS
         ZDdsDRUR0wYw/8MDz6Pk8BCOdd6uMJi8xdg/W2e3kidrGMLVsvXuZMllnNR1+Jv3p3
         vZ2egg7RmGRGYyow74icaMf0JC7CeEYzq0UymZtw=
Date:   Thu, 06 Aug 2020 23:24:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 123/163] mm/vmalloc: simplify
 augment_tree_propagate_check()
Message-ID: <20200807062412.CRKz-JHFy%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
