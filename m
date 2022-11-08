Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76850C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiKHX6Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiKHX6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4367760E8C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01BDBB80C74
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C87EC433D6;
        Tue,  8 Nov 2022 23:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951884;
        bh=P2MVRZuffLYZLXOb+D+yVxVYjbimZjngAHMxzbYF7C8=;
        h=Date:To:From:Subject:From;
        b=UXpjM0IF0GuJkeo804SmF6FLCF7sAYADncxDQnge6NVotZhWuiVYBJBnI/7rrFqKq
         dmDHHZUyD9w6Q3SxH+ZMi2Iz61v7GNxHRubn9h6B65v2NyRQCNcETCSoWNc7S80+fa
         bUqcmyqj05NpTexsHSA9y7qntK5vMJti40Scu74E=
Date:   Tue, 08 Nov 2022 15:58:04 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch removed from -mm tree
Message-Id: <20221108235804.9C87EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove pointer to pointer use in mas_alloc_nodes()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: remove pointer to pointer use in mas_alloc_nodes()
Date: Wed, 26 Oct 2022 15:13:29 +0000

There is a more direct and cleaner way of implementing the same functional
code.  Remove the confusing and unnecessary use of pointers here.

Link: https://lkml.kernel.org/r/20221026151241.4031117-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes
+++ a/lib/maple_tree.c
@@ -1209,7 +1209,6 @@ done:
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
 	struct maple_alloc *node;
-	struct maple_alloc **nodep = &mas->alloc;
 	unsigned long allocated = mas_allocated(mas);
 	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
@@ -1263,8 +1262,7 @@ static inline void mas_alloc_nodes(struc
 			node->node_count--;
 
 		success += count;
-		nodep = &node->slot[0];
-		node = *nodep;
+		node = node->slot[0];
 		requested -= count;
 	}
 	mas->alloc->total = success;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

