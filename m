Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8E7CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjIRQbp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjIRQbc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:31:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC183AB4
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:29:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B380FC116A4;
        Mon, 18 Sep 2023 16:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695054547;
        bh=mTES+fS+l057DOHGr6cyqba99SNFHgoZ90VgtVZaVvs=;
        h=Date:To:From:Subject:From;
        b=mz/Xp2ppu7EFkKSat7e2Z5cSshKf4Y+tf08dreRsjdwmBlcjTYGRyz7cUzL5uhser
         3czSo4yghp3DAD4HLJ2eeuK2Ty+nnBgN0nIUzFaqnf1f4/vIJWiAN5kaW6SfpelRzm
         St1XZgXzm5Z7MKBp/oBdffWcjAymdAE7Z0E2i2is=
Date:   Mon, 18 Sep 2023 09:29:07 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        willy@infradead.org, surenb@google.com, Liam.Howlett@oracle.com,
        jason.sim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20230918162907.B380FC116A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use mas_node_count_gfp() in mas_expected_entries()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jaeseon Sim <jason.sim@samsung.com>
Subject: maple_tree: use mas_node_count_gfp() in mas_expected_entries()
Date: Fri, 15 Sep 2023 18:32:43 +0900

Use mas_node_count_gfp with GFP_KERNEL instead of
GFP_NOWAIT | __GFP_NOWARN on mas_expected_entries
in order to allow memory reclaim.

Currently, fork errors occur on low free memory as follows:

 Zygote  : Failed to fork child process: Out of memory (12)

-ENOMEM was returned as following path:

 mas_node_count
 mas_expected_entries
 dup_mmap
 dup_mm
 copy_mm
 copy_process

Link: https://lkml.kernel.org/r/20230915093243epcms1p46fa00bbac1ab7b7dca94acb66c44c456@epcms1p4
Signed-off-by: Jaeseon Sim <jason.sim@samsung.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_node_count_gfp-on-mas_expected_entries
+++ a/lib/maple_tree.c
@@ -5574,7 +5574,7 @@ int mas_expected_entries(struct ma_state
 	/* Internal nodes */
 	nr_nodes += DIV_ROUND_UP(nr_nodes, nonleaf_cap);
 	/* Add working room for split (2 nodes) + new parents */
-	mas_node_count(mas, nr_nodes + 3);
+	mas_node_count_gfp(mas, nr_nodes + 3, GFP_KERNEL);
 
 	/* Detect if allocations run out */
 	mas->mas_flags |= MA_STATE_PREALLOC;
_

Patches currently in -mm which might be from jason.sim@samsung.com are

maple_tree-use-mas_node_count_gfp-on-mas_expected_entries.patch

