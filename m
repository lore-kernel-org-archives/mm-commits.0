Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E31E890;
	Mon, 15 Jul 2024 23:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721087296; cv=none; b=fQk7fcLzqOoieiWl7lfilDYW+cBa3jsuOMm34tsuQLHlj7PPfoc51fGEPI4N/hvd01419/ZFJNQI8F/tzwEfFEVhyw+boYOxlpcyCaLfUaIoOz+gkYuFBjsvtL+daGoYuPCPV+Mn1XtFE4AvrY6axIL9T3cO03+8ITPUGnJS1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721087296; c=relaxed/simple;
	bh=YrTcrRWzMaNm2QxGF+2IO46GlIP/f9g2nMPw5HtpaUA=;
	h=Date:To:From:Subject:Message-Id; b=RUas6pzWswexU1bV99E2vTAdc6hHIek+38i3VGzgaOhn6PwYKiAj5N76fonSN8PSOj+6YRCanMqXazYVqmpv8jFqqQQm9Q6mZR7cH1j4Y+Pi1gYm4ep5tqTboT2qot8cBTU6q8SXCxWQKjMcGVflwHUxOAJWqH/csFB+lzkwEpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=It45uAtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="It45uAtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED8C32782;
	Mon, 15 Jul 2024 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721087296;
	bh=YrTcrRWzMaNm2QxGF+2IO46GlIP/f9g2nMPw5HtpaUA=;
	h=Date:To:From:Subject:From;
	b=It45uAtVkjeI+OuzBQ8FlysJ1JbXJLiZuctGHhMbA8qeJEoGh0X00JpROo0vYqW78
	 1IhUNHnLfavtRgyOfsqEDcqJgZs91ejoIDZuxF/AXkffQ7zNsoEEYrjUAGGcEkzo/G
	 MjzNMBOAjahJOmk66T6nmfQXGL+c2zyhkriJXfWU=
Date: Mon, 15 Jul 2024 16:48:15 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,stable@vger.kernel.org,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-ineffective-protection-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20240715234815.E7ED8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix ineffective protection calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-fix-ineffective-protection-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-ineffective-protection-calculation.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: fix ineffective protection calculation
Date: Fri, 12 Jul 2024 17:29:56 -0600

mem_cgroup_calculate_protection() is not stateless and should only be used
as part of a top-down tree traversal.  shrink_one() traverses the per-node
memcg LRU instead of the root_mem_cgroup tree, and therefore it should not
call mem_cgroup_calculate_protection().

The existing misuse in shrink_one() can cause ineffective protection of
sub-trees that are grandchildren of root_mem_cgroup.  Fix it by reusing
lru_gen_age_node(), which already traverses the root_mem_cgroup tree, to
calculate the protection.

Previously lru_gen_age_node() opportunistically skips the first pass,
i.e., when scan_control->priority is DEF_PRIORITY.  On the second pass,
lruvec_is_sizable() uses appropriate scan_control->priority, set by
set_initial_priority() from lru_gen_shrink_node(), to decide whether a
memcg is too small to reclaim from.

Now lru_gen_age_node() unconditionally traverses the root_mem_cgroup tree.
So it should call set_initial_priority() upfront, to make sure
lruvec_is_sizable() uses appropriate scan_control->priority on the first
pass.  Otherwise, lruvec_is_reclaimable() can return false negatives and
result in premature OOM kills when min_ttl_ms is used.

Link: https://lkml.kernel.org/r/20240712232956.1427127-1-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: T.J. Mercier <tjmercier@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/mm/vmscan.c~mm-mglru-fix-ineffective-protection-calculation
+++ a/mm/vmscan.c
@@ -3933,19 +3933,17 @@ static bool lruvec_is_reclaimable(struct
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	/* see the comment on lru_gen_folio */
-	gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
-	birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
-
-	if (time_is_after_jiffies(birth + min_ttl))
+	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
 	if (!lruvec_is_sizable(lruvec, sc))
 		return false;
 
-	mem_cgroup_calculate_protection(NULL, memcg);
+	/* see the comment on lru_gen_folio */
+	gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
+	birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
-	return !mem_cgroup_below_min(NULL, memcg);
+	return time_is_before_jiffies(birth + min_ttl);
 }
 
 /* to protect the working set of the last N jiffies */
@@ -3955,23 +3953,20 @@ static void lru_gen_age_node(struct pgli
 {
 	struct mem_cgroup *memcg;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
+	bool reclaimable = !min_ttl;
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
-	/* check the order to exclude compaction-induced reclaim */
-	if (!min_ttl || sc->order || sc->priority == DEF_PRIORITY)
-		return;
+	set_initial_priority(pgdat, sc);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		if (lruvec_is_reclaimable(lruvec, sc, min_ttl)) {
-			mem_cgroup_iter_break(NULL, memcg);
-			return;
-		}
+		mem_cgroup_calculate_protection(NULL, memcg);
 
-		cond_resched();
+		if (!reclaimable)
+			reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
 	/*
@@ -3979,7 +3974,7 @@ static void lru_gen_age_node(struct pgli
 	 * younger than min_ttl. However, another possibility is all memcgs are
 	 * either too small or below min.
 	 */
-	if (mutex_trylock(&oom_lock)) {
+	if (!reclaimable && mutex_trylock(&oom_lock)) {
 		struct oom_control oc = {
 			.gfp_mask = sc->gfp_mask,
 		};
@@ -4772,8 +4767,7 @@ static int shrink_one(struct lruvec *lru
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	mem_cgroup_calculate_protection(NULL, memcg);
-
+	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-fix-ineffective-protection-calculation.patch

