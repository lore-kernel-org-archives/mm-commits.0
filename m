Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF30AC10F1B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiLUVOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbiLUVOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:14:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74F5F14
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63EB6B81C58
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA0FC433EF;
        Wed, 21 Dec 2022 21:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657250;
        bh=PWJ0709dz+9vXNmjYNAP3y1RpWLbP6XDrDAaHmwSkuo=;
        h=Date:To:From:Subject:From;
        b=A0GWAlGT6jWNPK9yWbgAUt8xoZJJgzzCx7uQRKPx2+Op9xdNRieJG/1iXCtVTp9w6
         GHL5V8j7USDP7DMS/uwzgckJ7eeMeAB3XpRiUnskbj4rppF5GwwHra6TbL4yow9yge
         MBXXU/KeuGrLiFc9ET8ZhHd3S4Nspe3UHrWYLL8w=
Date:   Wed, 21 Dec 2022 13:14:09 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-the-redundant-code.patch added to mm-unstable branch
Message-Id: <20221221211410.1EA0FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove the redundant code
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-the-redundant-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-the-redundant-code.patch

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

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch

