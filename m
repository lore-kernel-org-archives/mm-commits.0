Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEE23C71C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837059; cv=none; b=B9uCt3dWHru3pFVF9ixHDOGZbqY+QWw1f/HNhERG6WB3JbZlQrng03u0DUJAWv/iM9pGzGvx/+rEFlDWeErToE/ecgcDqBT9OXPJ2M68t/RRRv3/g3sYdNHbckxr9rzWc7I5t7TyG0NrhAVP0jIcDjO6sHbwK5m72muGvYqnXmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837059; c=relaxed/simple;
	bh=uZNCT5q9mgiOhnNG/Y8FLo4wyGrAydo0W0Ehh00waRg=;
	h=Date:To:From:Subject:Message-Id; b=ccUQZS2wFW99Qskm2ufHhnLI6ESrPkmhRYYzo3++3ghE66T8zJVXTJSKUjOYenSDpxMQA85m2bcTYiQc0YFETy7oeAQPcqUGGRLOkSJksKYr4MRXLeLqMg5NTpuZE5fA4TKoEeSITyGPopnPKcGH/cJ/kd+PueCrtVn69kI4Ras=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCa+Zb8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCa+Zb8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EC8C4CEDD;
	Tue, 14 Jan 2025 06:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837058;
	bh=uZNCT5q9mgiOhnNG/Y8FLo4wyGrAydo0W0Ehh00waRg=;
	h=Date:To:From:Subject:From;
	b=oCa+Zb8AkzuVRJQP5EYnEPxpv9CXUFJmcDqfNEQvEDgy+KmGy0Xuq3V6nOH2jubkk
	 M+Ri4LSGnKH2cvz1lRw5bmvEVjRc1NKQYpHZbA8soEo+RiBK7vxAhTHEflKcrBr0Jp
	 yG2I/UIui0wP/2cGE5gLhqdIp3ZUqbKFYjQ+uCuU=
Date: Mon, 13 Jan 2025 22:44:18 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch removed from -mm tree
Message-Id: <20250114064418.B2EC8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: add a skeleton of a sample DAMON module for working set size estimation
has been removed from the -mm tree.  Its filename was
     samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples: add a skeleton of a sample DAMON module for working set size estimation
Date: Tue, 10 Dec 2024 13:50:26 -0800

Patch series "mm/damon: add sample modules".

Implement a proactive cold memory regions reclaiming logic of prcl sample
module using DAMOS.  The logic treats memory regions that not accessed at
all for five or more seconds as cold, and reclaim those as soon as found.


This patch (of 5):

Add a skeleton for a sample DAMON static module that can be used for
estimating working set size of a given process.  Note that it is a static
module since DAMON is not exporting symbols to loadable modules for now. 
It exposes two module parameters, namely 'pid' and 'enable'.  'pid' will
specify the process that the module will estimate the working set size of.
'enable' will receive whether to start or stop the estimation.  Because
this is just a skeleton, the parameters do nothing, though.  The
functionalities will be implemented by following commits.

Link: https://lkml.kernel.org/r/20241210215030.85675-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20241210215030.85675-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS            |    1 
 samples/Kconfig        |    2 +
 samples/Makefile       |    1 
 samples/damon/Kconfig  |   17 ++++++++++
 samples/damon/Makefile |    3 +
 samples/damon/wsse.c   |   65 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+)

--- a/MAINTAINERS~samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation
+++ a/MAINTAINERS
@@ -6330,6 +6330,7 @@ F:	Documentation/mm/damon/
 F:	include/linux/damon.h
 F:	include/trace/events/damon.h
 F:	mm/damon/
+F:	samples/damon/
 F:	tools/testing/selftests/damon/
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
diff --git a/samples/damon/Kconfig a/samples/damon/Kconfig
new file mode 100644
--- /dev/null
+++ a/samples/damon/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+
+menu "DAMON Samples"
+
+config SAMPLE_DAMON_WSSE
+	bool "DAMON sameple module for working set size estimation"
+	depends on DAMON && DAMON_VADDR
+	help
+	  This builds DAMON sample module for working set size estimation.
+
+	  The module receives a pid, monitor access to the virtual address
+	  space of the process, estimate working set size of the process, and
+	  repeatedly prints the size on the kernel log.
+
+	  If unsure, say N.
+
+endmenu
diff --git a/samples/damon/Makefile a/samples/damon/Makefile
new file mode 100644
--- /dev/null
+++ a/samples/damon/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
diff --git a/samples/damon/wsse.c a/samples/damon/wsse.c
new file mode 100644
--- /dev/null
+++ a/samples/damon/wsse.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * working set size estimation: monitor access pattern of given process and
+ * print estimated working set size (total size of regions that showing some
+ * access).
+ */
+
+#define pr_fmt(fmt) "damon_sample_wsse: " fmt
+
+#include <linux/damon.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static int target_pid __read_mostly;
+module_param(target_pid, int, 0600);
+
+static int damon_sample_wsse_enable_store(
+		const char *val, const struct kernel_param *kp);
+
+static const struct kernel_param_ops enable_param_ops = {
+	.set = damon_sample_wsse_enable_store,
+	.get = param_get_bool,
+};
+
+static bool enable __read_mostly;
+module_param_cb(enable, &enable_param_ops, &enable, 0600);
+MODULE_PARM_DESC(enable, "Enable or disable DAMON_SAMPLE_WSSE");
+
+static int damon_sample_wsse_start(void)
+{
+	pr_info("start\n");
+	return 0;
+}
+
+static void damon_sample_wsse_stop(void)
+{
+	pr_info("stop\n");
+}
+
+static int damon_sample_wsse_enable_store(
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
+		return damon_sample_wsse_start();
+	damon_sample_wsse_stop();
+	return 0;
+}
+
+static int __init damon_sample_wsse_init(void)
+{
+	return 0;
+}
+
+module_init(damon_sample_wsse_init);
--- a/samples/Kconfig~samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation
+++ a/samples/Kconfig
@@ -293,6 +293,8 @@ config SAMPLE_CGROUP
 
 source "samples/rust/Kconfig"
 
+source "samples/damon/Kconfig"
+
 endif # SAMPLES
 
 config HAVE_SAMPLE_FTRACE_DIRECT
--- a/samples/Makefile~samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation
+++ a/samples/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_SAMPLE_KMEMLEAK)		+= kmemle
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
+obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

