Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC6259C
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877511; cv=none; b=RslmQb1lXJJx0ohrxhzSbLmDxgb+Qmd68k4Darw1B67DabPnABvOQNMDNlprNFmWnAW7s6tahhJprzp5WVd5wBRPD9e5HLB7TTUD5lIiXgasPq+ULaXQwloCSiR/B/h61nWwKx/KOJZWky5nrNJpzO8+Il4nPF40kai+acdIedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877511; c=relaxed/simple;
	bh=OqISkz4RI1SvTzeaZDigeEjrfYLN0RFsLAcywqDvOvM=;
	h=Date:To:From:Subject:Message-Id; b=a+qL65ys24nD3Z+6b/d7x0Qm8rBRoft+Dm4bYJq+3jZXqkLx4yMHEFXaRSoATLqmWVu7ko3F7wcnt/p8jl5LFECgn4QGc52Eaa2Pqz8ZGccNqNbPTqBQlCkuwGhBs6QKqtEiXkSaTV0/RScvQuX3Hh/pEoB9GQgiKRiOyiJmmv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/VD6f1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/VD6f1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770A0C4CED6;
	Wed, 11 Dec 2024 00:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877510;
	bh=OqISkz4RI1SvTzeaZDigeEjrfYLN0RFsLAcywqDvOvM=;
	h=Date:To:From:Subject:From;
	b=O/VD6f1LkflKVSetuqVWBlxrcHYGHnRjMO1c4MjfTsyZ+EjJiRu2ybFD4zD8MGuI6
	 Qwldl5nHR+roF/SR3i9E3zqJopxWM+tWQsTt7Mi98N9JlUna6SVnvVHs4ZTZdDz3SP
	 AzACW/bA6x0RAfK4tMYNzx5Z1Xgp2pLGJolqZzk4=
Date: Tue, 10 Dec 2024 16:38:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch added to mm-unstable branch
Message-Id: <20241211003830.770A0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch

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
Subject: samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation
Date: Tue, 10 Dec 2024 13:50:29 -0800

DAMON is not only for monitoring of access patterns, but also for
access-aware system operations.  For the system operations, DAMON provides
a feature called DAMOS (Data Access Monitoring-based Operation Schemes). 
There is no sample API usage of DAMOS, though.  Copy the working set size
estimation sample modules with changed names of the module and symbols, to
use it as a skeleton for a sample module showing the DAMOS API usage.  The
following commit will make it proactively reclaim cold memory of the given
process, using DAMOS.

Link: https://lkml.kernel.org/r/20241210215030.85675-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Makefile       |    1 
 samples/damon/Kconfig  |   13 ++++
 samples/damon/Makefile |    1 
 samples/damon/prcl.c   |  116 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 131 insertions(+)

--- a/samples/damon/Kconfig~samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation
+++ a/samples/damon/Kconfig
@@ -14,4 +14,17 @@ config SAMPLE_DAMON_WSSE
 
 	  If unsure, say N.
 
+config SAMPLE_DAMON_PRCL
+	bool "DAMON sameple module for access-aware proactive reclamation"
+	depends on DAMON && DAMON_VADDR
+	help
+	  This builds DAMON sample module for access-aware proactive
+	  reclamation.
+
+	  The module receives a pid, monitor access to the virtual address
+	  space of the process, find memory regions that not accessed, and
+	  proactively reclaim the regions.
+
+	  If unsure, say N.
+
 endmenu
--- a/samples/damon/Makefile~samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation
+++ a/samples/damon/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
+obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
diff --git a/samples/damon/prcl.c a/samples/damon/prcl.c
new file mode 100644
--- /dev/null
+++ a/samples/damon/prcl.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * proactive reclamation: monitor access pattern of a given process, find
+ * regiosn that seems not accessed, and proactively page out the regions.
+ */
+
+#define pr_fmt(fmt) "damon_sample_prcl: " fmt
+
+#include <linux/damon.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static int target_pid __read_mostly;
+module_param(target_pid, int, 0600);
+
+static int damon_sample_prcl_enable_store(
+		const char *val, const struct kernel_param *kp);
+
+static const struct kernel_param_ops enable_param_ops = {
+	.set = damon_sample_prcl_enable_store,
+	.get = param_get_bool,
+};
+
+static bool enable __read_mostly;
+module_param_cb(enable, &enable_param_ops, &enable, 0600);
+MODULE_PARM_DESC(enable, "Enable of disable DAMON_SAMPLE_WSSE");
+
+static struct damon_ctx *ctx;
+static struct pid *target_pidp;
+
+static int damon_sample_prcl_after_aggregate(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *r;
+		unsigned long wss = 0;
+
+		damon_for_each_region(r, t) {
+			if (r->nr_accesses > 0)
+				wss += r->ar.end - r->ar.start;
+		}
+		pr_info("wss: %lu\n", wss);
+	}
+	return 0;
+}
+
+static int damon_sample_prcl_start(void)
+{
+	struct damon_target *target;
+
+	pr_info("start\n");
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return -ENOMEM;
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_add_target(ctx, target);
+	target_pidp = find_get_pid(target_pid);
+	if (!target_pidp) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+	target->pid = target_pidp;
+
+	ctx->callback.after_aggregation = damon_sample_prcl_after_aggregate;
+
+	return damon_start(&ctx, 1, true);
+}
+
+static void damon_sample_prcl_stop(void)
+{
+	pr_info("stop\n");
+	if (ctx) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	if (target_pidp)
+		put_pid(target_pidp);
+}
+
+static int damon_sample_prcl_enable_store(
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
+		return damon_sample_prcl_start();
+	damon_sample_prcl_stop();
+	return 0;
+}
+
+static int __init damon_sample_prcl_init(void)
+{
+	return 0;
+}
+
+module_init(damon_sample_prcl_init);
--- a/samples/Makefile~samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation
+++ a/samples/Makefile
@@ -40,3 +40,4 @@ obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+=
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
 obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
+obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch

