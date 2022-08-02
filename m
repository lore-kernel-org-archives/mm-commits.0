Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35514C00140
	for <mm-commits@archiver.kernel.org>; Tue,  2 Aug 2022 23:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiHBX4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Aug 2022 19:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiHBXz4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2022 19:55:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C12101C
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 16:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CB5DB810B0
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 23:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B528AC433D6;
        Tue,  2 Aug 2022 23:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659484522;
        bh=FNviPwpEYbSIzH+ni/Kb7/dMKWF8X85A9tggT5mIiT4=;
        h=Date:To:From:Subject:From;
        b=EmZfU9gGBOn5aP0DIUkCwlxUtpAHcKCC2jFBO+sxSXOOEnv7VYO++u/Cfv3xQu9K/
         tAvbFHZVybga83xHe6e+cKz/lvqjJtciroBd0rWhAizjp1HKkzEdWEYHEln1koMX4M
         dNtozA+cYCpPTiKVNj9kX6iD5HOU4vN06qTFbIlY=
Date:   Tue, 02 Aug 2022 16:55:21 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-3.patch added to mm-unstable branch
Message-Id: <20220802235522.B528AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_alloc_nodes()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-3.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_alloc_nodes()
Date: Tue, 2 Aug 2022 19:36:24 +0000

Use MAPLE_ALLOC_SLOTS, which differs on 32bit.  This was causing an
out of bounds issue on 32bit bulk allocations

Link: https://lkml.kernel.org/r/20220802193612.2886170-1-Liam.Howlett@oracle.com
Fixes: 06b152b7980a (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
+++ a/lib/maple_tree.c
@@ -1242,7 +1242,7 @@ static inline void mas_alloc_nodes(struc
 
 	node = mas->alloc;
 	while (requested) {
-		max_req = MAPLE_NODE_SLOTS - 1;
+		max_req = MAPLE_ALLOC_SLOTS;
 		if (node->slot[0]) {
 			unsigned int offset = node->node_count + 1;
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-3.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch
maple_tree-do-not-inline-write-slow-path.patch

