Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84110C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjBCGhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjBCGgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A128CA8F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EF67B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E61C433D2;
        Fri,  3 Feb 2023 06:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406163;
        bh=1aMm+wEXm9kyhLCrrKYUaVgVuZEc6OCk0na0q424zZE=;
        h=Date:To:From:Subject:From;
        b=gwJKcey/9L0tkfDOXQ55LYOX8tZLnjdgQlyamFpCA+SIeesZzNQF4GSrontdR00st
         2GL+aaql+l7NL3iPq6MybYXJsSD3UhOz8mik+MzySnmQi7HHWeyXq7FonESUNqIlHz
         z/RKAUc8OPjxuCHwaYzoOWnYFo/mVc9isH3vanSk=
Date:   Thu, 02 Feb 2023 22:36:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, vernon2gm@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-of-mte_destroy_walk.patch removed from -mm tree
Message-Id: <20230203063603.43E61C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix comment of mte_destroy_walk
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-of-mte_destroy_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


--- a/lib/maple_tree.c~maple_tree-fix-comment-of-mte_destroy_walk
+++ a/lib/maple_tree.c
@@ -5579,8 +5579,8 @@ free_leaf:
 
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


