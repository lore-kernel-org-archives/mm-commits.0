From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_sysctl-add-dedicated-proc-sysctl-test-driver.patch removed from -mm
 tree
Date: Thu, 29 Jun 2017 15:29:50 -0700
Message-ID: <59557f5e.p2a62Iu3t/0stUns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdF2W3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ebiederm@xmission.com, keescook@chromium.org, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: test_sysctl: add dedicated proc sysctl test driver
has been removed from the -mm tree.  Its filename was
     test_sysctl-add-dedicated-proc-sysctl-test-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: test_sysctl: add dedicated proc sysctl test driver

Patch series "sysctl: add dedicated stress test driver".

This series adds a dedicated proc sysctl stress test driver and extends
our current set of tests.  I spun this off from a larger series to first
get the basic knobs in place for unsigned int, which are now merged in
your tree, so this series depends on those patches.

The stress test driver uses a new license (GPL on Linux, copyleft-next
outside of Linux).  Linus was fine with this [0] and later due to Ted's
and Alans's request ironed out an "or" language clause to use [1] which is
already present upstream.

[0] https://lkml.kernel.org/r/CA+55aFyhxcvD+q7tp+-yrSFDKfR0mOHgyEAe=f_94aKLsOu0Og@mail.gmail.com
[1] https://lkml.kernel.org/r/1495234558.7848.122.camel@linux.intel.com



This patch (of 6):

Although we have had tools/testing/selftests/sysctl/ with two test cases
these use existing kernel sysctl interfaces.  We want to expand test
coverage, we can't just be looking for random safe production values to
poke at, instead just dedicate a test driver for debugging purposes and
port the existing scripts to use it.  This will make it easier for further
tests to be added.

Link: http://lkml.kernel.org/r/20170525233729.18530-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                               |   11 +
 lib/Makefile                                    |    1 
 lib/test_sysctl.c                               |  113 ++++++++++++++
 tools/testing/selftests/sysctl/config           |    1 
 tools/testing/selftests/sysctl/run_numerictests |    4 
 tools/testing/selftests/sysctl/run_stringtests  |    4 
 6 files changed, 130 insertions(+), 4 deletions(-)

diff -puN lib/Kconfig.debug~test_sysctl-add-dedicated-proc-sysctl-test-driver lib/Kconfig.debug
--- a/lib/Kconfig.debug~test_sysctl-add-dedicated-proc-sysctl-test-driver
+++ a/lib/Kconfig.debug
@@ -1964,6 +1964,17 @@ config TEST_FIRMWARE
 
 	  If unsure, say N.
 
+config TEST_SYSCTL
+	tristate "sysctl test driver"
+	default n
+	depends on PROC_SYSCTL
+	help
+	  This builds the "test_sysctl" module. This driver enables to test the
+	  proc sysctl interfaces available to drivers safely without affecting
+	  production knobs which might alter system functionality.
+
+	  If unsure, say N.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	default n
diff -puN lib/Makefile~test_sysctl-add-dedicated-proc-sysctl-test-driver lib/Makefile
--- a/lib/Makefile~test_sysctl-add-dedicated-proc-sysctl-test-driver
+++ a/lib/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_TEST_HEXDUMP) += test_hexdu
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
+obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
diff -puN /dev/null lib/test_sysctl.c
--- /dev/null
+++ a/lib/test_sysctl.c
@@ -0,0 +1,113 @@
+/*
+ * proc sysctl test driver
+ *
+ * Copyright (C) 2017 Luis R. Rodriguez <mcgrof@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or at your option any
+ * later version; or, when distributed separately from the Linux kernel or
+ * when incorporated into other software packages, subject to the following
+ * license:
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of copyleft-next (version 0.3.1 or later) as published
+ * at http://copyleft-next.org/.
+ */
+
+/*
+ * This module provides an interface to the the proc sysctl interfaces.  This
+ * driver requires CONFIG_PROC_SYSCTL. It will not normally be loaded by the
+ * system unless explicitly requested by name. You can also build this driver
+ * into your kernel.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/async.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+
+static int i_zero;
+static int i_one_hundred = 100;
+
+struct test_sysctl_data {
+	int int_0001;
+	char string_0001[65];
+};
+
+static struct test_sysctl_data test_data = {
+	.int_0001 = 60,
+	.string_0001 = "(none)",
+};
+
+/* These are all under /proc/sys/debug/test_sysctl/ */
+static struct ctl_table test_table[] = {
+	{
+		.procname	= "int_0001",
+		.data		= &test_data.int_0001,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &i_zero,
+		.extra2         = &i_one_hundred,
+	},
+	{
+		.procname	= "string_0001",
+		.data		= &test_data.string_0001,
+		.maxlen		= sizeof(test_data.string_0001),
+		.mode		= 0644,
+		.proc_handler	= proc_dostring,
+	},
+	{ }
+};
+
+static struct ctl_table test_sysctl_table[] = {
+	{
+		.procname	= "test_sysctl",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= test_table,
+	},
+	{ }
+};
+
+static struct ctl_table test_sysctl_root_table[] = {
+	{
+		.procname	= "debug",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= test_sysctl_table,
+	},
+	{ }
+};
+
+static struct ctl_table_header *test_sysctl_header;
+
+static int __init test_sysctl_init(void)
+{
+	test_sysctl_header = register_sysctl_table(test_sysctl_root_table);
+	if (!test_sysctl_header)
+		return -ENOMEM;
+	return 0;
+}
+late_initcall(test_sysctl_init);
+
+static void __exit test_sysctl_exit(void)
+{
+	if (test_sysctl_header)
+		unregister_sysctl_table(test_sysctl_header);
+}
+
+module_exit(test_sysctl_exit);
+
+MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@kernel.org>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null tools/testing/selftests/sysctl/config
--- /dev/null
+++ a/tools/testing/selftests/sysctl/config
@@ -0,0 +1 @@
+CONFIG_TEST_SYSCTL=y
diff -puN tools/testing/selftests/sysctl/run_numerictests~test_sysctl-add-dedicated-proc-sysctl-test-driver tools/testing/selftests/sysctl/run_numerictests
--- a/tools/testing/selftests/sysctl/run_numerictests~test_sysctl-add-dedicated-proc-sysctl-test-driver
+++ a/tools/testing/selftests/sysctl/run_numerictests
@@ -1,7 +1,7 @@
 #!/bin/sh
 
-SYSCTL="/proc/sys"
-TARGET="${SYSCTL}/vm/swappiness"
+SYSCTL="/proc/sys/debug/test_sysctl/"
+TARGET="${SYSCTL}/int_0001"
 ORIG=$(cat "${TARGET}")
 TEST_STR=$(( $ORIG + 1 ))
 
diff -puN tools/testing/selftests/sysctl/run_stringtests~test_sysctl-add-dedicated-proc-sysctl-test-driver tools/testing/selftests/sysctl/run_stringtests
--- a/tools/testing/selftests/sysctl/run_stringtests~test_sysctl-add-dedicated-proc-sysctl-test-driver
+++ a/tools/testing/selftests/sysctl/run_stringtests
@@ -1,7 +1,7 @@
 #!/bin/sh
 
-SYSCTL="/proc/sys"
-TARGET="${SYSCTL}/kernel/domainname"
+SYSCTL="/proc/sys/debug/test_sysctl/"
+TARGET="${SYSCTL}/string_0001"
 ORIG=$(cat "${TARGET}")
 TEST_STR="Testing sysctl"
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-give-proc-sysctl-some-maintainer-love.patch
sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
maintainers-give-kmod-some-maintainer-love.patch
kmod-add-test-driver-to-stress-test-the-module-loader.patch
kmod-throttle-kmod-thread-limit.patch

