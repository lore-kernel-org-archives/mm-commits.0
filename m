Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED6155382
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619849; cv=none; b=CNXDC9c9nYM3P8Y4waC2OS7JLo/G+BtdF2CbAp0QtapKAFIdIT8nqtNaU8hGi5///dKZmiQRxgcHr9OlrqrsoCwvFXjGtmHb2VaqyOVS7gVopiwVwZj6uU73abQGSnFR1N2GEbsEbSpOjBWrsUpEOcwS9mCkRSfDpuA+5/FdgcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619849; c=relaxed/simple;
	bh=PZPThKmWcEjrfwLcXvJuOw6kVBdVtgb/ZRx58uBkC08=;
	h=Date:To:From:Subject:Message-Id; b=QitWcb25ufwOcnYRmDLOdoPGjJ7kEzgpDhBbXyenx3pniCvKZgDQae23BLKyCQzpcIHqBgk2RpjX3cjxrI1uCefzfxw9x80G+QOZx7NL+QcihX1/eqrFhgGg6XSyrfSceLdPWySDOuVjNR+8mwADwhel+SSZXY/M1kV699haNkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ubVZrYPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ubVZrYPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EAC4CEDD;
	Sat, 22 Mar 2025 05:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619848;
	bh=PZPThKmWcEjrfwLcXvJuOw6kVBdVtgb/ZRx58uBkC08=;
	h=Date:To:From:Subject:From;
	b=ubVZrYPM8r0Tm6qODygCDbCvA8g9k3YpxBekbdJ7bzi4ivLtHsxOvR+3bKSU4PZQv
	 Jbg0oqfuAzt5taOmUbaolqj6z67Oo7w9z8z90WZgpDh+H4RzZuZ5fSiTMydUjWxBUb
	 d5ZBajTNR17W2rXV945K/tmOOfT1PJA7ko+erl1E=
Date: Fri, 21 Mar 2025 22:04:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch removed from -mm tree
Message-Id: <20250322050408.6B3EAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: implement a new DAMOS filter type for active pages
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/damon: implement a new DAMOS filter type for active pages
Date: Tue, 18 Mar 2025 11:30:28 -0700

Patch series "mm/damon: introduce DAMOS filter type for active pages".

The memory reclaim algorithm categorizes pages into active and inactive
lists, separately for file and anon pages.  The system's performance
relies heavily on the (relative and absolute) accuracy of this
categorization.

This patch series add a new DAMOS filter for pages' activeness, giving us
visibility into the access frequency of the pages on each list.  This
insight can help us diagnose issues with the active-inactive balancing
dynamics, and make decisions to optimize reclaim efficiency and memory
utilization.

For instance, we might decide to enable DAMON_LRU_SORT, if we find that
there are pages on the active list that are infrequently accessed, or less
frequently accessed than pages on the inactive list.


This patch (of 2):

Implement a DAMOS filter type for active pages on DAMON kernel API, and
add support of it from the physical address space DAMON operations set
(paddr).

Link: https://lkml.kernel.org/r/20250318183029.2062917-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20250318183029.2062917-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/paddr.c         |    3 +++
 mm/damon/sysfs-schemes.c |    1 +
 3 files changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/include/linux/damon.h
@@ -334,6 +334,7 @@ struct damos_stat {
 /**
  * enum damos_filter_type - Type of memory for &struct damos_filter
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMOS_FILTER_TYPE_ACTIVE:	Active pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
@@ -355,6 +356,7 @@ struct damos_stat {
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
+	DAMOS_FILTER_TYPE_ACTIVE,
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
--- a/mm/damon/paddr.c~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/mm/damon/paddr.c
@@ -217,6 +217,9 @@ static bool damos_pa_filter_match(struct
 	case DAMOS_FILTER_TYPE_ANON:
 		matched = folio_test_anon(folio);
 		break;
+	case DAMOS_FILTER_TYPE_ACTIVE:
+		matched = folio_test_active(folio);
+		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		rcu_read_lock();
 		memcg = folio_memcg_check(folio);
--- a/mm/damon/sysfs-schemes.c~mm-damon-implement-a-new-damos-filter-type-for-active-pages
+++ a/mm/damon/sysfs-schemes.c
@@ -344,6 +344,7 @@ static struct damon_sysfs_scheme_filter
 /* Should match with enum damos_filter_type */
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
+	"active",
 	"memcg",
 	"young",
 	"hugepage_size",
_

Patches currently in -mm which might be from nphamcs@gmail.com are


