Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA403C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbjAKV0y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjAKV0c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:26:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6335E53
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:26:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A09361ED4
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 21:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7145FC433D2;
        Wed, 11 Jan 2023 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673472389;
        bh=GP0f1GSkBdqvd5tTd7ifyvmRWhpB75ORNCbE478NJj0=;
        h=Date:To:From:Subject:From;
        b=lJ+c3n9F6luiOIzXUFii1/HSsk4y+GacS4l86IcYvxsAeKcm6MSWn7A86ghUQN5lx
         w8fRuICktWdwkbFOpebq/ypuHXX5R8Od3vJOGYeZVRQ7vGhmxYuvDMBLszCfweax0H
         EQU2RLGKW6qzCnCmnRd+O5nk7RmtMg0bZEb1YVzU=
Date:   Wed, 11 Jan 2023 13:26:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, vernon2gm@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-of-mte_destroy_walk.patch added to mm-unstable branch
Message-Id: <20230111212629.7145FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix comment of mte_destroy_walk
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-of-mte_destroy_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-of-mte_destroy_walk.patch

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
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: fix comment of mte_destroy_walk
Date: Wed, 11 Jan 2023 21:53:48 +0800

The parameter name of maple tree is mt, make the comment be mt instead of
mn, and the separator between the parameter name and the description to be
: instead of -.

Link: https://lkml.kernel.org/r/20230111135348.803181-1-vernon2gm@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-of-mte_destroy_walk
+++ a/lib/maple_tree.c
@@ -5578,8 +5578,8 @@ free_leaf:
 
 /*
  * mte_destroy_walk() - Free a tree or sub-tree.
- * @enode - the encoded maple node (maple_enode) to start
- * @mn - the tree to free - needed for node types.
+ * @enode: the encoded maple node (maple_enode) to start
+ * @mt: the tree to free - needed for node types.
  *
  * Must hold the write lock.
  */
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch
maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch

