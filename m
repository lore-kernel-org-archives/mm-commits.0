Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4897CEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjHNTM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjHNTMu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47483110;
        Mon, 14 Aug 2023 12:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D999F64491;
        Mon, 14 Aug 2023 19:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A75C433C9;
        Mon, 14 Aug 2023 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692040368;
        bh=ZoeMoUE03SosJCbcUmtHKTyqaRp4E+mEOp5Ww1c+W30=;
        h=Date:To:From:Subject:From;
        b=gziEFibrhMjHu4ZUq4jwuIoXWLRfex1vHDH3inCYKCa/LfWJuE2sFw7KR5JoQIxjW
         sddi/ep61Scyy/VfCeTrK2MNYiU3hKZtqwT/QQIir2RkGV+1QdpxE9qUcGU1fl1cFB
         AzEgPlwxXtwRMSJRzIdoFgU660S1om+t1iIzZWN8=
Date:   Mon, 14 Aug 2023 12:12:47 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        stable@vger.kernel.org, tjmercier@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-dont-spin-during-memcg-release.patch added to mm-hotfixes-unstable branch
Message-Id: <20230814191248.39A75C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: don't spin during memcg release
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-dont-spin-during-memcg-release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-dont-spin-during-memcg-release.patch

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

mm-multi-gen-lru-dont-spin-during-memcg-release.patch

