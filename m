Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42322905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126208; cv=none; b=uH0YBevpLUA/yZ92tUwXPbXEImwNKljrV2+847oUwobPAPLHQC6KahvwtElQxEtBCaUjlbuZ/nqcFeLfGuRVxaQJbT9QNrZtrrAEszsDVNzNbaLr9279si6/q7V740j8SGivDwfOemSNAIcILrNOQYCMnQU3RqpUumx7F4MMLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126208; c=relaxed/simple;
	bh=oG5E5/fK/QpwWPg73zBcqGpkVrjBXiuWR2j1hsGVxq0=;
	h=Date:To:From:Subject:Message-Id; b=cUq2ChpMhdu/oNzvA/oGlCeaoLjTs4yYwaZDEeTSYI6IP0T8XvV/+of/AIVK904SaBIHilDMBfYWwiJR6TXfPqwGhxX1wlqk0BCwZKHAVQbJoM2TFOFAbASFEbpBUO28wIvVliBFMsUl07rIwkGdRSYWarOww4gZATRAwI6YJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVJnc6d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVJnc6d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A904DC4CEE3;
	Thu, 10 Jul 2025 05:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126208;
	bh=oG5E5/fK/QpwWPg73zBcqGpkVrjBXiuWR2j1hsGVxq0=;
	h=Date:To:From:Subject:From;
	b=aVJnc6d5dirLGdAiJwImxzXDgiDWUcVY4oePx5BkzsEnYpudvcnboCz0J2TMtFOq4
	 fjVOHIg1kXWh4/dM0U7LpMkc44p7nRiNZ+bviGkXHdTyesKxi/9oltGEp4MV1KWvAC
	 UDNL7pz+x6iOvbWcK0JKST/YmkitqCjmshoRI8Sk=
Date: Wed, 09 Jul 2025 22:43:28 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch removed from -mm tree
Message-Id: <20250710054328.A904DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: calculate and expose estimated memory bandwidth
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: calculate and expose estimated memory bandwidth
Date: Wed, 4 Jun 2025 11:31:25 -0700

The raw form of DAMON's monitoring results captures many details of the
information.  However, not every bit of the information is always required
for understanding practical access patterns.  Especially on real world
production systems of high scale time and size, the raw form is difficult
to be aggregated and compared.

Convert the raw monitoring results into a single number metric, namely
estimated memory bandwidth and expose it to users as a read-only
DAMON_STAT parameter.  The metric represents access intensiveness
(hotness) of the system.  It can easily be aggregated and compared for
high level understanding of the access pattern on large systems.

Link: https://lkml.kernel.org/r/20250604183127.13968-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth
+++ a/mm/damon/stat.c
@@ -29,8 +29,42 @@ static bool enabled __read_mostly = IS_E
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
+static unsigned long estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ulong, 0400);
+MODULE_PARM_DESC(estimated_memory_bandwidth,
+		"Estimated memory bandwidth usage in bytes per second");
+
 static struct damon_ctx *damon_stat_context;
 
+static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long access_bytes = 0;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t)
+			access_bytes += (r->ar.end - r->ar.start) *
+				r->nr_accesses;
+	}
+	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
+		MSEC_PER_SEC / c->attrs.aggr_interval;
+}
+
+static int damon_stat_after_aggregation(struct damon_ctx *c)
+{
+	static unsigned long last_refresh_jiffies;
+
+	/* avoid unnecessarily frequent stat update */
+	if (time_before_eq(jiffies, last_refresh_jiffies +
+				msecs_to_jiffies(5 * MSEC_PER_SEC)))
+		return 0;
+	last_refresh_jiffies = jiffies;
+
+	damon_stat_set_estimated_memory_bandwidth(c);
+	return 0;
+}
+
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -76,6 +110,7 @@ static struct damon_ctx *damon_stat_buil
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
 		goto free_out;
+	ctx->callback.after_aggregation = damon_stat_after_aggregation;
 	return ctx;
 free_out:
 	damon_destroy_ctx(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

