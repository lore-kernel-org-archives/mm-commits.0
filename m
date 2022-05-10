Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB68AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiEJEPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiEJEOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7F55F7B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 439A1B81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012C4C385C5;
        Tue, 10 May 2022 04:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155842;
        bh=AFCl6tS5698Xg7YHKlh6gXn2CZUGNk/G/l/LxRMHFuc=;
        h=Date:To:From:Subject:From;
        b=tZS56IVddQcjmrVH1DPnwYp78vjLAUZG1VpV6YuQvwpehVhQHPplTi/uQijFFvNbT
         A7x71SMGVmAx8pAqQ3caUX2ab2SMgT8GZ1TT3ElXls7Guzt16uaQrxn6E3CuXA+lJD
         mJypGopUUEVwZRxX82gEYCGFjBbwHDqPG438I7hM=
Date:   Mon, 09 May 2022 21:10:41 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-non-hierarchical-mode-is-deprecated.patch removed from -mm tree
Message-Id: <20220510041042.012C4C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: non-hierarchical mode is deprecated
has been removed from the -mm tree.  Its filename was
     mm-memcg-non-hierarchical-mode-is-deprecated.patch

This patch was dropped because it was merged into mm-stable

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
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-non-hierarchical-mode-is-deprecated
+++ a/mm/memcontrol.c
@@ -6587,9 +6587,6 @@ void mem_cgroup_calculate_protection(str
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	/* No parent means a non-hierarchical mode on v1 memcg */
-	if (!parent)
-		return;
 
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

