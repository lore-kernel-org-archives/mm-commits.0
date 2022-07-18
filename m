Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9937CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGRAcc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiGRAc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5244C13CFC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB7760FA8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D6FC3411E;
        Mon, 18 Jul 2022 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104347;
        bh=Wgp5M/mOihXHhC9Ko44QriTHotHz3ThO6r54VoD+RKQ=;
        h=Date:To:From:Subject:From;
        b=IKW56XbXlbYJsgKhPO6TshULXV+kg+l+xkiFafpsQYX48Mz5w97iNEHg9xvvDxG+k
         Abe1wkduxZQVJefxcQeT9ghUCODSMnQ+CnQ+aijxQRPiyfpDxcdPA438XYFgbsK+N5
         fQQQ5vC4ueYdeqAPbyFWxyXm2L/mXF+m0n6KsQjE=
Date:   Sun, 17 Jul 2022 17:32:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-radix-tree-remove-unused-argument-of-insert_entries.patch removed from -mm tree
Message-Id: <20220718003227.40D6FC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/radix-tree: remove unused argument of insert_entries
has been removed from the -mm tree.  Its filename was
     lib-radix-tree-remove-unused-argument-of-insert_entries.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/radix-tree: remove unused argument of insert_entries
Date: Sat, 25 Jun 2022 21:53:24 +0800

insert_entries() doesn't use the 'bool replace' argument, and the function
is only used locally, remove the argument.

The historical context of the unused argument is as follow:

2: commit <3a08cd52c37c79> (radix tree: Remove multiorder support)
  Remove the code related to macro CONFIG_RADIX_TREE_MULTIORDER
to convert to the xArray.
  Without the macro, there is no need to retain the argument.

1: commit <175542f575723e> (radix-tree: add radix_tree_join)
  Add insert_entries(..., bool replace) function, depending on the
macro CONFIG_RADIX_TREE_MULTIORDER definition, the implementation
is different. Notice that the implementation without the macro doesn't
use the argument.

[Matthew Wilcox: add historical context for argument]

Link: https://lkml.kernel.org/r/20220625135324.72574-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/radix-tree.c~lib-radix-tree-remove-unused-argument-of-insert_entries
+++ a/lib/radix-tree.c
@@ -677,7 +677,7 @@ static void radix_tree_free_nodes(struct
 }
 
 static inline int insert_entries(struct radix_tree_node *node,
-		void __rcu **slot, void *item, bool replace)
+		void __rcu **slot, void *item)
 {
 	if (*slot)
 		return -EEXIST;
@@ -711,7 +711,7 @@ int radix_tree_insert(struct radix_tree_
 	if (error)
 		return error;
 
-	error = insert_entries(node, slot, item, false);
+	error = insert_entries(node, slot, item);
 	if (error < 0)
 		return error;
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

