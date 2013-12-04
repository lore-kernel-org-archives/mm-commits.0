From: akpm@linux-foundation.org
Subject: + test-check-copy_to-from_user-boundary-validation.patch added to -mm tree
Date: Wed, 04 Dec 2013 14:22:37 -0800
Message-ID: <529fab2d.OXMRjohel2OHJwMQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3LDWWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, joe@perches.com, keescook@chromium.org

Subject: + test-check-copy_to-from_user-boundary-validation.patch added to -mm tree
To: keescook@chromium.org,joe@perches.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:22:37 -0800


The patch titled
     Subject: test: check copy_to/from_user boundary validation
has been added to the -mm tree.  Its filename is
     test-check-copy_to-from_user-boundary-validation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-check-copy_to-from_user-boundary-validation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-check-copy_to-from_user-boundary-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 lib/test_user_copy.c                  |  108 ++++++++++++++++++++++++
 tools/testing/selftests/Makefile      |    1 
 tools/testing/selftests/user/Makefile |   13 ++
 5 files changed, 136 insertions(+)

diff -puN lib/Kconfig.debug~test-check-copy_to-from_user-boundary-validation lib/Kconfig.debug
--- a/lib/Kconfig.debug~test-check-copy_to-from_user-boundary-validation
+++ a/lib/Kconfig.debug
@@ -1592,6 +1592,19 @@ config TEST_MODULE
 
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
@@ -0,0 +1,108 @@
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
+	ret |= test(!copy_from_user((char *)usermem, (char __user *)kmem,
+				    PAGE_SIZE),
+		    "illegal reversed copy_from_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				  PAGE_SIZE),
+		    "illegal all-kernel copy_to_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, (char *)usermem,
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

test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

