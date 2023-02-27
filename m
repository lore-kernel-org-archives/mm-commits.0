Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BC7C64ED9
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjB0WGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjB0WGB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:06:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4667928879
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADCC1B80DBF
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541A7C433EF;
        Mon, 27 Feb 2023 22:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535557;
        bh=qPYfnmaz/SAlY3+8ZB1Pi5tRKGKWrbNBAHdHQzrYddU=;
        h=Date:To:From:Subject:From;
        b=KF0XXvlQrfxzX3dJS397F8ilbsepEF5uDiNVh3NVWz113801YdxQHhd2jOE3NAi9g
         5ZaMdCNTH4LMThdrFBKR6B+F4E+7xTCAa5milfpvdUpjkmGmCq4mhhvaX+5+ud4P/z
         8bIvj5ZzegL5SF02D+Gdd/IWNgD6fAWaJavHNBBI=
Date:   Mon, 27 Feb 2023 14:05:56 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-detect-dead-nodes-in-mas_start.patch added to mm-unstable branch
Message-Id: <20230227220557.541A7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: detect dead nodes in mas_start()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-detect-dead-nodes-in-mas_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-detect-dead-nodes-in-mas_start.patch

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
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: maple_tree: detect dead nodes in mas_start()
Date: Mon, 27 Feb 2023 09:36:01 -0800

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-detect-dead-nodes-in-mas_start
+++ a/lib/maple_tree.c
@@ -1360,12 +1360,16 @@ static inline struct maple_enode *mas_st
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
 
+retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
+			if (mte_dead_node(mas->node))
+				goto retry;
+
 			return NULL;
 		}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

