Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9504C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 00:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiC2AtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiC2AtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 20:49:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D55D671
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 17:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EEF4B81598
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 00:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D50BC340ED;
        Tue, 29 Mar 2022 00:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648514841;
        bh=c3XLhO2cTHIJhTCWSwDgyKxKA2bZVsEyk9+UqMLLqVc=;
        h=Date:To:From:Subject:From;
        b=o/L5j5mGST6i9RRQMeRXuVwrpdo8aXMnGFJ5VYMxXz9F9p4V7MRN1M50dZsHMJB6S
         GOJzCIFUxR3SAXkuLIaoI+fGv3GMWWdHZyc3Os2K9r3tC3aKe31ixgJYnKpxhUciys
         rsJODTDfzBAvan+yzHOl9PapMSQsJQI8lqc/TkLE=
Date:   Mon, 28 Mar 2022 17:47:20 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch added to -mm tree
Message-Id: <20220329004721.0D50BC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: mz already removed from rb_tree if not NULL
has been added to the -mm tree.  Its filename is
     mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

