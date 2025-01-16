Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBAB17ADF8
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006272; cv=none; b=qbelzImWjqjw7GKbS7COn2j58m0U2eRUVIFDSgGX7W2sU8bZIUS2Em/ZxP20XkE/ujLC57sHJW+cVUnT74CguK5SJrgTQMsiV+IPNky+v4aMjg9u72JmULHAUbi9jwGI7MTpHrgd1YxIDmrGca1ULkbVRw3NNWZu0gPf3ugIVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006272; c=relaxed/simple;
	bh=qaHFEeDI/04vE0BQ8aKGSk1fzMcrPOZ8da0X2okCptc=;
	h=Date:To:From:Subject:Message-Id; b=YV+hYM68/KixUYqDi1h6of2q5nZzxC+uQ2NDcsw7GpXliWvcXgkyurKZOJ5eJCAkXLEBBbKXQXBEnbNiWkshIe18DRSSQ0H4S/wQN9eGdR/p12Cw9eYmerPIKdpX0vqhi5osexzaf9cddVTCws8TmOGKLJFs5WISwJCIDk7aoRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOn1rJol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOn1rJol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6136BC4CED6;
	Thu, 16 Jan 2025 05:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006272;
	bh=qaHFEeDI/04vE0BQ8aKGSk1fzMcrPOZ8da0X2okCptc=;
	h=Date:To:From:Subject:From;
	b=UOn1rJolfat/xBERgVInohwU0J4R6So4sgorfvWtKwlgbf/rcEJ0WvMq6Azz4UOLt
	 4tDHtf1qtgsYO9yHvbeDugPi8m+Nrgsog7L/KOb+U2t/P7Jae2qBtDCTNf1l77sBLM
	 7mWb32CePgif2WFZdhelUSEZgpHTFveKbb1+Q7+4=
Date: Wed, 15 Jan 2025 21:44:31 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-clean-up-workingset.patch removed from -mm tree
Message-Id: <20250116054432.6136BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: clean up workingset
has been removed from the -mm tree.  Its filename was
     mm-mglru-clean-up-workingset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: clean up workingset
Date: Mon, 30 Dec 2024 21:35:32 -0700

Patch series "mm/mglru: performance optimizations", v4.

This series improves performance for some previously reported test cases. 
Most of the code changes gathered here has been floating on the mailing
list [1][2].  They are now properly organized and have gone through
various benchmarks on client and server devices, including Android, FIO,
memcached, multiple VMs and MongoDB.

In addition to the syzbot regressions fixed in v2 [3] and v3 [4], this
version fixes two more regressions: one reported by Oliver Sang [5] and
the other by Barry Song.

[1] https://lore.kernel.org/CAOUHufahuWcKf5f1Sg3emnqX+cODuR=2TQo7T4Gr-QYLujn4RA@mail.gmail.com/
[2] https://lore.kernel.org/CAOUHufawNerxqLm7L9Yywp3HJFiYVrYO26ePUb1jH-qxNGWzyA@mail.gmail.com/
[3] https://lore.kernel.org/67294349.050a0220.701a.0010.GAE@google.com/
[4] https://lore.kernel.org/67549eca.050a0220.2477f.001b.GAE@google.com/
[5] https://lore.kernel.org/202412231601.f1eb8f84-lkp@intel.com/


This patch (of 7):

Move VM_BUG_ON_FOLIO() to cover both the default and MGLRU paths.  Also
use a pair of rcu_read_lock() and rcu_read_unlock() within each path, to
improve readability.

This change should not have any side effects.

Link: https://lkml.kernel.org/r/20241231043538.4075764-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20241231043538.4075764-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/workingset.c~mm-mglru-clean-up-workingset
+++ a/mm/workingset.c
@@ -428,17 +428,17 @@ bool workingset_test_recent(void *shadow
 	struct pglist_data *pgdat;
 	unsigned long eviction;
 
-	rcu_read_lock();
-
 	if (lru_gen_enabled()) {
-		bool recent = lru_gen_test_recent(shadow, file,
-				&eviction_lruvec, &eviction, workingset);
+		bool recent;
 
+		rcu_read_lock();
+		recent = lru_gen_test_recent(shadow, file, &eviction_lruvec,
+					     &eviction, workingset);
 		rcu_read_unlock();
 		return recent;
 	}
 
-
+	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
 
@@ -459,14 +459,12 @@ bool workingset_test_recent(void *shadow
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_id(memcgid);
-	if (!mem_cgroup_disabled() &&
-	    (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))) {
-		rcu_read_unlock();
-		return false;
-	}
-
+	if (!mem_cgroup_tryget(eviction_memcg))
+		eviction_memcg = NULL;
 	rcu_read_unlock();
 
+	if (!mem_cgroup_disabled() && !eviction_memcg)
+		return false;
 	/*
 	 * Flush stats (and potentially sleep) outside the RCU read section.
 	 *
@@ -544,6 +542,8 @@ void workingset_refault(struct folio *fo
 	bool workingset;
 	long nr;
 
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	if (lru_gen_enabled()) {
 		lru_gen_refault(folio, shadow);
 		return;
@@ -558,7 +558,6 @@ void workingset_refault(struct folio *fo
 	 * is actually experiencing the refault event. Make sure the folio is
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
 	pgdat = folio_pgdat(folio);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

