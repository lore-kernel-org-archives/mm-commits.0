Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F275D900
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707923581; cv=none; b=NJtNe9m/5aO4zXca8aM3f3C2AtzFkvgg+iLCiCuh4fLbaZDg+AoGos2vch/CDBX6xCJ0c9yjrQOreWmM53p/ljVEL9ccIW79z4sCnj8RVG0jdR8jwMixiYtHsGWPL5igh4dZiCGBnLKu2jmc0tFmseu5/HWQDH5iAkRh/NvL3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707923581; c=relaxed/simple;
	bh=HkxDRges29pn9HO/EnNSEG2/Exdcrw9OU4/qZVwbHbM=;
	h=Date:To:From:Subject:Message-Id; b=iPcJmLOZU/1ZlK4BGJOmuQDfpkHzNaCRcYCuiRe7Snvz7BmwljFl0M71OHRNEGnqM5uaNrVj6Dfrem95GR83aNxgKsjH1WFWfdPlUSA4idZ5ua0UmsRoMrgPzqNr3D5N6HeKqeg6utBGEBTI3/fTU9FPBTD1PI9xKFfBtAwivSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pmbO2TKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pmbO2TKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09A0C433C7;
	Wed, 14 Feb 2024 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707923580;
	bh=HkxDRges29pn9HO/EnNSEG2/Exdcrw9OU4/qZVwbHbM=;
	h=Date:To:From:Subject:From;
	b=pmbO2TKFORZkSrJt7/3NGC/l5CdHtBsiEpSIwGGxn0DZX3t4WziCTKtSmo3VTHwKz
	 Y2lmCKwBjLkm3GVjXRTOD0ynhoZ0Q99YaTU2bBhjOogCPqXLX6kQdGxH0UV0nvxqxc
	 t1+qTRDpk8DqNy+eCcB/HlKSfog2H95EZ1+g3yQo=
Date: Wed, 14 Feb 2024 07:13:00 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,donettom@linux.vnet.ibm.com,aneesh.kumar@linux.ibm.com,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-improve-swappiness-handling.patch added to mm-unstable branch
Message-Id: <20240214151300.A09A0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: improve swappiness handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-improve-swappiness-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-improve-swappiness-handling.patch

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
Subject: mm/mglru: improve swappiness handling
Date: Wed, 14 Feb 2024 06:05:38 +0000

The reclaimable number of anon pages used to set initial reclaim priority
is only based on get_swappiness().  Use can_reclaim_anon_pages() to
include NUMA node demotion.

Also move the swappiness handling of when !__GFP_IO in
try_to_shrink_lruvec() into isolate_folios().

Link: https://lkml.kernel.org/r/20240214060538.3524462-6-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/vmscan.c~mm-mglru-improve-swappiness-handling
+++ a/mm/vmscan.c
@@ -4290,7 +4290,7 @@ static bool isolate_folio(struct lruvec
 {
 	bool success;
 
-	/* swapping inhibited */
+	/* swap constrained */
 	if (!(sc->gfp_mask & __GFP_IO) &&
 	    (folio_test_dirty(folio) ||
 	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
@@ -4459,9 +4459,12 @@ static int isolate_folios(struct lruvec
 	DEFINE_MIN_SEQ(lruvec);
 
 	/*
-	 * Try to make the obvious choice first. When anon and file are both
-	 * available from the same generation, interpret swappiness 1 as file
-	 * first and 200 as anon first.
+	 * Try to make the obvious choice first, and if anon and file are both
+	 * available from the same generation,
+	 * 1. Interpret swappiness 1 as file first and MAX_SWAPPINESS as anon
+	 *    first.
+	 * 2. If !__GFP_IO, file first since clean pagecache is more likely to
+	 *    exist than clean swapcache.
 	 */
 	if (!swappiness)
 		type = LRU_GEN_FILE;
@@ -4471,6 +4474,8 @@ static int isolate_folios(struct lruvec
 		type = LRU_GEN_FILE;
 	else if (swappiness == 200)
 		type = LRU_GEN_ANON;
+	else if (!(sc->gfp_mask & __GFP_IO))
+		type = LRU_GEN_FILE;
 	else
 		type = get_type_to_scan(lruvec, swappiness, &tier);
 
@@ -4714,10 +4719,6 @@ static bool try_to_shrink_lruvec(struct
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
-	/* clean file folios are more likely to exist */
-	if (swappiness && !(sc->gfp_mask & __GFP_IO))
-		swappiness = 1;
-
 	while (true) {
 		int delta;
 
@@ -4880,7 +4881,6 @@ static void set_initial_priority(struct
 {
 	int priority;
 	unsigned long reclaimable;
-	struct lruvec *lruvec = mem_cgroup_lruvec(NULL, pgdat);
 
 	if (sc->priority != DEF_PRIORITY || sc->nr_to_reclaim < MIN_LRU_BATCH)
 		return;
@@ -4890,7 +4890,7 @@ static void set_initial_priority(struct
 	 * where reclaimed_to_scanned_ratio = inactive / total.
 	 */
 	reclaimable = node_page_state(pgdat, NR_INACTIVE_FILE);
-	if (get_swappiness(lruvec, sc))
+	if (can_reclaim_anon_pages(NULL, pgdat->node_id, sc))
 		reclaimable += node_page_state(pgdat, NR_INACTIVE_ANON);
 
 	/* round down reclaimable and round up sc->nr_to_reclaim */
_

Patches currently in -mm which might be from kinseyho@google.com are

mm-mglru-drop-unused-parameter.patch
mm-mglru-improve-should_run_aging.patch
mm-mglru-improve-reset_mm_stats.patch
mm-mglru-improve-struct-lru_gen_mm_walk.patch
mm-mglru-improve-swappiness-handling.patch

