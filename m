Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BDBC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiLLCRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiLLCQT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED568DFC2
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8707660EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1E6C433D2;
        Mon, 12 Dec 2022 02:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811298;
        bh=6YJN5e8Y4qfgHJA73N5IYHStu88nl/SGGPlW2cd6HWg=;
        h=Date:To:From:Subject:From;
        b=rE3iT5Vnf1IyoZkVstEx98CSGq3GICY31JkFOTM3+XaDnzdgi8jAAUSPnyMlcbwfy
         sl6uQN+DEqUECmw6ZHAaOpIl8163HHwdojGWh8NgYhegRt4cyzwG+sErKq+qPqrkb7
         ly3FZXTtcg/yNSeP1nUoxQeXHGVb19ConziCtCDQ=
Date:   Sun, 11 Dec 2022 18:14:57 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-fix-swapcached-stat-accounting.patch removed from -mm tree
Message-Id: <20221212021457.DE1E6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: fix swapcached stat accounting
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-swapcached-stat-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: memcg: fix swapcached stat accounting
Date: Sun, 4 Dec 2022 17:01:03 -0800 (PST)

I'd been worried by high "swapcached" counts in memcg OOM reports, thought
we had a problem freeing swapcache, but it was just the accounting that
was wrong.

Two issues:

1.  When __remove_mapping() removes swapcache,
   __delete_from_swap_cache() relies on memcg_data for the right counts to
   be updated; but that had already been reset by mem_cgroup_swapout(). 
   Swap those calls around - mem_cgroup_swapout() does not require the
   swapcached flag to be set.

   6.1 commit ac35a4902374 ("mm: multi-gen LRU: minimal
   implementation") already made a similar swap for workingset_eviction(),
   but not for this.

2.  memcg's "swapcached" count was added for memcg v2 stats, but
   displayed on OOM even for memcg v1: so mem_cgroup_move_account() ought
   to move it.

Link: https://lkml.kernel.org/r/b8b96ee0-1e1e-85f8-df97-c82a11d7cd14@google.com
Fixes: b6038942480e ("mm: memcg: add swapcache stat for memcg v2")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 mm/vmscan.c     |    3 +--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-swapcached-stat-accounting
+++ a/mm/memcontrol.c
@@ -5767,6 +5767,12 @@ static int mem_cgroup_move_account(struc
 		}
 	}
 
+#ifdef CONFIG_SWAP
+	if (folio_test_swapcache(folio)) {
+		__mod_lruvec_state(from_vec, NR_SWAPCACHE, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_SWAPCACHE, nr_pages);
+	}
+#endif
 	if (folio_test_writeback(folio)) {
 		__mod_lruvec_state(from_vec, NR_WRITEBACK, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
--- a/mm/vmscan.c~mm-memcg-fix-swapcached-stat-accounting
+++ a/mm/vmscan.c
@@ -1368,11 +1368,10 @@ static int __remove_mapping(struct addre
 	if (folio_test_swapcache(folio)) {
 		swp_entry_t swap = folio_swap_entry(folio);
 
-		/* get a shadow entry before mem_cgroup_swapout() clears folio_memcg() */
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		mem_cgroup_swapout(folio, swap);
 		__delete_from_swap_cache(folio, swap, shadow);
+		mem_cgroup_swapout(folio, swap);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_folio(folio, swap);
 	} else {
_

Patches currently in -mm which might be from hughd@google.com are


