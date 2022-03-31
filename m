Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204C5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352344AbiCaBqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaBqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B607483AD
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB9796192E
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471E5C340F0;
        Thu, 31 Mar 2022 01:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648691092;
        bh=872sNNDQhpA6JfSCRMS7BgaEi+6PsrJlStpUP5IKPZE=;
        h=Date:To:From:Subject:From;
        b=xBH+IZcaYNeWrYoPgXfuS7UL330TK8Eozmz4lqT5/ET8L4nsu+HMc8x+8kOvp37mT
         B2y6Qn9pK35BIU/GQreliROmFTsXFazt4NnW6bf+61+SFGqZ4G9U3RAoq0mfXNP7Qn
         9PIK0sXnetOkc2ZtklR6cvVcwikpObPouSw25CdU=
Date:   Wed, 30 Mar 2022 18:44:51 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch added to -mm tree
Message-Id: <20220331014452.471E5C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set pos explicitly for reclaim and !reclaim
has been added to the -mm tree.  Its filename is
     mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch

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
Subject: mm/memcg: set pos explicitly for reclaim and !reclaim

During mem_cgroup_iter, there are two ways to get iteration position:
reclaim vs non-reclaim mode.

Let's do it explicitly for reclaim vs non-reclaim mode.

Link: https://lkml.kernel.org/r/20220330234719.18340-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim
+++ a/mm/memcontrol.c
@@ -1013,9 +1013,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
@@ -1041,6 +1038,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			 */
 			(void)cmpxchg(&iter->position, pos, NULL);
 		}
+	} else if (prev) {
+		pos = prev;
 	}
 
 	if (pos)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

