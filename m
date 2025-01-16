Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A86172BD5
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006280; cv=none; b=L7+Upj5Il1FWIqx4Wr7NY3s0a7WgFARyxGVlUt6ieZIhQt/90VqhvsF5D2X+xXf/Kl8ezyqmkbBj8ny/47SI8gk2XIHGWh7zX7SZLtB7p8s5sr3UFEnLF62Y787/whGawF0cAplVLUW6UqpyFHpM++wTxr1M+ioC1iKyrEMRKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006280; c=relaxed/simple;
	bh=ntYtxmwVZ+9cpj1WyRkuOb1bSR0qBsX4Gn+DHWTi/OQ=;
	h=Date:To:From:Subject:Message-Id; b=Riz4ASVKqks+zeOSNCV60xzoXMg+K722OEFMhycgfRK6fD3wTfY8KOsR05hPwjRlkdqb/HkoNLS9/YTAsGgHycTaj6XRIkYCpoUyJ8bikOw5d7URKgL6D1mPcQWxWTtkxcrAoxeul3wd2OMamMaMcRwh81ZUTD/pztbS8PDYPvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wo4W47EL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wo4W47EL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CA5C4CED6;
	Thu, 16 Jan 2025 05:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006280;
	bh=ntYtxmwVZ+9cpj1WyRkuOb1bSR0qBsX4Gn+DHWTi/OQ=;
	h=Date:To:From:Subject:From;
	b=Wo4W47ELFdrzNP740Vuh+riraqvvPOn57qgDWtxDmAKk7cdf0oY/eExbRbENJi9qb
	 S5qlGHRaKZu578PNhh9qOpqojAr/xXOZ5pAMNH7HXUN5ub4OXLLpOdCPrtJNZqwqPL
	 r1N8Me6szVHbg3CYSGUGr3Tk1AwqkMySFN9emGoI=
Date: Wed, 15 Jan 2025 21:44:39 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-rework-refault-detection.patch removed from -mm tree
Message-Id: <20250116054440.01CA5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: rework refault detection
has been removed from the -mm tree.  Its filename was
     mm-mglru-rework-refault-detection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: rework refault detection
Date: Mon, 30 Dec 2024 21:35:36 -0700

With anon and file min_seq being able to move independently, rework
workingset protection as well so that the comparison of refaults between
anon and file is always on an equal footing.

Specifically, make lru_gen_test_recent() return true for refaults
happening within the distance of MAX_NR_GENS.  For example, if min_seq of
a type is max_seq-MIN_NR_GENS, refaults from min_seq-1, i.e.,
max_seq-MIN_NR_GENS-1, are also considered recent, since the distance
max_seq-(max_seq-MIN_NR_GENS-1), i.e., MIN_NR_GENS+1 is less than
MAX_NR_GENS.

As an intermediate step to the final optimization, this change by itself
should not have userspace-visiable effects beyond performance.

Link: https://lkml.kernel.org/r/20241231043538.4075764-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Kairui Song <kasong@tencent.com>
Closes: https://lore.kernel.org/CAOUHufahuWcKf5f1Sg3emnqX+cODuR=2TQo7T4Gr-QYLujn4RA@mail.gmail.com/
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/workingset.c~mm-mglru-rework-refault-detection
+++ a/mm/workingset.c
@@ -260,11 +260,11 @@ static void *lru_gen_eviction(struct fol
  * Tests if the shadow entry is for a folio that was recently evicted.
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
-static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 				unsigned long *token, bool *workingset)
 {
 	int memcg_id;
-	unsigned long min_seq;
+	unsigned long max_seq;
 	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat;
 
@@ -273,8 +273,10 @@ static bool lru_gen_test_recent(void *sh
 	memcg = mem_cgroup_from_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-	min_seq = READ_ONCE((*lruvec)->lrugen.min_seq[file]);
-	return (*token >> LRU_REFS_WIDTH) == (min_seq & (EVICTION_MASK >> LRU_REFS_WIDTH));
+	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
+	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+
+	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
@@ -290,7 +292,7 @@ static void lru_gen_refault(struct folio
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, type, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +333,7 @@ static void *lru_gen_eviction(struct fol
 	return NULL;
 }
 
-static bool lru_gen_test_recent(void *shadow, bool file, struct lruvec **lruvec,
+static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 				unsigned long *token, bool *workingset)
 {
 	return false;
@@ -432,8 +434,7 @@ bool workingset_test_recent(void *shadow
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, file, &eviction_lruvec,
-					     &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
 		rcu_read_unlock();
 		return recent;
 	}
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

