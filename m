Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87322C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjASBRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjASBPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C616B985
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A6C0B81D77
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29889C433EF;
        Thu, 19 Jan 2023 01:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090901;
        bh=7ttprvTbb68UgTqq4+Ut8ktxv63XOqpUxtckNr2xOsU=;
        h=Date:To:From:Subject:From;
        b=bu58Xox9rqFoTMxPnnJ9d9iCG/+tRhrlRrw2Mdm+OQAlZ9zYRIoN/CCJn5FHSbGtM
         uu5W/lFZKOgURynLMXTzLSuB7BaKPX+ux2mPnH7TzMg3yT29UEO0yHfCcyrH9RMLPM
         EQXxwUCfyKZQcFAhPmUTHAxpatUGFhgWu2eBIfm0=
Date:   Wed, 18 Jan 2023 17:15:00 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-the-redundant-code.patch removed from -mm tree
Message-Id: <20230119011501.29889C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove the redundant code
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-the-redundant-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: remove the redundant code
Date: Wed, 21 Dec 2022 14:00:56 +0800

The macros CONFIG_DEBUG_MAPLE_TREE_VERBOSE no one uses, functions
mas_dup_tree() and mas_dup_store() are not implemented, just function
declaration, so drop it.

Link: https://lkml.kernel.org/r/20221221060058.609003-6-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-the-redundant-code
+++ a/include/linux/maple_tree.h
@@ -12,7 +12,6 @@
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 /* #define CONFIG_MAPLE_RCU_DISABLED */
-/* #define CONFIG_DEBUG_MAPLE_TREE_VERBOSE */
 
 /*
  * Allocated nodes are mutable until they have been inserted into the tree,
@@ -483,9 +482,6 @@ static inline bool mas_is_paused(struct
 	return mas->node == MAS_PAUSE;
 }
 
-void mas_dup_tree(struct ma_state *oldmas, struct ma_state *mas);
-void mas_dup_store(struct ma_state *mas, void *entry);
-
 /*
  * This finds an empty area from the highest address to the lowest.
  * AKA "Topdown" version,
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

