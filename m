Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3F3BFAC0
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896714; cv=none; b=QVvXQMsVZuZoMpcV7t8YuHWrByh1MOAxeVNiiHeQjHMhVS24ztoBlZWdIbuqBoCZYqQBqTwgn42FdWmvb37jJ3QNQ0v5BCIoZ39RsBBVv9LLyUyIOLw1TFrhDrxO3ufUGFilLAirDOK+H3nvm8phlEBAEoZpZctOljUMm5chS+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896714; c=relaxed/simple;
	bh=CD2u0K56DQ7QY51svJgHv4WB5O5GMVaO1x0AjDUrTwQ=;
	h=Date:To:From:Subject:Message-Id; b=o4C1kOa8U8yD+yIwn8ozVpTdMOCG8NSSj6Hwgf4NB3DBxPbGS4/WPVY59TD/xGn3ep3uaLHBI2F0yjHn749t8zoaRxNp8G7F779c0/KDaj83MvEfCMuv5W/GefGTNIrkRFcw0cSo6AIn8/M4jpRhSrcNsjSSomltAqJvlkxMAhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqzU0Lt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqzU0Lt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CB91F000E9;
	Wed,  5 Aug 2026 02:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896713;
	bh=Ynh6vBrLBu7R1MVXhUu1Ai94Dff4X9hexBYalIqzqQs=;
	h=Date:To:From:Subject;
	b=jqzU0Lt3ss3cDgi4g2+mKy94VrwLC60dRn2C0HoNU0SWl8J203fQA7zesli6rpsRH
	 QC6uVzBUodLpZqi1RIGayz/bq+pfZRnYNCX2h5nonf+rB/PGGaTELd4hUvpI+AFCuL
	 icYKGb3MYMQ44a0cHJ7NAoE9UGYwpfXXPv7R/pEM=
Date: Tue, 04 Aug 2026 19:25:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch removed from -mm tree
Message-Id: <20260805022513.12CB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: disallow probe_hits overflow on attrs only monitoring
has been removed from the -mm tree.  Its filename was
     mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: disallow probe_hits overflow on attrs only monitoring
Date: Fri, 10 Jul 2026 06:46:38 -0700

When any damon_probe->weight is set, DAMON will do only probe monitoring. 
probe_hits is 'unsigned char'.  It could overflow when the aggregation
interval is larger than the sampling interval times 256. 
damon_as_probe_weights() always return false, so such overflow cannot
happen.  Even if it happens, it only degrades the monitoring results.

That said, the overflow is not intentional.  It is better to be prevented
as long as the cost is not expensive.  Disallow the overflow by adding a
validation logic on the core layer parameters validation function.

Link: https://lore.kernel.org/20260710134651.18084-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring
+++ a/mm/damon/core.c
@@ -1332,6 +1332,19 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+static bool damon_valid_probe_params(struct damon_ctx *ctx)
+{
+	unsigned long sample_interval;
+
+	if (!damon_has_probe_weights(ctx))
+		return true;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
+		return false;
+	return true;
+}
+
 /*
  * damos_commit_dests() - Copy migration destinations from @src to @dst.
  * @dst:	Destination structure to update.
@@ -1736,6 +1749,9 @@ static int __damon_commit_ctx(struct dam
 		}
 	}
 
+	if (!damon_valid_probe_params(src))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
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

