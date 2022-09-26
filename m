Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F3DC32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiIZRDV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiIZRC5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:02:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E854580BB
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 003FEB80B0F
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A17C433C1;
        Mon, 26 Sep 2022 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664208283;
        bh=7HhCPPIfQyCGZ/c+4C4ZfSCqIy8XWrFgnFyaUJWSyto=;
        h=Date:To:From:Subject:From;
        b=1EmRx35RC843jjr/2RscCvDmxjezuaKH5sDNEKnECh9Fb6poR6VS5pGtODyX0dcKi
         +3IHj3LxbYdCGA8u9ibWMkNx6a9a5ADakXRfJygydIibV/2bmv9O4khMnVP49IoGHf
         BUgPRQG1NqXDxtwxg+dxlhCJBSGwradK+VEo1jH4=
Date:   Mon, 26 Sep 2022 09:04:42 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch added to mm-unstable branch
Message-Id: <20220926160443.88A17C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use do_memsw_account() in a few more places
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch

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
mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch
mm-memcontrol-deprecate-swapaccounting=0-mode.patch
mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch
mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

