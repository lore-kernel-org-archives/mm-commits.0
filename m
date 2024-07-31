Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C721BC40
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460359; cv=none; b=Q1T7ddtfZwCyAsc9FAvkVWBV4pc2xa3RC+YkUYTFon/XIJ6/fCP1M3kNIc0G6R+uBIQkrrwHz+eeWCHAdfA1oLYJ9KJa87V51KHd5mW8n8gEGH8r4RMxygXlTG+/xu+g5QrqLPGrta8uJcX5qS8JDWWTo5e/EpqeCrvYJ/hjLhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460359; c=relaxed/simple;
	bh=G2FWG5EMEjXQCFUR32h2GxoJxCPPuBZPZly1uIcSmM0=;
	h=Date:To:From:Subject:Message-Id; b=LIwiI4ay67qfTews+1yUHxu/+LSq5E7blhFFtE1kgrOY0UgDlqzaENnNvOWVmq3vukuc7K6lcnay7uvnIUGKJu0wY8euLUTx/1kYXZbpKIdBBlasi/HVZIs+goEPKWmhymbSAFWTZVU+DDzYnMoLchjM1aD8EFSyvW3oLzhMc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U/7wiKT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U/7wiKT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84271C116B1;
	Wed, 31 Jul 2024 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722460358;
	bh=G2FWG5EMEjXQCFUR32h2GxoJxCPPuBZPZly1uIcSmM0=;
	h=Date:To:From:Subject:From;
	b=U/7wiKT/iw3Q5g/iqCoVo9Z7/UK76a1k7I39ejm8dHjYhJVBmX4uaYsOPamitZWhY
	 nT+z5a161GHF1uk1J49a7mk/x0ylpo7dnobh/UB3cGt7dp0DUJUzG9MAQ9mXuUmDo7
	 P+R11+sRC0oiygGglw7x2BntyXuB27nvZ3IPLPLE=
Date: Wed, 31 Jul 2024 14:12:37 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,flintglass@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-global-shrinker-error-handling-logic.patch added to mm-unstable branch
Message-Id: <20240731211238.84271C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix global shrinker error handling logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-global-shrinker-error-handling-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-global-shrinker-error-handling-logic.patch

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
From: Takero Funaki <flintglass@gmail.com>
Subject: mm: zswap: fix global shrinker error handling logic
Date: Wed, 31 Jul 2024 00:49:10 +0000

This patch fixes the zswap global shrinker, which did not shrink the zpool
as expected.

The issue addressed is that shrink_worker() did not distinguish between
unexpected errors and expected errors, such as failed writeback from an
empty memcg.  The shrinker would stop shrinking after iterating through
the memcg tree 16 times, even if there was only one empty memcg.

With this patch, the shrinker no longer considers encountering an empty
memcg, encountering a memcg with writeback disabled, or reaching the end
of a memcg tree walk as a failure, as long as there are memcgs that are
candidates for writeback.  Systems with one or more empty memcgs will now
observe significantly higher zswap writeback activity after the zswap pool
limit is hit.

To avoid an infinite loop when there are no writeback candidates, this
patch tracks writeback attempts during memcg tree walks and limits reties
if no writeback candidates are found.

To handle the empty memcg case, the helper function shrink_memcg() is
modified to check if the memcg is empty and then return -ENOENT.

Link: https://lkml.kernel.org/r/20240731004918.33182-3-flintglass@gmail.com
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Takero Funaki <flintglass@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-error-handling-logic
+++ a/mm/zswap.c
@@ -1303,10 +1303,10 @@ static struct shrinker *zswap_alloc_shri
 
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
-	int nid, shrunk = 0;
+	int nid, shrunk = 0, scanned = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
-		return -EINVAL;
+		return -ENOENT;
 
 	/*
 	 * Skip zombies because their LRUs are reparented and we would be
@@ -1320,21 +1320,34 @@ static int shrink_memcg(struct mem_cgrou
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
+		scanned += 1 - nr_to_walk;
 	}
+
+	if (!scanned)
+		return -ENOENT;
+
 	return shrunk ? 0 : -EAGAIN;
 }
 
 static void shrink_worker(struct work_struct *w)
 {
 	struct mem_cgroup *memcg;
-	int ret, failures = 0;
+	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
 
 	/*
-	 * Global reclaim will select cgroup in a round-robin fashion.
+	 * Global reclaim will select cgroup in a round-robin fashion from all
+	 * online memcgs, but memcgs that have no pages in zswap and
+	 * writeback-disabled memcgs (memory.zswap.writeback=0) are not
+	 * candidates for shrinking.
+	 *
+	 * Shrinking will be aborted if we encounter the following
+	 * MAX_RECLAIM_RETRIES times:
+	 * - No writeback-candidate memcgs found in a memcg tree walk.
+	 * - Shrinking a writeback-candidate memcg failed.
 	 *
 	 * We save iteration cursor memcg into zswap_next_shrink,
 	 * which can be modified by the offline memcg cleaner
@@ -1372,9 +1385,14 @@ static void shrink_worker(struct work_st
 		spin_unlock(&zswap_shrink_lock);
 
 		if (!memcg) {
-			if (++failures == MAX_RECLAIM_RETRIES)
+			/*
+			 * Continue shrinking without incrementing failures if
+			 * we found candidate memcgs in the last tree walk.
+			 */
+			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
+			attempts = 0;
 			goto resched;
 		}
 
@@ -1382,8 +1400,16 @@ static void shrink_worker(struct work_st
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
-		if (ret == -EINVAL)
-			break;
+		/*
+		 * There are no writeback-candidate pages in the memcg.
+		 * This is not an issue as long as we can find another memcg
+		 * with pages in zswap. Skip this without incrementing attempts
+		 * and failures.
+		 */
+		if (ret == -ENOENT)
+			continue;
+		++attempts;
+
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
 			break;
 resched:
_

Patches currently in -mm which might be from flintglass@gmail.com are

mm-zswap-fix-global-shrinker-memcg-iteration.patch
mm-zswap-fix-global-shrinker-error-handling-logic.patch

