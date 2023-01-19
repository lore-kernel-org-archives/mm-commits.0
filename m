Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59889C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjASBRu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjASBPp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C74E69B2E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF0C9B81D77
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A4DC433EF;
        Thu, 19 Jan 2023 01:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090898;
        bh=NZfBZVndY1DHoiXi8gP3E1L/YeUEN+0annlLWZNkFxM=;
        h=Date:To:From:Subject:From;
        b=Nkp0F0pzhgqXItMhGFU3Jr56EVvT+I4STZBkdrbG92U5qDpfAe62zgGduMghG+kLq
         1ZCG921zC/bvdBjJh4vq5Q2H3ZDclJneg3RAMWiT2h8Na93SuIEMoQTkdc5Ua/V/3x
         d3T3FTIgr8bu//x/RqAaLcUKC/hgT+Kw7bOfEQK4=
Date:   Wed, 18 Jan 2023 17:14:57 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch removed from -mm tree
Message-Id: <20230119011458.61A4DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use mt_node_max() instead of direct operations mt_max[]
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: use mt_node_max() instead of direct operations mt_max[]
Date: Wed, 21 Dec 2022 14:00:54 +0800

Use mt_node_max() to get the maximum number of slots for a node,
rather than direct operations mt_max[], makes it better portability.

Link: https://lkml.kernel.org/r/20221221060058.609003-4-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max
+++ a/lib/maple_tree.c
@@ -6725,7 +6725,7 @@ static void mt_dump_range64(const struct
 
 		if (i < (MAPLE_RANGE64_SLOTS - 1))
 			last = node->pivot[i];
-		else if (!node->slot[i] && max != mt_max[mte_node_type(entry)])
+		else if (!node->slot[i] && max != mt_node_max(entry))
 			break;
 		if (last == 0 && i > 0)
 			break;
@@ -6832,7 +6832,7 @@ void mt_dump(const struct maple_tree *mt
 	if (!xa_is_node(entry))
 		mt_dump_entry(entry, 0, 0, 0);
 	else if (entry)
-		mt_dump_node(mt, entry, 0, mt_max[mte_node_type(entry)], 0);
+		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0);
 }
 EXPORT_SYMBOL_GPL(mt_dump);
 
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

