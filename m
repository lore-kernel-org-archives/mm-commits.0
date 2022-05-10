Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48765C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiEJEOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiEJEOf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38EE80
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7647261737
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE99AC385C2;
        Tue, 10 May 2022 04:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155837;
        bh=N6Wnf4RYzImceS5e6QTRWABkn/sYw5wWZR4lR6ZInJw=;
        h=Date:To:From:Subject:From;
        b=naoUvGPNjUw87vb3eXvCWssiKzwxAU6UKQH630tHMhfoYK0qJf+SXKQyObVmADBXD
         zxHi0g9DHKxZ4YRtH3MjpglOh13yVt0NHJZ7t2zMa99pLrOrcGT1p+Tx8vnidAcvHL
         yc0drr2uKPMrIQMXrcJsPM4EI0gl6f0R7KpGTfew=
Date:   Mon, 09 May 2022 21:10:37 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch removed from -mm tree
Message-Id: <20220510041037.CE99AC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: mz already removed from rb_tree if not NULL
has been removed from the -mm tree.  Its filename was
     mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: mz already removed from rb_tree if not NULL

When mz is not NULL, it means mz can either come from
mem_cgroup_largest_soft_limit_node or
__mem_cgroup_largest_soft_limit_node.  And both of them have removed this
node by __mem_cgroup_remove_exceeded().

Not necessary to call __mem_cgroup_remove_exceeded() again.

[mhocko@suse.com: refine changelog]
Link: https://lkml.kernel.org/r/20220314233030.12334-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-mz-already-removed-from-rb_tree-if-not-null
+++ a/mm/memcontrol.c
@@ -3418,7 +3418,6 @@ unsigned long mem_cgroup_soft_limit_recl
 						    gfp_mask, total_scanned);
 		nr_reclaimed += reclaimed;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

