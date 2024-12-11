Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC4D2943F
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877501; cv=none; b=juXUHtzIhFDPdiWp5JwrjIBSiP7YCEB3MRGRc+XdaCJDtDYNNvdiXpvQlR/zBCKsi6PtK4IqmoqxSPruQhSMk8tBPtJ2O8c4wxoUFFz/BeyUteDB3AGAI2R63JmlRnV4gGPt4tYAWrtR9s0o3J9M6s3g5rUFz/OF7QYYAhw7ob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877501; c=relaxed/simple;
	bh=iwNhHnbDdrRMHjIo8VWcJnV+wDVo+5s9uSPX6UqdZLQ=;
	h=Date:To:From:Subject:Message-Id; b=d30KpmqfnnLOZr6Nj30TLFiMhfgJq4vKau3ODK53Om3wS1HxHdVdqYvpshkL3M/wmPbHkYY9gtt8un5R99CahMYWKWpJ2UFrH+BKSwaPS55rRzCsHoW7NDIJ5xm3Pjom5lj/gH1XtzcOJP2vHHmV0b7e3++e5CvzeGC3x3unsew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ak+3lD6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ak+3lD6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD50C4CED6;
	Wed, 11 Dec 2024 00:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877501;
	bh=iwNhHnbDdrRMHjIo8VWcJnV+wDVo+5s9uSPX6UqdZLQ=;
	h=Date:To:From:Subject:From;
	b=Ak+3lD6tCbVQkpUUtLGr2pFKwdql/WEEgAu4MkZF/Zjq9yVpjdwD0uw4ibN+5ojuH
	 YFAUAagP3aOvCbuWXK/NHhGhyFuVNXfD20mZXw0Wdeh7qrItfSxKkR5hEVerQv+7hN
	 MDZzUrPS1KfA8UzmRqzq8JmKdznI6IKSiQgI4iu4=
Date: Tue, 10 Dec 2024 16:38:20 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch added to mm-unstable branch
Message-Id: <20241211003821.3BD50C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: add a skeleton of a sample DAMON module for working set size estimation
has been added to the -mm mm-unstable branch.  Its filename is
     samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch

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
@@ -6328,6 +6328,7 @@ F:	Documentation/mm/damon/
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

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch

