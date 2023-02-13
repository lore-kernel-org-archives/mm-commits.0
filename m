Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FCFC636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 18:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBMS3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 13:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMS3g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 13:29:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E8B1259D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 10:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0613C6123A
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 18:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571AEC433EF;
        Mon, 13 Feb 2023 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676312886;
        bh=7v8966LmdPjyMk0PbfQEscZr5DS8z5FZZAc4aTjBvYE=;
        h=Date:To:From:Subject:From;
        b=NbNgEgdK2fDwp5lLyu4kITqAyQqYjx1y39EQA6czc1Cd8nvcFRBf31AoEkqkj52/2
         qd6LX1OvWdntqDsl+0m9PTqSNpHEWjlLVA/nxxyo2wXQtdmTCGQIEA2Fc5nvhfVLp+
         lIJyhMp/Of68oxcKLZ/HWAAlQzegOJUG85P2k0WI=
Date:   Mon, 13 Feb 2023 10:28:05 -0800
To:     mm-commits@vger.kernel.org, tjmercier@google.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-avoid-futile-retries.patch added to mm-unstable branch
Message-Id: <20230213182806.571AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: avoid futile retries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-avoid-futile-retries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-avoid-futile-retries.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: avoid futile retries
Date: Mon, 13 Feb 2023 00:53:22 -0700

Recall that the per-node memcg LRU has two generations and they alternate
when the last memcg (of a given node) is moved from one to the other. 
Each generation is also sharded into multiple bins to improve scalability.
A reclaimer starts with a random bin (in the old generation) and, if it
fails, it will retry, i.e., to try the rest of the bins.

If a reclaimer fails with the last memcg, it should move this memcg to the
young generation first, which causes the generations to alternate, and
then retry.  Otherwise, the retries will be futile because all other bins
are empty.

Link: https://lkml.kernel.org/r/20230213075322.1416966-1-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-avoid-futile-retries
+++ a/mm/vmscan.c
@@ -5356,18 +5356,20 @@ static int shrink_one(struct lruvec *lru
 
 static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 {
+	int op;
 	int gen;
 	int bin;
 	int first_bin;
 	struct lruvec *lruvec;
 	struct lru_gen_folio *lrugen;
+	struct mem_cgroup *memcg;
 	const struct hlist_nulls_node *pos;
-	int op = 0;
-	struct mem_cgroup *memcg = NULL;
 	unsigned long nr_to_reclaim = get_nr_to_reclaim(sc);
 
 	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
 restart:
+	op = 0;
+	memcg = NULL;
 	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
 
 	rcu_read_lock();
@@ -5391,14 +5393,22 @@ restart:
 
 		op = shrink_one(lruvec, sc);
 
-		if (sc->nr_reclaimed >= nr_to_reclaim)
-			goto success;
-
 		rcu_read_lock();
+
+		if (sc->nr_reclaimed >= nr_to_reclaim)
+			break;
 	}
 
 	rcu_read_unlock();
 
+	if (op)
+		lru_gen_rotate_memcg(lruvec, op);
+
+	mem_cgroup_put(memcg);
+
+	if (sc->nr_reclaimed >= nr_to_reclaim)
+		return;
+
 	/* restart if raced with lru_gen_rotate_memcg() */
 	if (gen != get_nulls_value(pos))
 		goto restart;
@@ -5407,11 +5417,6 @@ restart:
 	bin = get_memcg_bin(bin + 1);
 	if (bin != first_bin)
 		goto restart;
-success:
-	if (op)
-		lru_gen_rotate_memcg(lruvec, op);
-
-	mem_cgroup_put(memcg);
 }
 
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-avoid-futile-retries.patch

