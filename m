Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D01757D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560219; cv=none; b=DfkxMgTB4J+yFJtMW/lCN2SMX3B1G6OuI57sEn/UVhfJjhShSMVu65upOWWzpWp0xxoblM4ZfHvQd1KGMtyQlDSV4dxPvmupR6fCZpmKpPjCwe2U8biP4SAyawVIdu0vLEJjkWPxlW7C4Fx4O0nbJYNp/JM0E3Stcua/22xNLTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560219; c=relaxed/simple;
	bh=MPYtLuVIo9yUdD2mX8f5SaWfVT6+/hV5xOcdf3dECKM=;
	h=Date:To:From:Subject:Message-Id; b=uPEf3k57p5Q/EX3fByCmfa5Bt94Ku/tdRKpH38gfDsYek3yNCowb9nhmkoSLe9lwWTqFDuKd2JCIkc9hBBPQzF4JlxxNrZd6z6+zW80E1WuIiaTaaPKpPK0pF+rGYaA6mAmhqzIx/TTuTkJ4eklmJFxzQCKFogxOw0zzI2iaC5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMSnLtkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMSnLtkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062B7C433C7;
	Thu, 22 Feb 2024 00:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560219;
	bh=MPYtLuVIo9yUdD2mX8f5SaWfVT6+/hV5xOcdf3dECKM=;
	h=Date:To:From:Subject:From;
	b=RMSnLtkdI3DGLQZYyKvFdiL9Z9S/eR8kFQZn/FsBB2beFyD5n5zangEEslwwwY1fa
	 NMBYQKleGl5G9H10wRP9II+TOGqmLXXmXEqZV2mf5/OoUgW1n9+8rxu2rmfdU31eKl
	 EMXYd5CWBezmSbbmWykmblC7Us2iSi4sTZ4cK0Kw=
Date: Wed, 21 Feb 2024 16:03:38 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-improve-should_run_aging.patch removed from -mm tree
Message-Id: <20240222000339.062B7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: improve should_run_aging()
has been removed from the -mm tree.  Its filename was
     mm-mglru-improve-should_run_aging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4584,14 +4584,13 @@ retry:
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
@@ -4619,13 +4618,7 @@ static bool should_run_aging(struct lruv
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
@@ -4657,6 +4650,7 @@ static bool should_run_aging(struct lruv
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, bool can_swap)
 {
+	bool success;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4664,14 +4658,17 @@ static long get_nr_to_scan(struct lruvec
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


