Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E83A2D97BD
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 21:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092114; cv=none; b=Av/BseW0VKw1ythoa4iLDIQ678ond/yLuIGKO0VM0OFEWvFeMsam/vpvpTxyctif6CgmxL3ccwnEzVt0ZkqXx8+oHZzmCBT6DJHqhKANC46u/EzEioQmKEbvcwn2JGLU1TBeHVIo4gmEsAWF8s0Hrr2G57SQw3hqNGxINNTRqxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092114; c=relaxed/simple;
	bh=bzCzY81NJZLWvb9IH/DFsbBOy+faWR/zqMzHEFrJpYo=;
	h=Date:To:From:Subject:Message-Id; b=Hx5VKnfZOEpUAObDtm9OOwBFAMcYFJDsUeFg4XhGcj9H1Dz4ipitrFaKfUH9TZ4HhvGusZz0bGpbZLJXqwKqZ52ZZ9ouQZ/SwGdoaBjb07sLfYb02uQSE4SoFnzCzC7Jr1MOjl+e3QeC6Bbbohplt9P2IJcn63Z6uUtgatYGL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1av9OGRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1av9OGRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1B3C4CEFB;
	Thu, 18 Dec 2025 21:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092112;
	bh=bzCzY81NJZLWvb9IH/DFsbBOy+faWR/zqMzHEFrJpYo=;
	h=Date:To:From:Subject:From;
	b=1av9OGRzSArB568aZmyL+B9ZXtDr5bVt7tawJG3m1VQWpdlaqKgweFNVRSybCtUzi
	 EppAecTQwx2C++4ETmciyhUeet7Pj55IxyuP1jEimPNbWWwZZno/VsZbdHZgSL+BjH
	 pkKdnwQ6nHUteKLJLL+h8dlZNp0VycG0WpakMp9w=
Date: Thu, 18 Dec 2025 13:08:31 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,skhawaja@google.com,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pmladek@suse.com,kees@kernel.org,graf@amazon.com,dmatlack@google.com,davidgow@google.com,corbet@lwn.net,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tests-liveupdate-add-in-kernel-liveupdate-test.patch added to mm-nonmm-unstable branch
Message-Id: <20251218210832.0E1B3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tests/liveupdate: add in-kernel liveupdate test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tests-liveupdate-add-in-kernel-liveupdate-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tests-liveupdate-add-in-kernel-liveupdate-test.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: tests/liveupdate: add in-kernel liveupdate test
Date: Thu, 18 Dec 2025 10:57:52 -0500

Introduce an in-kernel test module to validate the core logic of the Live
Update Orchestrator's File-Lifecycle-Bound feature.  This provides a
low-level, controlled environment to test FLB registration and callback
invocation without requiring userspace interaction or actual kexec
reboots.

The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.

Link: https://lkml.kernel.org/r/20251218155752.3045808-6-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Gow <davidgow@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    1 
 include/linux/kho/abi/luo.h      |    5 
 kernel/liveupdate/luo_file.c     |    8 +
 kernel/liveupdate/luo_internal.h |    8 +
 lib/Kconfig.debug                |   23 ++++
 lib/tests/Makefile               |    1 
 lib/tests/liveupdate.c           |  158 +++++++++++++++++++++++++++++
 7 files changed, 203 insertions(+), 1 deletion(-)

--- a/include/linux/kho/abi/luo.h~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/include/linux/kho/abi/luo.h
@@ -239,4 +239,9 @@ struct luo_flb_ser {
 	u64 count;
 } __packed;
 
+/* Kernel Live Update Test ABI */
+#ifdef CONFIG_LIVEUPDATE_TEST
+#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
+#endif
+
 #endif /* _LINUX_KHO_ABI_LUO_H */
--- a/kernel/liveupdate/luo_file.c~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/kernel/liveupdate/luo_file.c
@@ -864,6 +864,8 @@ int liveupdate_register_file_handler(str
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
+	liveupdate_test_register(fh);
+
 	return 0;
 
 err_resume:
@@ -895,8 +897,10 @@ int liveupdate_unregister_file_handler(s
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
+	liveupdate_test_unregister(fh);
+
 	if (!luo_session_quiesce())
-		return -EBUSY;
+		goto err_register;
 
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_resume;
@@ -909,5 +913,7 @@ int liveupdate_unregister_file_handler(s
 
 err_resume:
 	luo_session_resume();
+err_register:
+	liveupdate_test_register(fh);
 	return err;
 }
--- a/kernel/liveupdate/luo_internal.h~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/kernel/liveupdate/luo_internal.h
@@ -107,4 +107,12 @@ int __init luo_flb_setup_outgoing(void *
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
 
+#ifdef CONFIG_LIVEUPDATE_TEST
+void liveupdate_test_register(struct liveupdate_file_handler *fh);
+void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
+#else
+static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
+static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
--- a/lib/Kconfig.debug~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/lib/Kconfig.debug
@@ -2835,6 +2835,29 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config LIVEUPDATE_TEST
+	bool "Live Update Kernel Test"
+	default n
+	depends on LIVEUPDATE
+	help
+	  Enable a built-in kernel test module for the Live Update
+	  Orchestrator.
+
+	  This module validates the File-Lifecycle-Bound subsystem by
+	  registering a set of mock FLB objects with any real file handlers
+	  that support live update (such as the memfd handler).
+
+	  When live update operations are performed, this test module will
+	  output messages to the kernel log (dmesg), confirming that its
+	  registration and various callback functions (preserve, retrieve,
+	  finish, etc.) are being invoked correctly.
+
+	  This is a debugging and regression testing tool for developers
+	  working on the Live Update subsystem. It should not be enabled in
+	  production kernels.
+
+	  If unsure, say N
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/liveupdate.c a/lib/tests/liveupdate.c
new file mode 100644
--- /dev/null
+++ a/lib/tests/liveupdate.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " test: " fmt
+
+#include <linux/cleanup.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include "../../kernel/liveupdate/luo_internal.h"
+
+static const struct liveupdate_flb_ops test_flb_ops;
+#define DEFINE_TEST_FLB(i) {						\
+	.ops = &test_flb_ops,						\
+	.compatible = LIVEUPDATE_TEST_FLB_COMPATIBLE(i),		\
+}
+
+/* Number of Test FLBs to register with every file handler */
+#define TEST_NFLBS 3
+static struct liveupdate_flb test_flbs[TEST_NFLBS] = {
+	DEFINE_TEST_FLB(0),
+	DEFINE_TEST_FLB(1),
+	DEFINE_TEST_FLB(2),
+};
+
+#define TEST_FLB_MAGIC_BASE 0xFEEDF00DCAFEBEE0ULL
+
+static int test_flb_preserve(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+
+	pr_info("%s: preserve was triggered\n", argp->flb->compatible);
+	argp->data = TEST_FLB_MAGIC_BASE + index;
+
+	return 0;
+}
+
+static void test_flb_unpreserve(struct liveupdate_flb_op_args *argp)
+{
+	pr_info("%s: unpreserve was triggered\n", argp->flb->compatible);
+}
+
+static int test_flb_retrieve(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+	u64 expected_data = TEST_FLB_MAGIC_BASE + index;
+
+	if (argp->data == expected_data) {
+		pr_info("%s: found flb data from the previous boot\n",
+			argp->flb->compatible);
+		argp->obj = (void *)argp->data;
+	} else {
+		pr_err("%s: ERROR - incorrect data handle: %llx, expected %llx\n",
+		       argp->flb->compatible, argp->data, expected_data);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void test_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+	void *expected_obj = (void *)(TEST_FLB_MAGIC_BASE + index);
+
+	if (argp->obj == expected_obj) {
+		pr_info("%s: finish was triggered\n", argp->flb->compatible);
+	} else {
+		pr_err("%s: ERROR - finish called with invalid object\n",
+		       argp->flb->compatible);
+	}
+}
+
+static const struct liveupdate_flb_ops test_flb_ops = {
+	.preserve	= test_flb_preserve,
+	.unpreserve	= test_flb_unpreserve,
+	.retrieve	= test_flb_retrieve,
+	.finish		= test_flb_finish,
+	.owner		= THIS_MODULE,
+};
+
+static void liveupdate_test_init(void)
+{
+	static DEFINE_MUTEX(init_lock);
+	static bool initialized;
+	int i;
+
+	guard(mutex)(&init_lock);
+
+	if (initialized)
+		return;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+		void *obj;
+		int err;
+
+		err = liveupdate_flb_get_incoming(flb, &obj);
+		if (err && err != -ENODATA && err != -ENOENT) {
+			pr_err("liveupdate_flb_get_incoming for %s failed: %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+	initialized = true;
+}
+
+void liveupdate_test_register(struct liveupdate_file_handler *fh)
+{
+	int err, i;
+
+	liveupdate_test_init();
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+
+		err = liveupdate_register_flb(fh, flb);
+		if (err) {
+			pr_err("Failed to register %s %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+
+	err = liveupdate_register_flb(fh, &test_flbs[0]);
+	if (!err || err != -EEXIST) {
+		pr_err("Failed: %s should be already registered, but got err: %pe\n",
+		       test_flbs[0].compatible, ERR_PTR(err));
+	}
+
+	pr_info("Registered %d FLBs with file handler: [%s]\n",
+		TEST_NFLBS, fh->compatible);
+}
+
+void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
+{
+	int err, i;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+
+		err = liveupdate_unregister_flb(fh, flb);
+		if (err) {
+			pr_err("Failed to unregister %s %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+
+	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
+		TEST_NFLBS, fh->compatible);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
+MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
--- a/lib/tests/Makefile~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/lib/tests/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_LIST_PRIVATE_KUNIT_TEST) +=
 obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
+obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
--- a/MAINTAINERS~tests-liveupdate-add-in-kernel-liveupdate-test
+++ a/MAINTAINERS
@@ -14643,6 +14643,7 @@ F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	lib/tests/liveupdate.c
 F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

