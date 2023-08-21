Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983B6EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjHUSdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjHUSdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E64308A2
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE90363BF5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40356C433C9;
        Mon, 21 Aug 2023 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692642790;
        bh=OrBAy7yHsUHF0vZsn3QFK9r8HR5P3XagspJwKwYev6Q=;
        h=Date:To:From:Subject:From;
        b=Xf63ZoHwMzVevXBth039xMlAd67o1mG96zgnd/jeqO71kfD6tPCtsaJ3feG/h+W/V
         iuZvD2mGdNOFKq282OkZqEzttoA3sygtdDWPdKUHOC7Krlo/8JP9kt2FvptUhHKMI9
         QxCrtvmT/s8z4Y093L4sj3bBLaLYd52Vd8p+WacY=
Date:   Mon, 21 Aug 2023 11:33:09 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-clean-up-mas_wr_append.patch added to mm-unstable branch
Message-Id: <20230821183310.40356C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: clean up mas_wr_append()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-clean-up-mas_wr_append.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-clean-up-mas_wr_append.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: clean up mas_wr_append()
Date: Fri, 18 Aug 2023 20:43:56 -0400

Avoid setting the variables until necessary, and actually use the
variables where applicable.  Introducing a variable for the slots array
avoids spanning multiple lines.

Add the missing argument to the documentation.

Use the node type when setting the metadata instead of blindly assuming
the type.

Finally, add a trace point to the function for successful store.

Link: https://lkml.kernel.org/r/20230819004356.1454718-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clean-up-mas_wr_append
+++ a/lib/maple_tree.c
@@ -4106,6 +4106,7 @@ static inline unsigned char mas_wr_new_e
 /*
  * mas_wr_append: Attempt to append
  * @wr_mas: the maple write state
+ * @new_end: The end of the node after the modification
  *
  * This is currently unsafe in rcu mode since the end of the node may be cached
  * by readers while the node contents may be updated which could result in
@@ -4114,42 +4115,46 @@ static inline unsigned char mas_wr_new_e
  * Return: True if appended, false otherwise
  */
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
-				 unsigned char new_end)
+		unsigned char new_end)
 {
-	unsigned char end = wr_mas->node_end;
-	struct ma_state *mas = wr_mas->mas;
-	unsigned char node_pivots = mt_pivots[wr_mas->type];
+	struct ma_state *mas;
+	void __rcu **slots;
+	unsigned char end;
 
+	mas = wr_mas->mas;
 	if (mt_in_rcu(mas->tree))
 		return false;
 
 	if (mas->offset != wr_mas->node_end)
 		return false;
 
-	if (new_end < node_pivots) {
+	end = wr_mas->node_end;
+	if (mas->offset != end)
+		return false;
+
+	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
-		ma_set_meta(wr_mas->node, maple_leaf_64, 0, new_end);
+		ma_set_meta(wr_mas->node, wr_mas->type, 0, new_end);
 	}
 
-	if (new_end == wr_mas->node_end + 1) {
+	slots = wr_mas->slots;
+	if (new_end == end + 1) {
 		if (mas->last == wr_mas->r_max) {
 			/* Append to end of range */
-			rcu_assign_pointer(wr_mas->slots[new_end],
-					   wr_mas->entry);
+			rcu_assign_pointer(slots[new_end], wr_mas->entry);
 			wr_mas->pivots[end] = mas->index - 1;
 			mas->offset = new_end;
 		} else {
 			/* Append to start of range */
-			rcu_assign_pointer(wr_mas->slots[new_end],
-					   wr_mas->content);
+			rcu_assign_pointer(slots[new_end], wr_mas->content);
 			wr_mas->pivots[end] = mas->last;
-			rcu_assign_pointer(wr_mas->slots[end], wr_mas->entry);
+			rcu_assign_pointer(slots[end], wr_mas->entry);
 		}
 	} else {
 		/* Append to the range without touching any boundaries. */
-		rcu_assign_pointer(wr_mas->slots[new_end], wr_mas->content);
+		rcu_assign_pointer(slots[new_end], wr_mas->content);
 		wr_mas->pivots[end + 1] = mas->last;
-		rcu_assign_pointer(wr_mas->slots[end + 1], wr_mas->entry);
+		rcu_assign_pointer(slots[end + 1], wr_mas->entry);
 		wr_mas->pivots[end] = mas->index - 1;
 		mas->offset = end + 1;
 	}
@@ -4157,6 +4162,7 @@ static inline bool mas_wr_append(struct
 	if (!wr_mas->content || !wr_mas->entry)
 		mas_update_gap(mas);
 
+	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
 	return  true;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-disable-mas_wr_append-when-other-readers-are-possible.patch
maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch
maple_tree-clean-up-mas_wr_append.patch

