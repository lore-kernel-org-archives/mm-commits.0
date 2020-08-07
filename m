Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC834C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0D822C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781457;
	bh=TnZEBmMMQozOw1y8JpbhSIYj9kuEUbifl454Pt53as4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fo8L6+o6ws5+uCxhum5nGtkf56Ok3cP5V/Pe9le0XCJ/hWB1Doae5c51fjR+Acz5e
	 XtHJPplvcGBqNP2BAlPdmlV3H+SUO87GR2oyNFj8vyy52V6RriPnNDRaGdZRh0VgjI
	 7/Yx60HYlkNWWvP6Kmzzf+eFpPzALXEF+HX09jag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHGGYR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgHGGYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4736221E5;
        Fri,  7 Aug 2020 06:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781456;
        bh=TnZEBmMMQozOw1y8JpbhSIYj9kuEUbifl454Pt53as4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U/BYWzm3OZ2BI7WXkKuKUT6TNWxP9DeCEUk1H4QDuP9zqxklOa0uPpFk9glZveQip
         bLNyDcDMUF8X30ECFlHX8wpu6qpouJCDGXRtfsUAsWS+zN0SCPGxkKT6cjbBincPP9
         Fwk0DY7V3nnl8FxpbH60avQ2UchjHUFLmkyte6vE=
Date:   Thu, 06 Aug 2020 23:24:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 124/163] mm/vmalloc: switch to "propagate()"
 callback
Message-ID: <20200807062415._in0d-o2F%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
