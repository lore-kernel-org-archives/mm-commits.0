Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE85C5FA
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707923575; cv=none; b=Fckq5IvUrD1oAMMb8hufyd+Dg7hsXpxMnodIXec82/RzpXxwyRGP4B/WLyJeEfziYd3+K5qRrV78DgzGYVd4hZ7vp8iAv3p3KfSfpAp11hood9Nt4+A+IIGM6dXp9zrvlmyaPcQJ8Dxs+6fdz1dSlCgZbn0iOtTs9QaKJS0+12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707923575; c=relaxed/simple;
	bh=ZVcMVQVntLsB14uGj0AenrTshkT44mzK2hKxvFzTboM=;
	h=Date:To:From:Subject:Message-Id; b=qA27BPiVzJHPb0uMEeT4tgiMc+yxLeiGDkAoLIzg+kWoVSXw5hOHFRHORKl9LK3yg002El/kkGGZ3GUYaxwy9WQJSDEA67MQW4qc0WC4HWFhLwalveJTuFUSPhTGFCZVCHE0RcM27TXD4KsVFVuG5qjkUvLbWGXFgMDfWDcEWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b9J/OJrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b9J/OJrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23EAC433F1;
	Wed, 14 Feb 2024 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707923574;
	bh=ZVcMVQVntLsB14uGj0AenrTshkT44mzK2hKxvFzTboM=;
	h=Date:To:From:Subject:From;
	b=b9J/OJrVQrQGqCHT5kXvo86R53DwI9z82e1gN79vWi0iB6wjpwzgqYI1zUba7yUNE
	 uptTvQ2WEftNhOVfQwNQzj8ddyzRQOcg77WdjHjt1vzcnnoC/AisNzcwACjq6iMAXx
	 Hh/nfcdBBZlaUQPT1/vaHV5mMfl2yKfqyneuz9zY=
Date: Wed, 14 Feb 2024 07:12:54 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-improve-should_run_aging.patch added to mm-unstable branch
Message-Id: <20240214151254.A23EAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: improve should_run_aging()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-improve-should_run_aging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-improve-should_run_aging.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: mm/mglru: improve should_run_aging()
Date: Wed, 14 Feb 2024 06:05:35 +0000

scan_control *sc does not need to be passed into should_run_aging(), as it
provides only the reclaim priority.  This can be moved to
get_nr_to_scan().

Refactor should_run_aging() and get_nr_to_scan() to improve code
readability.  No functional changes.

Link: https://lkml.kernel.org/r/20240214060538.3524462-3-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-improve-should_run_aging
+++ a/mm/vmscan.c
@@ -4585,14 +4585,13 @@ retry:
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, bool can_swap, unsigned long *nr_to_scan)
+			     bool can_swap, unsigned long *nr_to_scan)
 {
 	int gen, type, zone;
 	unsigned long old = 0;
 	unsigned long young = 0;
 	unsigned long total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* whether this lruvec is completely out of cold folios */
@@ -4620,13 +4619,7 @@ static bool should_run_aging(struct lruv
 		}
 	}
 
-	/* try to scrape all its memory if this memcg was deleted */
-	if (!mem_cgroup_online(memcg)) {
-		*nr_to_scan = total;
-		return false;
-	}
-
-	*nr_to_scan = total >> sc->priority;
+	*nr_to_scan = total;
 
 	/*
 	 * The aging tries to be lazy to reduce the overhead, while the eviction
@@ -4658,6 +4651,7 @@ static bool should_run_aging(struct lruv
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, bool can_swap)
 {
+	bool success;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4665,14 +4659,17 @@ static long get_nr_to_scan(struct lruvec
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	if (!should_run_aging(lruvec, max_seq, sc, can_swap, &nr_to_scan))
-		return nr_to_scan;
+	success = should_run_aging(lruvec, max_seq, can_swap, &nr_to_scan);
 
-	/* skip the aging path at the default priority */
-	if (sc->priority == DEF_PRIORITY)
+	/* try to scrape all its memory if this memcg was deleted */
+	if (nr_to_scan && !mem_cgroup_online(memcg))
 		return nr_to_scan;
 
-	/* skip this lruvec as it's low on cold folios */
+	/* try to get away with not aging at the default priority */
+	if (!success || sc->priority == DEF_PRIORITY)
+		return nr_to_scan >> sc->priority;
+
+	/* stop scanning this lruvec as it's low on cold folios */
 	return try_to_inc_max_seq(lruvec, max_seq, can_swap, false) ? -1 : 0;
 }
 
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-drop-unused-parameter.patch
mm-mglru-improve-should_run_aging.patch
mm-mglru-improve-reset_mm_stats.patch
mm-mglru-improve-struct-lru_gen_mm_walk.patch
mm-mglru-improve-swappiness-handling.patch

