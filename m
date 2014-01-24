From: akpm@linux-foundation.org
Subject: [merged] test-check-copy_to-from_user-boundary-validation.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:39 -0800
Message-ID: <52e2b893.qSTzQKlxzvnfm4kE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaAXTBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, joe@perches.com, keescook@chromium.org

Subject: [merged] test-check-copy_to-from_user-boundary-validation.patch removed from -mm tree
To: keescook@chromium.org,joe@perches.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:39 -0800


The patch titled
     Subject: test: check copy_to/from_user boundary validation
has been removed from the -mm tree.  Its filename was
     test-check-copy_to-from_user-boundary-validation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: test: check copy_to/from_user boundary validation

To help avoid an architecture failing to correctly check kernel/user
boundaries when handling copy_to_user, copy_from_user, put_user, or
get_user, perform some simple tests and fail to load if any of them behave
unexpectedly.

Specifically, this is to make sure there is a way to notice if things like
what was fixed in 8404663f81 ("ARM: 7527/1: uaccess: explicitly check
__user pointer when !CPU_USE_DOMAINS") ever regresses again, for any
architecture.

Additionally, adds new "user" selftest target, which loads this module.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                     |   13 ++
 lib/Makefile                          |    1 
 lib/test_user_copy.c                  |  110 ++++++++++++++++++++++++
 tools/testing/selftests/Makefile      |    1 
 tools/testing/selftests/user/Makefile |   13 ++
 5 files changed, 138 insertions(+)

diff -puN lib/Kconfig.debug~test-check-copy_to-from_user-boundary-validation lib/Kconfig.debug
--- a/lib/Kconfig.debug~test-check-copy_to-from_user-boundary-validation
+++ a/lib/Kconfig.debug
@@ -1609,6 +1609,19 @@ config TEST_MODULE
 
 	  If unsure, say N.
 
+config TEST_USER_COPY
+	tristate "Test user/kernel boundary protections"
+	default n
+	depends on m
+	help
+	  This builds the "test_user_copy" module that runs sanity checks
+	  on the copy_to/from_user infrastructure, making sure basic
+	  user/kernel boundary testing is working. If it fails to load,
+	  a regression has been detected in the user/kernel memory boundary
+	  protections.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff -puN lib/Makefile~test-check-copy_to-from_user-boundary-validation lib/Makefile
--- a/lib/Makefile~test-check-copy_to-from_user-boundary-validation
+++ a/lib/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_TEST_STRING_HELPERS) += tes
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_MODULE) += test_module.o
+obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/test_user_copy.c
--- /dev/null
+++ a/lib/test_user_copy.c
@@ -0,0 +1,110 @@
+/*
+ * Kernel module for testing copy_to/from_user infrastructure.
+ *
+ * Copyright 2013 Google Inc. All Rights Reserved
+ *
+ * Authors:
+ *      Kees Cook       <keescook@chromium.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#define test(condition, msg)		\
+({					\
+	int cond = (condition);		\
+	if (cond)			\
+		pr_warn("%s\n", msg);	\
+	cond;				\
+})
+
+static int __init test_user_copy_init(void)
+{
+	int ret = 0;
+	char *kmem;
+	char __user *usermem;
+	char *bad_usermem;
+	unsigned long user_addr;
+	unsigned long value = 0x5A;
+
+	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+	if (!kmem)
+		return -ENOMEM;
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE * 2,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= (unsigned long)(TASK_SIZE)) {
+		pr_warn("Failed to allocate user memory\n");
+		kfree(kmem);
+		return -ENOMEM;
+	}
+
+	usermem = (char __user *)user_addr;
+	bad_usermem = (char *)user_addr;
+
+	/* Legitimate usage: none of these should fail. */
+	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
+		    "legitimate copy_from_user failed");
+	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
+		    "legitimate copy_to_user failed");
+	ret |= test(get_user(value, (unsigned long __user *)usermem),
+		    "legitimate get_user failed");
+	ret |= test(put_user(value, (unsigned long __user *)usermem),
+		    "legitimate put_user failed");
+
+	/* Invalid usage: none of these should succeed. */
+	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				    PAGE_SIZE),
+		    "illegal all-kernel copy_from_user passed");
+	ret |= test(!copy_from_user(bad_usermem, (char __user *)kmem,
+				    PAGE_SIZE),
+		    "illegal reversed copy_from_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				  PAGE_SIZE),
+		    "illegal all-kernel copy_to_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
+				  PAGE_SIZE),
+		    "illegal reversed copy_to_user passed");
+	ret |= test(!get_user(value, (unsigned long __user *)kmem),
+		    "illegal get_user passed");
+	ret |= test(!put_user(value, (unsigned long __user *)kmem),
+		    "illegal put_user passed");
+
+	vm_munmap(user_addr, PAGE_SIZE * 2);
+	kfree(kmem);
+
+	if (ret == 0) {
+		pr_info("tests passed.\n");
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+module_init(test_user_copy_init);
+
+static void __exit test_user_copy_exit(void)
+{
+	pr_info("unloaded.\n");
+}
+
+module_exit(test_user_copy_exit);
+
+MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_LICENSE("GPL");
diff -puN tools/testing/selftests/Makefile~test-check-copy_to-from_user-boundary-validation tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~test-check-copy_to-from_user-boundary-validation
+++ a/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += ptrace
 TARGETS += timers
 TARGETS += vm
 TARGETS += powerpc
+TARGETS += user
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/user/Makefile
--- /dev/null
+++ a/tools/testing/selftests/user/Makefile
@@ -0,0 +1,13 @@
+# Makefile for user memory selftests
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+all:
+
+run_tests: all
+	@if /sbin/modprobe test_user_copy ; then \
+		rmmod test_user_copy; \
+		echo "user_copy: ok"; \
+	else \
+		echo "user_copy: [FAIL]"; \
+		exit 1; \
+	fi
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

