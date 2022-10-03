Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB063C41535
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJCVR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiJCVPr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E891E140D8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC09FB811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C37EC433D7;
        Mon,  3 Oct 2022 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831420;
        bh=zoOp3ykWOzKsJaqmebpMxlNafZdgaq+VBqOyUd+V1jg=;
        h=Date:To:From:Subject:From;
        b=NWz5blWhZHg8jv0rTNWCXMXV45Eo0L91+VbrZF/X+s4GZON4AhSkwUIo1QtfWhAn8
         BdOeaujaRF5syzs7R/Y+3e85ERgMFtjgihOfy6E1jRy8wKWNXDYmDjmOveFRYdyrq+
         A+HpjF901l/3yceiLsjcq6uJqNXYM1R/E+06S4vI=
Date:   Mon, 03 Oct 2022 14:10:19 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch removed from -mm tree
Message-Id: <20221003211020.5C37EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: use do_memsw_account() in a few more places
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use do_memsw_account() in a few more places
Date: Mon, 26 Sep 2022 09:57:03 -0400

It's slightly more descriptive and consistent with other places that
distinguish cgroup1's combined memory+swap accounting scheme from
cgroup2's dedicated swap accounting.

Link: https://lkml.kernel.org/r/20220926135704.400818-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-do_memsw_account-in-a-few-more-places
+++ a/mm/memcontrol.c
@@ -1667,17 +1667,17 @@ unsigned long mem_cgroup_get_max(struct
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		if (mem_cgroup_swappiness(memcg))
-			max += min(READ_ONCE(memcg->swap.max),
-				   (unsigned long)total_swap_pages);
-	} else { /* v1 */
+	if (do_memsw_account()) {
 		if (mem_cgroup_swappiness(memcg)) {
 			/* Calculate swap excess capacity from memsw limit */
 			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
 
 			max += min(swap, (unsigned long)total_swap_pages);
 		}
+	} else {
+		if (mem_cgroup_swappiness(memcg))
+			max += min(READ_ONCE(memcg->swap.max),
+				   (unsigned long)total_swap_pages);
 	}
 	return max;
 }
@@ -7334,7 +7334,7 @@ void mem_cgroup_swapout(struct folio *fo
 	if (mem_cgroup_disabled())
 		return;
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!do_memsw_account())
 		return;
 
 	memcg = folio_memcg(folio);
@@ -7399,7 +7399,7 @@ int __mem_cgroup_try_charge_swap(struct
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (do_memsw_account())
 		return 0;
 
 	memcg = folio_memcg(folio);
@@ -7451,10 +7451,10 @@ void __mem_cgroup_uncharge_swap(swp_entr
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
-			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-				page_counter_uncharge(&memcg->swap, nr_pages);
-			else
+			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
+			else
+				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 		mem_cgroup_id_put_many(memcg, nr_pages);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

