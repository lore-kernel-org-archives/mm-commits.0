Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2021C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiFZUSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZUS1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:18:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7322D259
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 093B8CE1006
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B089C34114;
        Sun, 26 Jun 2022 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656274701;
        bh=TANPpF6eCuK4kVgpucI4r7cS7u6laSgiY84QjWUStZQ=;
        h=Date:To:From:Subject:From;
        b=mwiHTVkkOGmTvGDwCkThYbMa5VrppDDDxB++y9FBBu6YNY5CcrEE5RuneA+npe/Wu
         48rSMKoyt2zELnVCtwB5h2CbvSJstvRPqTVQrFW81zhEFm9mhPOP+59Xst8ji9O3ix
         x6GTeHxtgfoZCgcBuKlcsYMgvAvkjz7o8dxCDE44=
Date:   Sun, 26 Jun 2022 13:18:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-radix-tree-remove-unused-argument-of-insert_entries.patch added to mm-nonmm-unstable branch
Message-Id: <20220626201821.3B089C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/radix-tree: remove unused argument of insert_entries
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-radix-tree-remove-unused-argument-of-insert_entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-radix-tree-remove-unused-argument-of-insert_entries.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
lib-lru_cache-fix-error-free-handing-in-lc_create.patch
net-lib-once-remove-net_get_random_once_wait-macro.patch
lib-error-inject-traverse-list-with-mutex.patch
lib-radix-tree-remove-unused-argument-of-insert_entries.patch

