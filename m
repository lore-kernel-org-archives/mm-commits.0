Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD786101E6
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180744; cv=none; b=MmFTsBoGeAMZxPBrptlo2Fmu5h2EyNyN8ukkdF1INzYWxoess4Su8ozlNf7tXkalZFhHdFKhn3V/P2QfswKbKcbpVnFxy1MHGaWeF3MCX2t2FY4BkIw0+wStuliXlpLKCdK3K1kFuzBYM013qex7Qzpj7P30jooqv4zJoQIBwGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180744; c=relaxed/simple;
	bh=QTaCaL8JP6plBZgTpfPAhM3vaeZmjurdPr9y9BQKbYs=;
	h=Date:To:From:Subject:Message-Id; b=YijWJqRIYYPB4BhqKio0QypRrbj4XRcAjtqzaqfhVW4wvBtaVBqXJyCsaBxo6Q6lHnJu/HXX5K5g9xzdaoDhCRIirjtheMUwUIa04smZ2lw8nb5Rew8ybD/nJS7SFwwO8X/0UQxOe8VGUqJeIRKPlEJLEqh1wlUGmXT6SdDEZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bVAQgo94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bVAQgo94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C61C4CEE2;
	Sun, 20 Apr 2025 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180742;
	bh=QTaCaL8JP6plBZgTpfPAhM3vaeZmjurdPr9y9BQKbYs=;
	h=Date:To:From:Subject:From;
	b=bVAQgo94LpXAp9Uel3kxJhiWAQEAR+i9y3QIqF1t4w3+BnK3muS13d1vEeotv9okX
	 zLoZo61M4Tsk6qvh4kKFMtrfQatWpKbgKpE4qO3UpkQxMYmuw6BNqKA7t7KAgApMzY
	 OLdR/AosXqh5MYAnpC3EB0TgjvVL8IxXDqdiEfLg=
Date: Sun, 20 Apr 2025 13:25:41 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-implement-a-damon-module-for-memory-tiering.patch added to mm-unstable branch
Message-Id: <20250420202542.40C61C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: implement a DAMON module for memory tiering
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-implement-a-damon-module-for-memory-tiering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-implement-a-damon-module-for-memory-tiering.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon: implement a DAMON module for memory tiering
Date: Sun, 20 Apr 2025 12:40:30 -0700

Implement a sample DAMON module that shows how self-tuned DAMON-based
memory tiering can be written.  It is a sample since the purpose is to
give an idea about how it can be implemented and perform, rather than be
used on general production setups.  Especially, it supports only two tiers
memory setup having only one CPU-attached NUMA node.

Link: https://lkml.kernel.org/r/20250420194030.75838-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/Kconfig  |   13 +++
 samples/damon/Makefile |    1 
 samples/damon/mtier.c  |  167 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)

--- a/samples/damon/Kconfig~samples-damon-implement-a-damon-module-for-memory-tiering
+++ a/samples/damon/Kconfig
@@ -27,4 +27,17 @@ config SAMPLE_DAMON_PRCL
 
 	  If unsure, say N.
 
+config SAMPLE_DAMON_MTIER
+	bool "DAMON sample module for memory tiering"
+	depends on DAMON && DAMON_PADDR
+	help
+	  Thps builds DAMON sample module for memory tierign.
+
+	  The module assumes the system is constructed with two NUMA nodes,
+	  which seems as local and remote nodes to all CPUs.  For example,
+	  node0 is for DDR5 DRAMs connected via DIMM, while node1 is for DDR4
+	  DRAMs connected via CXL.
+
+	  If unsure, say N.
+
 endmenu
--- a/samples/damon/Makefile~samples-damon-implement-a-damon-module-for-memory-tiering
+++ a/samples/damon/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
 obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
+obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
diff --git a/samples/damon/mtier.c a/samples/damon/mtier.c
new file mode 100644
--- /dev/null
+++ a/samples/damon/mtier.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * memory tiering: migrate cold pages in node 0 and hot pages in node 1 to node
+ * 1 and node 0, respectively.  Adjust the hotness/coldness threshold aiming
+ * resulting 99.6 % node 0 utilization ratio.
+ */
+
+#define pr_fmt(fmt) "damon_sample_mtier: " fmt
+
+#include <linux/damon.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static unsigned long node0_start_addr __read_mostly;
+module_param(node0_start_addr, ulong, 0600);
+
+static unsigned long node0_end_addr __read_mostly;
+module_param(node0_end_addr, ulong, 0600);
+
+static unsigned long node1_start_addr __read_mostly;
+module_param(node1_start_addr, ulong, 0600);
+
+static unsigned long node1_end_addr __read_mostly;
+module_param(node1_end_addr, ulong, 0600);
+
+static int damon_sample_mtier_enable_store(
+		const char *val, const struct kernel_param *kp);
+
+static const struct kernel_param_ops enable_param_ops = {
+	.set = damon_sample_mtier_enable_store,
+	.get = param_get_bool,
+};
+
+static bool enable __read_mostly;
+module_param_cb(enable, &enable_param_ops, &enable, 0600);
+MODULE_PARM_DESC(enable, "Enable of disable DAMON_SAMPLE_MTIER");
+
+static struct damon_ctx *ctxs[2];
+
+static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *target;
+	struct damon_region *region;
+	struct damos *scheme;
+	struct damos_quota_goal *quota_goal;
+	struct damos_filter *filter;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return NULL;
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
+	region = damon_new_region(
+			promote ? node1_start_addr : node0_start_addr,
+			promote ? node1_end_addr : node0_end_addr);
+	if (!region)
+		goto free_out;
+	damon_add_region(region, target);
+
+	scheme = damon_new_scheme(
+			/* access pattern */
+			&(struct damos_access_pattern) {
+				.min_sz_region = PAGE_SIZE,
+				.max_sz_region = ULONG_MAX,
+				.min_nr_accesses = promote ? 1 : 0,
+				.max_nr_accesses = promote ? UINT_MAX : 0,
+				.min_age_region = 0,
+				.max_age_region = UINT_MAX},
+			/* action */
+			promote ? DAMOS_MIGRATE_HOT : DAMOS_MIGRATE_COLD,
+			1000000,	/* apply interval (1s) */
+			&(struct damos_quota){
+				/* 200 MiB per sec by most */
+				.reset_interval = 1000,
+				.sz = 200 * 1024 * 1024,
+				/* ignore size of region when prioritizing */
+				.weight_sz = 0,
+				.weight_nr_accesses = 100,
+				.weight_age = 100,
+			},
+			&(struct damos_watermarks){},
+			promote ? 0 : 1);	/* migrate target node id */
+	if (!scheme)
+		goto free_out;
+	damon_set_schemes(ctx, &scheme, 1);
+	quota_goal = damos_new_quota_goal(
+			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
+			DAMOS_QUOTA_NODE_MEM_FREE_BP,
+			promote ? 9970 : 50);
+	if (!quota_goal)
+		goto free_out;
+	quota_goal->nid = 0;
+	damos_add_quota_goal(&scheme->quota, quota_goal);
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, promote);
+	if (!filter)
+		goto free_out;
+	damos_add_filter(scheme, filter);
+	return ctx;
+free_out:
+	damon_destroy_ctx(ctx);
+	return NULL;
+}
+
+static int damon_sample_mtier_start(void)
+{
+	struct damon_ctx *ctx;
+
+	ctx = damon_sample_mtier_build_ctx(true);
+	if (!ctx)
+		return -ENOMEM;
+	ctxs[0] = ctx;
+	ctx = damon_sample_mtier_build_ctx(false);
+	if (!ctx) {
+		damon_destroy_ctx(ctxs[0]);
+		return -ENOMEM;
+	}
+	ctxs[1] = ctx;
+	return damon_start(ctxs, 2, true);
+}
+
+static void damon_sample_mtier_stop(void)
+{
+	damon_stop(ctxs, 2);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+}
+
+static int damon_sample_mtier_enable_store(
+		const char *val, const struct kernel_param *kp)
+{
+	bool enabled = enable;
+	int err;
+
+	err = kstrtobool(val, &enable);
+	if (err)
+		return err;
+
+	if (enable == enabled)
+		return 0;
+
+	if (enable)
+		return damon_sample_mtier_start();
+	damon_sample_mtier_stop();
+	return 0;
+}
+
+static int __init damon_sample_mtier_init(void)
+{
+	return 0;
+}
+
+module_init(damon_sample_mtier_init);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

