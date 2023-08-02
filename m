Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661FEC001DF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 15:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbjHBP6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbjHBP6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 11:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8CF2103;
        Wed,  2 Aug 2023 08:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69FBF61A10;
        Wed,  2 Aug 2023 15:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69DCC433C9;
        Wed,  2 Aug 2023 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690991913;
        bh=9xubLaIO5MdhpiaxNsf8DSgID/M5lEj2ExNCYUJF2Ts=;
        h=Date:To:From:Subject:From;
        b=Rz4avHmrVNYWJxVZNqJRmoEgYG8wpCz/AOIWNLGQ1kHuKAaljYsF/1rMw52jwZQYx
         /fbqD+O4cgvLmEgYvnkWfAgG6UlWpjXiY4UGBgrGwdfMUNRnNd5Y4p6HYC+qfe1439
         6SeCYFWlf5G3d0Oxa7auWTHW5BHjf8z0KwEW6ro8=
Date:   Wed, 02 Aug 2023 08:58:33 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuzhao@google.com, surenb@google.com, suleiman@google.com,
        steven@liquorix.net, stable@vger.kernel.org,
        quic_charante@quicinc.com, oleksandr@natalenko.name,
        matthias.bgg@gmail.com, lecopzer.chen@mediatek.com,
        heftig@archlinux.org, bgeffon@google.com, baohua@kernel.org,
        angelogioacchino.delregno@collabora.com,
        aneesh.kumar@linux.ibm.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq.patch added to mm-unstable branch
Message-Id: <20230802155833.B69DCC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Multi-gen LRU: Avoid race in inc_min_seq()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq.patch

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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: Multi-gen LRU: Avoid race in inc_min_seq()
Date: Tue, 1 Aug 2023 19:56:03 -0700

inc_max_seq() will try to inc_min_seq() if nr_gens == MAX_NR_GENS. This
is because the generations are reused (the last oldest now empty
generation will become the next youngest generation).

inc_min_seq() is retried until successful, dropping the lru_lock
and yielding the CPU on each failure, and retaking the lock before
trying again:

        while (!inc_min_seq(lruvec, type, can_swap)) {
                spin_unlock_irq(&lruvec->lru_lock);
                cond_resched();
                spin_lock_irq(&lruvec->lru_lock);
        }

However, the initial condition that required incrementing the min_seq
(nr_gens == MAX_NR_GENS) is not retested. This can change by another
call to inc_max_seq() from run_aging() with force_scan=true from the
debugfs interface.

Since the eviction stalls when the nr_gens == MIN_NR_GENS, avoid
unnecessarily incrementing the min_seq by rechecking the number of
generations before each attempt.

This issue was uncovered in previous discussion on the list by Yu Zhao
and Aneesh Kumar [1].

[1] https://lore.kernel.org/linux-mm/CAOUHufbO7CaVm=xjEb1avDhHVvnC8pJmGyKcFf2iY_dpf+zR3w@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230802025606.346758-2-kaleshsingh@google.com
Fixes: d6c3af7d8a2b ("mm: multi-gen LRU: debugfs interface")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> [mediatek]
Tested-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -4439,7 +4439,7 @@ static void inc_max_seq(struct lruvec *l
 	int prev, next;
 	int type, zone;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-
+restart:
 	spin_lock_irq(&lruvec->lru_lock);
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
@@ -4450,11 +4450,12 @@ static void inc_max_seq(struct lruvec *l
 
 		VM_WARN_ON_ONCE(!force_scan && (type == LRU_GEN_FILE || can_swap));
 
-		while (!inc_min_seq(lruvec, type, can_swap)) {
-			spin_unlock_irq(&lruvec->lru_lock);
-			cond_resched();
-			spin_lock_irq(&lruvec->lru_lock);
-		}
+		if (inc_min_seq(lruvec, type, can_swap))
+			continue;
+
+		spin_unlock_irq(&lruvec->lru_lock);
+		cond_resched();
+		goto restart;
 	}
 
 	/*
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-unstable-multi-gen-lru-fix-per-zone-reclaim.patch
mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq.patch
mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around.patch

