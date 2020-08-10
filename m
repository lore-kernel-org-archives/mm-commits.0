Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA979C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA11D206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027137;
	bh=gVdToaFxKfvlTMpDdHA0/ntlYmFxfxJUK9HDDjcinls=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zuZpx2TqyS+h20m8GW9hYeXf5UZ+S20+rdIeIywE+x+lzJVADy2BglZ00FokcpAiO
	 k2xqfIe7zbR0CPttmhyR+q6nn9vTlzMXKW0s/QbUZEb7Dr/3p7TceK3m5exS/xp+Ot
	 7+ojlQdKztxSVFKaD3BdwvxB94qObi5Y8Vrxkk48=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHJCi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgHJCi5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 739C42065D;
        Mon, 10 Aug 2020 02:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027135;
        bh=gVdToaFxKfvlTMpDdHA0/ntlYmFxfxJUK9HDDjcinls=;
        h=Date:From:To:Subject:From;
        b=yFapbvKMysz7EotmvmFh6LhSRFmy3gxWY2iQQkbXv+35nSNw11VBsI8Gii5v7035C
         9PSvZnabegiw3hvbKkjhPFJfIrPqyqrL8ZUY0sucoGVlzU+9Fefw+A39L/f0UtzezN
         5JF826yw7SmbpwXyiZzdmdRgh8+0FbG2tcbAmpQo=
Date:   Sun, 09 Aug 2020 19:38:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged] mm-vmalloc-switch-to-propagate-callback.patch
 removed from -mm tree
Message-ID: <20200810023855.N3mekevQJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: switch to "propagate()" callback
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-switch-to-propagate-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: switch to "propagate()" callback

An augment_tree_propagate_from() function uses its own implementation that
populates a tree from the specified node toward a root node.

On the other hand the RB_DECLARE_CALLBACKS_MAX macro provides the
"propagate()" callback that does exactly the same.  Having two similar
functions does not make sense and is redundant.

Reuse "built in" functionality to the macros.  So the code size gets
reduced.

Link: http://lkml.kernel.org/r/20200527205054.1696-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-switch-to-propagate-callback
+++ a/mm/vmalloc.c
@@ -677,25 +677,12 @@ augment_tree_propagate_check(void)
 static __always_inline void
 augment_tree_propagate_from(struct vmap_area *va)
 {
-	struct rb_node *node = &va->rb_node;
-	unsigned long new_va_sub_max_size;
-
-	while (node) {
-		va = rb_entry(node, struct vmap_area, rb_node);
-		new_va_sub_max_size = compute_subtree_max_size(va);
-
-		/*
-		 * If the newly calculated maximum available size of the
-		 * subtree is equal to the current one, then it means that
-		 * the tree is propagated correctly. So we have to stop at
-		 * this point to save cycles.
-		 */
-		if (va->subtree_max_size == new_va_sub_max_size)
-			break;
-
-		va->subtree_max_size = new_va_sub_max_size;
-		node = rb_parent(&va->rb_node);
-	}
+	/*
+	 * Populate the tree from bottom towards the root until
+	 * the calculated maximum available size of checked node
+	 * is equal to its current one.
+	 */
+	free_vmap_area_rb_augment_cb_propagate(&va->rb_node, NULL);
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
 	augment_tree_propagate_check();
_

Patches currently in -mm which might be from urezki@gmail.com are


