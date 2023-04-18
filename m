Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6CDC7EE20
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 21:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjDRVXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 17:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjDRVXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 17:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453AC9ECC;
        Tue, 18 Apr 2023 14:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B131063935;
        Tue, 18 Apr 2023 21:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DF5C433EF;
        Tue, 18 Apr 2023 21:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852966;
        bh=s91Lj8Lqc1ToBfUj5LAdZb13qgRKhlsJcJJ05hUHGDo=;
        h=Date:To:From:Subject:From;
        b=ajs9HnZt/ns+H9xAf19UWpu6s7ECySsfOoey+sKmcB+y/GL9ZPQ+wBZl56fXTqz2P
         GVOI5MO5jMay4EyatA2w9R5u3vbtZdd5ATK1HOeHVYm8sjA2WMBZSTvbLAQ4r7DE2+
         TAm2+eVtHVPX1COwl/YJFHrt5IJdgNK/e50+avqA=
Date:   Tue, 18 Apr 2023 14:22:45 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rick.p.edgecombe@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-mas_empty_area-search.patch removed from -mm tree
Message-Id: <20230418212246.15DF5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_empty_area() search
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_empty_area-search.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_empty_area() search
Date: Fri, 14 Apr 2023 10:57:27 -0400

The internal function of mas_awalk() was incorrectly skipping the last
entry in a node, which could potentially be NULL.  This is only a problem
for the left-most node in the tree - otherwise that NULL would not exist.

Fix mas_awalk() by using the metadata to obtain the end of the node for
the loop and the logical pivot as apposed to the raw pivot value.

Link: https://lkml.kernel.org/r/20230414145728.4067069-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_empty_area-search
+++ a/lib/maple_tree.c
@@ -5056,10 +5056,10 @@ static inline bool mas_anode_descend(str
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char offset;
-	unsigned long *gaps;
-	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
-	void __rcu **slots = ma_slots(mas_mn(mas), type);
+	unsigned char offset, data_end;
+	unsigned long *gaps, *pivots;
+	void __rcu **slots;
+	struct maple_node *node;
 	bool found = false;
 
 	if (ma_is_dense(type)) {
@@ -5067,13 +5067,15 @@ static inline bool mas_anode_descend(str
 		return true;
 	}
 
-	gaps = ma_gaps(mte_to_node(mas->node), type);
+	node = mas_mn(mas);
+	pivots = ma_pivots(node, type);
+	slots = ma_slots(node, type);
+	gaps = ma_gaps(node, type);
 	offset = mas->offset;
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < mt_slots[type]; offset++) {
-		pivot = mas_safe_pivot(mas, pivots, offset, type);
-		if (offset && !pivot)
-			break;
+	data_end = ma_data_end(node, type, pivots, mas->max);
+	for (; offset <= data_end; offset++) {
+		pivot = mas_logical_pivot(mas, pivots, offset, type);
 
 		/* Not within lower bounds */
 		if (mas->index > pivot)
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


