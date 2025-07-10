Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D58B2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126206; cv=none; b=BPriwH0Hq3OgkIXF0QnKW87SucIxEj0m9JMg0QinVmtyPr9CHyIWw5NLJtEBxEaIBW9v7QxdmnMo6DHpYHNuS5YJ3vLjM7VaVkRgpi1F6AhSDVY6366rlByJKzpoTkElzLgqDtcXivKGUJ5u2Vm6lJYesftdFUmfpzEBYmOdUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126206; c=relaxed/simple;
	bh=4uvF1x3vAdIqz/xjbJL6g4WhIpS/jA1Abi/nb2AtbDw=;
	h=Date:To:From:Subject:Message-Id; b=SibxmeM2xZW7O5Ybji9+giouKbsyYfj+Y1XD5YMP5LYnRodqUTBWQIiMeuhO9f2VliFAPrXt4mg0D+FwtFBBnYpzD3LN18DCAMzGtnw/07n0hntZvL4o9+DKC4rQMK+CCoNYFct8Y2lSeM5R5EWFAu/BT2GnG/pTjNkAV4Y34hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKYQfkSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKYQfkSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01451C4CEE3;
	Thu, 10 Jul 2025 05:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126206;
	bh=4uvF1x3vAdIqz/xjbJL6g4WhIpS/jA1Abi/nb2AtbDw=;
	h=Date:To:From:Subject:From;
	b=RKYQfkShZEItEhhT8WGYzbPT3KY8w1nBQh/U7YzbSmTenAovQD3JAkVWVJLacSGM1
	 /LK3/eBZxn4XLL8Czq4ZEuI6DVjKfjM1WpjOvXT+cfDwmoUHoa2AJKx1bTw+xsafYy
	 AcWrPRDRzwh1K6DuYOSghTobnA1+ltvIYN3ly2jo=
Date: Wed, 09 Jul 2025 22:43:25 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-introduce-damon_stat-module.patch removed from -mm tree
Message-Id: <20250710054326.01451C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: introduce DAMON_STAT module
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon_stat-module.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: introduce DAMON_STAT module
Date: Wed, 4 Jun 2025 11:31:24 -0700

Patch series "mm/damon: introduce DAMON_STAT for simple and practical
access monitoring", v2.

DAMON-based access monitoring is not simple due to required DAMON control
and results visualizations.  Introduce a static kernel module for making
it simple.  The module can be enabled without manual setup and provides
access pattern metrics that easy to fetch and understand the practical
access pattern information, namely estimated memory bandwidth and memory
idle time percentiles.

Background and Problems
=======================

DAMON can be used for monitoring data access patterns of the system and
workloads.  Specifically, users can start DAMON to monitor access events
on specific address space with fine controls including address ranges to
monitor and time intervals between samplings and aggregations.  The
resulting access information snapshot contains access frequency
(nr_accesses) and how long the frequency was kept (age) for each byte.

The monitoring usage is not simple and practical enough for production
usage.  Users should first start DAMON with a number of parameters, and
wait until DAMON's monitoring results capture a reasonable amount of the
time data (age).  In production, such manual start and wait is impractical
to capture useful information from a high number of machines in a timely
manner.

The monitoring result is also too detailed to be used on production
environments.  The raw results are hard to be aggregated and/or compared
for production environments having a large scale of time, space and
machines fleet.

Users have to implement and use their own automation of DAMON control and
results processing.  It is repetitive and challenging since there is no
good reference or guideline for such automation.

Solution: DAMON_STAT
====================

Implement such automation in kernel space as a static kernel module,
namely DAMON_STAT.  It can be enabled at build, boot, or run time via its
build configuration or module parameter.  It monitors the entire physical
address space with monitoring intervals that auto-tuned for a reasonable
amount of access observations and minimum overhead.  It converts the raw
monitoring results into simpler metrics that can easily be aggregated and
compared, namely estimated memory bandwidth and idle time percentiles.

Understanding of the metrics and the user interface of DAMON_STAT is
essential.  Refer to the commit messages of the second and the third
patches of this patch series for more details about the metrics.  For the
user interface, the standard module parameters system is used.  Refer to
the fourth patch of this patch series for details of the user interface.

Discussions
===========

The module aims to be useful on production environments constructed with a
large number of machines that run a long time.  The auto-tuned monitoring
intervals ensure a reasonable quality of the outputs.  The auto-tuning
also ensures its overhead be reasonable and low enough to be enabled
always on the production.  The simplified monitoring results metrics can
be useful for showing both coldness (idle time percentiles) and hotness
(memory bandwidth) of the system's access pattern.  We expect the
information can be useful for assessing system memory utilization and
inspiring optimizations or investigations on both kernel and user space
memory management logics for large scale fleets.

We hence expect the module is good enough to be just used in most
environments.  For special cases that require a custom access monitoring
automation, users will still benefit by using DAMON_STAT as a reference or
a guideline for their specialized automation.


This patch (of 4):

To use DAMON for monitoring access patterns of the system, users should
manually start DAMON via DAMON sysfs ABI with a number of parameters for
specifying the monitoring target address space, address ranges, and
monitoring intervals.  After that, users should also wait until desired
amount of time data is captured into DAMON's monitoring results.  It is
bothersome and take a long time to be practical for access monitoring on
large fleet level production environments.

For access-aware system operations use cases like proactive cold memory
reclamation, similar problems existed.  We we solved those by introducing
dedicated static kernel modules such as DAMON_RECLAIM.

Implement such static kernel module for access monitoring, namely
DAMON_STAT.  It monitors the entire physical address space with auto-tuned
monitoring intervals.  The auto-tuning is set to capture 4 % of observable
access events in each snapshot while keeping the sampling intervals 5
milliseconds in minimum and 10 seconds in maximum.  From a few production
environments, we confirmed this setup provides high quality monitoring
results with minimum overheads.  The module therefore receives only one
user input, whether to enable or disable it.  It can be set on build or
boot time via build configuration or kernel boot command line.  It can
also be overridden at runtime.

Note that this commit only implements the DAMON control part of the
module.  Users could get the monitoring results via damon:damon_aggregated
tracepoint, but that's of course not the recommended way.  Following
commits will implement convenient and optimized ways for serving the
monitoring results to users.

[sj@kernel.org: use IS_ENABLED() for enabled initial value]
  Link: https://lkml.kernel.org/r/20250604205619.18929-1-sj@kernel.org
[sj@kernel.org: reset enabled when DAMON start failed]
  Link: https://lkml.kernel.org/r/20250706184750.36588-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250604183127.13968-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250604183127.13968-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig  |   16 ++++
 mm/damon/Makefile |    1 
 mm/damon/stat.c   |  146 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-introduce-damon_stat-module
+++ a/mm/damon/Kconfig
@@ -94,4 +94,20 @@ config DAMON_LRU_SORT
 	  protect frequently accessed (hot) pages while rarely accessed (cold)
 	  pages reclaimed first under memory pressure.
 
+config DAMON_STAT
+	bool "Build data access monitoring stat (DAMON_STAT)"
+	depends on DAMON_PADDR
+	help
+	  This builds the DAMON-based access monitoring statistics subsystem.
+	  It runs DAMON and expose access monitoring results in simple stat
+	  metrics.
+
+config DAMON_STAT_ENABLED_DEFAULT
+	bool "Enable DAMON_STAT by default"
+	depends on DAMON_PADDR
+	default DAMON_STAT
+	help
+	  Whether to enable DAMON_STAT by default.  Users can disable it in
+	  boot or runtime using its 'enabled' parameter.
+
 endmenu
--- a/mm/damon/Makefile~mm-damon-introduce-damon_stat-module
+++ a/mm/damon/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DAMON_PADDR)	+= ops-common.
 obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
+obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
diff --git a/mm/damon/stat.c a/mm/damon/stat.c
new file mode 100644
--- /dev/null
+++ a/mm/damon/stat.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Shows data access monitoring resutls in simple metrics.
+ */
+
+#define pr_fmt(fmt) "damon-stat: " fmt
+
+#include <linux/damon.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sort.h>
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_stat."
+
+static int damon_stat_enabled_store(
+		const char *val, const struct kernel_param *kp);
+
+static const struct kernel_param_ops enabled_param_ops = {
+	.set = damon_stat_enabled_store,
+	.get = param_get_bool,
+};
+
+static bool enabled __read_mostly = IS_ENABLED(
+	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
+
+static struct damon_ctx *damon_stat_context;
+
+static struct damon_ctx *damon_stat_build_ctx(void)
+{
+	struct damon_ctx *ctx;
+	struct damon_attrs attrs;
+	struct damon_target *target;
+	unsigned long start = 0, end = 0;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return NULL;
+	attrs = (struct damon_attrs) {
+		.sample_interval = 5 * USEC_PER_MSEC,
+		.aggr_interval = 100 * USEC_PER_MSEC,
+		.ops_update_interval = 60 * USEC_PER_MSEC * MSEC_PER_SEC,
+		.min_nr_regions = 10,
+		.max_nr_regions = 1000,
+	};
+	/*
+	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
+	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
+	 */
+	attrs.intervals_goal = (struct damon_intervals_goal) {
+		.access_bp = 400, .aggrs = 3,
+		.min_sample_us = 5000, .max_sample_us = 10000000,
+	};
+	if (damon_set_attrs(ctx, &attrs))
+		goto free_out;
+
+	/*
+	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
+	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
+	 */
+	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
+		.access_bp = 400, .aggrs = 3,
+		.min_sample_us = 5000, .max_sample_us = 10000000,
+	};
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+		goto free_out;
+
+	target = damon_new_target();
+	if (!target)
+		goto free_out;
+	damon_add_target(ctx, target);
+	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+		goto free_out;
+	return ctx;
+free_out:
+	damon_destroy_ctx(ctx);
+	return NULL;
+}
+
+static int damon_stat_start(void)
+{
+	damon_stat_context = damon_stat_build_ctx();
+	if (!damon_stat_context)
+		return -ENOMEM;
+	return damon_start(&damon_stat_context, 1, true);
+}
+
+static void damon_stat_stop(void)
+{
+	damon_stop(&damon_stat_context, 1);
+	damon_destroy_ctx(damon_stat_context);
+}
+
+static bool damon_stat_init_called;
+
+static int damon_stat_enabled_store(
+		const char *val, const struct kernel_param *kp)
+{
+	bool is_enabled = enabled;
+	int err;
+
+	err = kstrtobool(val, &enabled);
+	if (err)
+		return err;
+
+	if (is_enabled == enabled)
+		return 0;
+
+	if (!damon_stat_init_called)
+		/*
+		 * probably called from command line parsing (parse_args()).
+		 * Cannot call damon_new_ctx().  Let damon_stat_init() handle.
+		 */
+		return 0;
+
+	if (enabled) {
+		err = damon_stat_start();
+		if (err)
+			enabled = false;
+		return err;
+	}
+	damon_stat_stop();
+	return 0;
+}
+
+static int __init damon_stat_init(void)
+{
+	int err = 0;
+
+	damon_stat_init_called = true;
+
+	/* probably set via command line */
+	if (enabled)
+		err = damon_stat_start();
+
+	if (err && enabled)
+		enabled = false;
+	return err;
+}
+
+module_init(damon_stat_init);
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

