Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33793C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjIJVaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjIJVaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:30:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8820BB9
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:30:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C516C433C7;
        Sun, 10 Sep 2023 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694381413;
        bh=EtZKJXtk2Se2DmXUsuMVR8Xk+tYBimKTJFeiWClUm8Q=;
        h=Date:To:From:Subject:From;
        b=k9rMJz3vvQqW3l1cwSH86BctJkF1bz/X6HtXFgdOEsxfCVFNkAVs0TC+y9gxjDkQD
         WNaDbIt3MdD2GR0TH29fzQbk/n/AfbbFojpb4YTVwxnv1QfFFr5DUlU9XqSC5l2FyC
         XvJ0blDuTi7GKxafY5j4FTA+4ZAKNxh5wYpO4rcM=
Date:   Sun, 10 Sep 2023 14:30:12 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, yajun.deng@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch added to mm-nonmm-unstable branch
Message-Id: <20230910213013.1C516C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: remove redundant pr_info when node is memoryless
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mm_init.c: remove redundant pr_info when node is memoryless
Date: Wed, 6 Sep 2023 17:11:13 +0800

There is a similar pr_info in free_area_init_node(), so remove the
redundant pr_info.

Link: https://lkml.kernel.org/r/20230906091113.4029983-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless
+++ a/mm/mm_init.c
@@ -1871,8 +1871,6 @@ void __init free_area_init(unsigned long
 		pg_data_t *pgdat;
 
 		if (!node_online(nid)) {
-			pr_info("Initializing node %d as memoryless\n", nid);
-
 			/* Allocator not initialized yet */
 			pgdat = arch_alloc_nodedata(nid);
 			if (!pgdat)
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mm_initc-remove-redundant-pr_info-when-node-is-memoryless.patch

