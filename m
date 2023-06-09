Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069F5C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbjFIXdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjFIXb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FBE3C30
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D20E465CD2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FFBC433EF;
        Fri,  9 Jun 2023 23:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353379;
        bh=EQktDGwwkm1B2H4+uUX8KYUDHZ+Z7viP14Hk+ZAXuZ4=;
        h=Date:To:From:Subject:From;
        b=Mo5snHGJ8AoaQZTsSziUDXi7oIyEwlTKmoGGo6yBit3wcZYx0+G9qKgP4Piblo6uj
         3KAQTqgQbM9lWk4K9wM3WiGDeeOlC3R2gR0jiXeITBB7sx/vFU0v23QUqFlJDn9w/w
         a9ND5LAFXGGniMvucgh5So8ZYlvnKE72aU6OjfbU=
Date:   Fri, 09 Jun 2023 16:29:38 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com,
        quic_charante@quicinc.com, oleksandr@natalenko.name,
        heftig@archlinux.org, bgeffon@google.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unstable-multi-gen-lru-fix-workingset-accounting.patch removed from -mm tree
Message-Id: <20230609232939.31FFBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Multi-gen LRU: fix workingset accounting
has been removed from the -mm tree.  Its filename was
     mm-unstable-multi-gen-lru-fix-workingset-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: Multi-gen LRU: fix workingset accounting
Date: Tue, 23 May 2023 13:59:21 -0700

On Android app cycle workloads, MGLRU showed a significant reduction in
workingset refaults although pgpgin/pswpin remained relatively unchanged. 
This indicated MGLRU may be undercounting workingset refaults.

This has impact on userspace programs, like Android's LMKD, that monitor
workingset refault statistics to detect thrashing.

It was found that refaults were only accounted if the MGLRU shadow entry
was for a recently evicted folio.  However, recently evicted folios should
be accounted as workingset activation, and refaults should be accounted
regardless of recency.

Fix MGLRU's workingset refault and activation accounting to more closely
match that of the conventional active/inactive LRU.

Link: https://lkml.kernel.org/r/20230523205922.3852731-1-kaleshsingh@google.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c     |    1 -
 mm/workingset.c |   10 +++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-unstable-multi-gen-lru-fix-workingset-accounting
+++ a/mm/vmscan.c
@@ -4925,7 +4925,6 @@ static bool sort_folio(struct lruvec *lr
 
 		WRITE_ONCE(lrugen->protected[hist][type][tier - 1],
 			   lrugen->protected[hist][type][tier - 1] + delta);
-		__mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		return true;
 	}
 
--- a/mm/workingset.c~mm-unstable-multi-gen-lru-fix-workingset-accounting
+++ a/mm/workingset.c
@@ -278,6 +278,7 @@ static bool lru_gen_test_recent(void *sh
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
 {
+	bool recent;
 	int hist, tier, refs;
 	bool workingset;
 	unsigned long token;
@@ -288,10 +289,13 @@ static void lru_gen_refault(struct folio
 
 	rcu_read_lock();
 
-	if (!lru_gen_test_recent(shadow, type, &lruvec, &token, &workingset))
+	recent = lru_gen_test_recent(shadow, type, &lruvec, &token, &workingset);
+	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
-	if (lruvec != folio_lruvec(folio))
+	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
+
+	if (!recent)
 		goto unlock;
 
 	lrugen = &lruvec->lrugen;
@@ -302,7 +306,7 @@ static void lru_gen_refault(struct folio
 	tier = lru_tier_from_refs(refs);
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
-	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
+	mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 
 	/*
 	 * Count the following two cases as stalls:
_

Patches currently in -mm which might be from kaleshsingh@google.com are


