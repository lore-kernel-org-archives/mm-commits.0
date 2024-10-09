Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1B31E32B1
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728507209; cv=none; b=Z66RIPLNI4fLoXPfJ1VTQxTEUPOrz+OcapHpQZyFF8wsSGQ+ANALGA/bbfhHpHVyOhuA2tILR9oORghnOai6HZL2fw8QSx5JyX8B4+dFILO3hqJJjzQSR/BluyClrtx3rARMay/0YXadf3Q9sy0mMgAfN/fgdxbiCY/PZXoIrEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728507209; c=relaxed/simple;
	bh=5/X4pyBLmfWvedUFiS0Lg7zuyfT9EH8ORZkO2LAjSeY=;
	h=Date:To:From:Subject:Message-Id; b=o2FvwbdskSBcmHaRpRpFQ6VC/f+eOEOjm/qBB5N8BTvi9BWuL28o35bT48ys5KTo1ja6g8LPgntJt566eMPFQcIxT55BqJCZ4cOQX7SCduGyNMbhkBAox/xNf5OjUnUaLqwQmuyJtA15unnKezcX8pjX4RvaXCJ0EBXyOww4jzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U37ZeHTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U37ZeHTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6F1C4CECE;
	Wed,  9 Oct 2024 20:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728507208;
	bh=5/X4pyBLmfWvedUFiS0Lg7zuyfT9EH8ORZkO2LAjSeY=;
	h=Date:To:From:Subject:From;
	b=U37ZeHTmHBBjs/sfE0noesBWLGLRLUl4i1DXbfchdCa2cMzD0YfjXp/OY6RcX+Mtg
	 G4w0eyGa1Q2yB52WtIlKoW6ab0e1qqj5RqnwBTy5EYneYuY2TP/iSJ1ZN0ZcZ334J3
	 2+yZGsLnOnr4pFcbDHBRrbVlPdnhZk1MUf9LVsng=
Date: Wed, 09 Oct 2024 13:53:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch added to mm-hotfixes-unstable branch
Message-Id: <20241009205328.BE6F1C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: throttle and inc min_seq when both page types reach MIN_NR_GENS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: throttle and inc min_seq when both page types reach MIN_NR_GENS
Date: Wed, 9 Oct 2024 15:49:53 +0800

The test case of [1] leads to system hang which caused by a local watchdog
thread starved over 20s on a 5.5GB RAM ANDROID15(v6.6) system.  This
commit solve the issue by have the reclaimer be throttled and increase
min_seq if both page types reach MIN_NR_GENS, which may introduce a
livelock of switching type with holding lruvec->lru_lock.

[1]
launch below script 8 times simutanously which allocates 1GB virtual
memory and access it from user space by each thread.
$ costmem -c1024000 -b12800 -o0 &

Link: https://lkml.kernel.org/r/20241009074953.608591-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens
+++ a/mm/vmscan.c
@@ -4387,11 +4387,23 @@ static int scan_folios(struct lruvec *lr
 	int remaining = MAX_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
-		return 0;
+	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
+		/*
+		 * throttle for a while and then increase the min_seq since
+		 * both page types reach the limit.
+		 */
+		if (get_nr_gens(lruvec, !type) == MIN_NR_GENS) {
+			spin_unlock_irq(&lruvec->lru_lock);
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+			spin_lock_irq(&lruvec->lru_lock);
+			try_to_inc_min_seq(lruvec, get_swappiness(lruvec, sc));
+		} else
+			return 0;
+	}
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch
mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch
mm-optimization-on-page-allocation-when-cma-enabled.patch

