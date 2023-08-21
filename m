Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D55AEE49B3
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjHUUIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjHUUIQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CCF131;
        Mon, 21 Aug 2023 13:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7359F649EE;
        Mon, 21 Aug 2023 20:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C303CC433CB;
        Mon, 21 Aug 2023 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648493;
        bh=3i20pnBEinCK9ddZDRR6NoRQ8BsgF+99CG156P4J0Yg=;
        h=Date:To:From:Subject:From;
        b=CJVdbs0ZqLumnX4QeWRxevcj5kNOBso45ka78tEyBcGqOJZngoc5ocH2921CeWewG
         7ZxdHaZV28H+l5tkTz0ocB9DHw7tiwYkYKHXnLno6WUZuOFYGLuve6Bac4VbBdsxkU
         AjQ19h65VjTAgkhjeN1B3jBFJqxxLk5oQq/q7CBk=
Date:   Mon, 21 Aug 2023 13:08:13 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        stable@vger.kernel.org, tjmercier@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-multi-gen-lru-dont-spin-during-memcg-release.patch removed from -mm tree
Message-Id: <20230821200813.C303CC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: don't spin during memcg release
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-dont-spin-during-memcg-release.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: multi-gen LRU: don't spin during memcg release
Date: Mon, 14 Aug 2023 15:16:36 +0000

When a memcg is in the process of being released mem_cgroup_tryget will
fail because its reference count has already reached 0.  This can happen
during reclaim if the memcg has already been offlined, and we reclaim all
remaining pages attributed to the offlined memcg.  shrink_many attempts to
skip the empty memcg in this case, and continue reclaiming from the
remaining memcgs in the old generation.  If there is only one memcg
remaining, or if all remaining memcgs are in the process of being released
then shrink_many will spin until all memcgs have finished being released. 
The release occurs through a workqueue, so it can take a while before
kswapd is able to make any further progress.

This fix results in reductions in kswapd activity and direct reclaim in
a test where 28 apps (working set size > total memory) are repeatedly
launched in a random sequence:

                                       A          B      delta   ratio(%)
           allocstall_movable       5962       3539      -2423     -40.64
            allocstall_normal       2661       2417       -244      -9.17
kswapd_high_wmark_hit_quickly      53152       7594     -45558     -85.71
                   pageoutrun      57365      11750     -45615     -79.52

Link: https://lkml.kernel.org/r/20230814151636.1639123-1-tjmercier@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-dont-spin-during-memcg-release
+++ a/mm/vmscan.c
@@ -4854,16 +4854,17 @@ void lru_gen_release_memcg(struct mem_cg
 
 		spin_lock_irq(&pgdat->memcg_lru.lock);
 
-		VM_WARN_ON_ONCE(hlist_nulls_unhashed(&lruvec->lrugen.list));
+		if (hlist_nulls_unhashed(&lruvec->lrugen.list))
+			goto unlock;
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_rcu(&lruvec->lrugen.list);
+		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
 			WRITE_ONCE(pgdat->memcg_lru.seq, pgdat->memcg_lru.seq + 1);
-
+unlock:
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
 	}
 }
@@ -5435,8 +5436,10 @@ restart:
 	rcu_read_lock();
 
 	hlist_nulls_for_each_entry_rcu(lrugen, pos, &pgdat->memcg_lru.fifo[gen][bin], list) {
-		if (op)
+		if (op) {
 			lru_gen_rotate_memcg(lruvec, op);
+			op = 0;
+		}
 
 		mem_cgroup_put(memcg);
 
@@ -5444,7 +5447,7 @@ restart:
 		memcg = lruvec_memcg(lruvec);
 
 		if (!mem_cgroup_tryget(memcg)) {
-			op = 0;
+			lru_gen_release_memcg(memcg);
 			memcg = NULL;
 			continue;
 		}
_

Patches currently in -mm which might be from tjmercier@google.com are


