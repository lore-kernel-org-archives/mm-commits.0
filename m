Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DF33ABD8D;
	Wed,  5 Aug 2026 03:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898993; cv=none; b=hN4f0q7DXOrwGtqIJqyIoaqnOyUwth+TcUwG3TbcjWa70U9PCeUlnTIv04UNpW2kS+oRlABLabDMet3akkmyLjQAi2ReF3ibvvxgx/HDMMVOvbvJhDAJCYnuA6lAzFmqZ/fRSoGMrHvt2alL0MFhiGMxfHnuE6cLp1ip5u7vGZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898993; c=relaxed/simple;
	bh=PVCIK5jdFdPpXgeBEbb2hlSZsV+l3DEzvZ89ioCH6No=;
	h=Date:To:From:Subject:Message-Id; b=s1jK40kYtuk0KX52RDJBBEmqKSLzmP0sL2nZdP8cucCD8+r43R9pCmdMCci9dzu80mFnkfA30NawZjczHXY7f9Ze3VeFg8r+So2GvRL5KB89uZY3WBCzuEpxmfRlIHHtu2gIWvlyz7hxe9J/YRNNB+/Nq/XaUrcJhnNLK8o+cNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmaxS42m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmaxS42m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D82C1F00A3A;
	Wed,  5 Aug 2026 03:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898991;
	bh=n4mcIles1SnBg5E45m7BjHu/WIT3+3PZ8PD8samKtqo=;
	h=Date:To:From:Subject;
	b=xmaxS42mCUKyR/+e3aqYlu1WimcBQk4cj5uvlt7oqv7upJfM8HIjjiU2JmuwFaJuR
	 Q9qj6ZqBg/lZvl4VeOP+fTFbFYE2yJJS0d5jYlL86AuxAos6KgUxCH/PuZr0vKJC7w
	 oP4Vumf9uDDwkT6ZBW5Z9zUv5L1nvHIA/ytVj6fE=
Date: Tue, 04 Aug 2026 20:03:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch removed from -mm tree
Message-Id: <20260805030311.6D82C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
has been removed from the -mm tree.  Its filename was
     mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
Date: Tue, 28 Jul 2026 07:04:03 -0700

Callers of migrate_pages() should adjust NR_MIGRATED_{ANON,FILE} for
isolations and putback of the folios.  That for migration succeeded folios
is done by migrate_pages(), in migrate_folio_done().  That for MR_DEMOTION
reason is an exception though.

DAMOS_MIGRATE_{HOT,COLD} call migrate_pages() but mistakenly not doing the
stat adjustment.  As a result, use of DAMOS_MIGRATE_{HOT,COLD} could
corrupt the stat.  It could confuse too_many_isolated(), make compaction
and reclaim to behave in unexpected ways.  The stat corruption can be
reproduced and confirmed using DAMON user-space tool [1] on NUMA systems,
like below.

    $ numactl --hardware
    available: 2 nodes (0-1)
    [...]
    $ sudo ./damo start --damos_action migrate_hot 1
    $ sudo cat /proc/sys/vm/stat_refresh
    $ sudo dmesg
    [...]
    [   80.215554] vmstat_refresh: nr_isolated_anon -5578
    [   80.216842] vmstat_refresh: nr_isolated_file -34400

This issue was discovered [2] by Sashiko.

Link: https://lore.kernel.org/20260728140404.94476-1-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Link: https://lore.kernel.org/20260726164356.87940-1-sj@kernel.org [2]
Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    4 ++++
 mm/damon/paddr.c      |    2 ++
 mm/damon/vaddr.c      |    3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold
+++ a/mm/damon/ops-common.c
@@ -375,6 +375,8 @@ keep:
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		folio_putback_lru(folio);
 	}
 
@@ -397,6 +399,8 @@ unsigned long damon_migrate_pages(struct
 			struct folio *folio = lru_to_folio(folio_list);
 
 			list_del(&folio->lru);
+			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio));
 			folio_putback_lru(folio);
 		}
 		return nr_migrated;
--- a/mm/damon/paddr.c~mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold
+++ a/mm/damon/paddr.c
@@ -350,6 +350,8 @@ static unsigned long damon_pa_migrate(st
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
 		addr += folio_size(folio);
--- a/mm/damon/vaddr.c~mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold
+++ a/mm/damon/vaddr.c
@@ -649,7 +649,8 @@ static void damos_va_migrate_dests_add(s
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
-
+	node_stat_add_folio(folio, NR_ISOLATED_ANON +
+			folio_is_file_lru(folio));
 	list_add(&folio->lru, &migration_lists[i]);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

