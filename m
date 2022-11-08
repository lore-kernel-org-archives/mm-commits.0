Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89319C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKHX6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKHX6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD4A606A1
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4C3617E5
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD5C433C1;
        Tue,  8 Nov 2022 23:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951885;
        bh=9DG1ISnS30+Z2hJVEuupg4hbyuYuBUCUocHnUm7SV80=;
        h=Date:To:From:Subject:From;
        b=CfunESwVt6yvUXYn2owbTcj8PsC8A8fxkJQKhCQXH5Bls6dvFcKUoHGZPbkG+oT4h
         Z22VnAcxxspY/HLwbS/xfPv2kplvxJWOsjxgy1gtG/g19pvxSrMarmwB50tHktNKyP
         MUSF6qW+G96LzCFsFaJ3/WpKQ6b9DbeaqNOJd0sM=
Date:   Tue, 08 Nov 2022 15:58:05 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch removed from -mm tree
Message-Id: <20221108235805.9FDD5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: mas_anode_descend() clang-analyzer cleanup
has been removed from the -mm tree.  Its filename was
     maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: mas_anode_descend() clang-analyzer cleanup
Date: Wed, 26 Oct 2022 15:14:31 +0000

clang-analyzer reported some Dead Stores in mas_anode_descend().  Upon
inspection, there were a few clean ups that would make the code cleaner:

The count variable was set from the mt_slots array and then updated but
never used again.  Just use the array reference directly.

Also stop updating the type since it isn't used after the update.

Stop setting the gaps pointer to NULL at the start since it is always
set before the loop begins.

Link: https://lkml.kernel.org/r/20221026151413.4032730-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mas_anode_descend-clang-analyzer-clean-up
+++ a/lib/maple_tree.c
@@ -4968,8 +4968,9 @@ static inline bool mas_anode_descend(str
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char count, offset;
-	unsigned long *gaps = NULL, *pivots = ma_pivots(mas_mn(mas), type);
+	unsigned char offset;
+	unsigned long *gaps;
+	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
 	void __rcu **slots = ma_slots(mas_mn(mas), type);
 	bool found = false;
 
@@ -4980,9 +4981,8 @@ static inline bool mas_anode_descend(str
 
 	gaps = ma_gaps(mte_to_node(mas->node), type);
 	offset = mas->offset;
-	count = mt_slots[type];
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < count; offset++) {
+	for (; offset < mt_slots[type]; offset++) {
 		pivot = mas_safe_pivot(mas, pivots, offset, type);
 		if (offset && !pivot)
 			break;
@@ -5008,8 +5008,6 @@ static inline bool mas_anode_descend(str
 				mas->min = min;
 				mas->max = pivot;
 				offset = 0;
-				type = mte_node_type(mas->node);
-				count = mt_slots[type];
 				break;
 			}
 		}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

