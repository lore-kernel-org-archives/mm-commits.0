Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F909FBF6;
	Thu,  4 Jul 2024 05:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720071731; cv=none; b=Y0d0knAhIhzgr7if7Ck7fJMPVEEbfeI/HTGX/9VCFK04OLHDXtacF5nyWy7Ibc9CNowGmedM4YS4bvBRpAdLHMfOXUz58c6XLiSs9ZvuV2uXXjGQoPqc753bOPKmsDlX7zdnLkq8e3KPrWSajaystfF1ELsGD0TCle4/EaPcg4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720071731; c=relaxed/simple;
	bh=yCVkiqBIvvD7x3aR3gPvzqz05WW34JMZ4aMO5kr8Lg8=;
	h=Date:To:From:Subject:Message-Id; b=Z9IUBDMT4BvrlJykG6P80d3v04lGLOJQGNhQj7EhKTFpHUrE2+xJsS0X9hMo4kbXhdKVbmFSWsIIakkzKYBp5eA5+kW51oNLhZQ2fU1lRsVRUN5fE4wQM+VSk0hZupPGd32kq+yvgZgCcP36mbY/fG57lwhaJCo56Fpc7fh7Vwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0gy+DB28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0gy+DB28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31922C3277B;
	Thu,  4 Jul 2024 05:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720071731;
	bh=yCVkiqBIvvD7x3aR3gPvzqz05WW34JMZ4aMO5kr8Lg8=;
	h=Date:To:From:Subject:From;
	b=0gy+DB28c5rWCo58cBB/dHG8Xr4wlFA6hzxV2oQ4tthuv8IIfKWxT4SYAiAv0lrEA
	 vLP1iZB8YW4iHg4kmMv6cLgl+fckDRUw7vWzHk0+Laky2rCgPgFNLjhfXXafUxqMAK
	 d81D827aLWIo2wgZCVcepGfzgrYc1GYaEJ1s5qIo=
Date: Wed, 03 Jul 2024 22:42:10 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,kasong@tencent.com,hannes@cmpxchg.org,david@redhat.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] cachestat-do-not-flush-stats-in-recency-check.patch removed from -mm tree
Message-Id: <20240704054211.31922C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cachestat: do not flush stats in recency check
has been removed from the -mm tree.  Its filename was
     cachestat-do-not-flush-stats-in-recency-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: cachestat: do not flush stats in recency check
Date: Thu, 27 Jun 2024 13:17:37 -0700

syzbot detects that cachestat() is flushing stats, which can sleep, in its
RCU read section (see [1]).  This is done in the workingset_test_recent()
step (which checks if the folio's eviction is recent).

Move the stat flushing step to before the RCU read section of cachestat,
and skip stat flushing during the recency check.

[1]: https://lore.kernel.org/cgroups/000000000000f71227061bdf97e0@google.com/

Link: https://lkml.kernel.org/r/20240627201737.3506959-1-nphamcs@gmail.com
Fixes: b00684722262 ("mm: workingset: move the stats flush into workingset_test_recent()")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reported-by: syzbot+b7f13b2d0cc156edf61a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/cgroups/000000000000f71227061bdf97e0@google.com/
Debugged-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>	[6.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ++-
 mm/filemap.c         |    5 ++++-
 mm/workingset.c      |   14 +++++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~cachestat-do-not-flush-stats-in-recency-check
+++ a/include/linux/swap.h
@@ -354,7 +354,8 @@ static inline swp_entry_t page_swap_entr
 }
 
 /* linux/mm/workingset.c */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset);
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+				bool flush);
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
 void workingset_refault(struct folio *folio, void *shadow);
--- a/mm/filemap.c~cachestat-do-not-flush-stats-in-recency-check
+++ a/mm/filemap.c
@@ -4248,6 +4248,9 @@ static void filemap_cachestat(struct add
 	XA_STATE(xas, &mapping->i_pages, first_index);
 	struct folio *folio;
 
+	/* Flush stats (and potentially sleep) outside the RCU read section. */
+	mem_cgroup_flush_stats_ratelimited(NULL);
+
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_index) {
 		int order;
@@ -4311,7 +4314,7 @@ static void filemap_cachestat(struct add
 					goto resched;
 			}
 #endif
-			if (workingset_test_recent(shadow, true, &workingset))
+			if (workingset_test_recent(shadow, true, &workingset, false))
 				cs->nr_recently_evicted += nr_pages;
 
 			goto resched;
--- a/mm/workingset.c~cachestat-do-not-flush-stats-in-recency-check
+++ a/mm/workingset.c
@@ -412,10 +412,12 @@ void *workingset_eviction(struct folio *
  * @file: whether the corresponding folio is from the file lru.
  * @workingset: where the workingset value unpacked from shadow should
  * be stored.
+ * @flush: whether to flush cgroup rstat.
  *
  * Return: true if the shadow is for a recently evicted folio; false otherwise.
  */
-bool workingset_test_recent(void *shadow, bool file, bool *workingset)
+bool workingset_test_recent(void *shadow, bool file, bool *workingset,
+				bool flush)
 {
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
@@ -467,10 +469,16 @@ bool workingset_test_recent(void *shadow
 
 	/*
 	 * Flush stats (and potentially sleep) outside the RCU read section.
+	 *
+	 * Note that workingset_test_recent() itself might be called in RCU read
+	 * section (for e.g, in cachestat) - these callers need to skip flushing
+	 * stats (via the flush argument).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	mem_cgroup_flush_stats_ratelimited(eviction_memcg);
+	if (flush)
+		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -558,7 +566,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	if (!workingset_test_recent(shadow, file, &workingset))
+	if (!workingset_test_recent(shadow, file, &workingset, true))
 		return;
 
 	folio_set_active(folio);
_

Patches currently in -mm which might be from nphamcs@gmail.com are


