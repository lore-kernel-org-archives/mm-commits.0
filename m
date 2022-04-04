Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B34EC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383213AbiDDVld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380490AbiDDUTb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 16:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FAC33EB0
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 13:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC0860DD7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 20:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC0CC2BBE4;
        Mon,  4 Apr 2022 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649103454;
        bh=DUy9V+jDLqfWVH/1OaIMnIwVexwzZCCqit3WcgVsHQ8=;
        h=Date:To:From:Subject:From;
        b=cXGQzNw9xuJg3zGS+wsMhPhB2P8QRiWcP+eZcrXLp9R6iJnGkJmhqMHaT+rQaqSmC
         SRrlcltOjXWR3Fmfyn1y5XfXC03sykIXrlxzENiy+Iu4EcoQ2KDqD1NcMiBUEU9yH/
         HQ8dGL7r6WC185Z2de40qi8bSMJ3TfiL08coYSuI=
Date:   Mon, 04 Apr 2022 13:17:33 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-non-hierarchical-mode-is-deprecated.patch added to -mm tree
Message-Id: <20220404201734.1AC0CC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: non-hierarchical mode is deprecated
has been added to the -mm tree.  Its filename is
     mm-memcg-non-hierarchical-mode-is-deprecated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-non-hierarchical-mode-is-deprecated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-non-hierarchical-mode-is-deprecated.patch

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
Subject: mm/memcg: non-hierarchical mode is deprecated

After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
mode"), we won't have a NULL parent except root_mem_cgroup.  And this case
is handled when (memcg == root).

Link: https://lkml.kernel.org/r/20220403020833.26164-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-non-hierarchical-mode-is-deprecated
+++ a/mm/memcontrol.c
@@ -6588,9 +6588,6 @@ void mem_cgroup_calculate_protection(str
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	/* No parent means a non-hierarchical mode on v1 memcg */
-	if (!parent)
-		return;
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-memcg-non-hierarchical-mode-is-deprecated.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

