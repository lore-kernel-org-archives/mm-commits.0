From: akpm@linux-foundation.org
Subject: [merged]
 percpu-add-test-module-for-various-percpu-operations.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:46 -0800
Message-ID: <5283e392.f41VKFca+I8dOwPB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3KMUjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, gthelen@google.com

Subject: [merged] percpu-add-test-module-for-various-percpu-operations.patch removed from -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:46 -0800


The patch titled
     Subject: percpu: add test module for various percpu operations
has been removed from the -mm tree.  Its filename was
     percpu-add-test-module-for-various-percpu-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: percpu: add test module for various percpu operations

Tests various percpu operations.

Enable with CONFIG_PERCPU_TEST=m.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 ++
 lib/Makefile      |    2 
 lib/percpu_test.c |  138 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)

diff -puN lib/Kconfig.debug~percpu-add-test-module-for-various-percpu-operations lib/Kconfig.debug
--- a/lib/Kconfig.debug~percpu-add-test-module-for-various-percpu-operations
+++ a/lib/Kconfig.debug
@@ -1481,6 +1481,15 @@ config INTERVAL_TREE_TEST
 	help
 	  A benchmark measuring the performance of the interval tree library
 
+config PERCPU_TEST
+	tristate "Per cpu operations test"
+	depends on m && DEBUG_KERNEL
+	help
+	  Enable this option to build test module which validates per-cpu
+	  operations.
+
+	  If unsure, say N.
+
 config ATOMIC64_SELFTEST
 	bool "Perform an atomic64_t self-test at boot"
 	help
diff -puN lib/Makefile~percpu-add-test-module-for-various-percpu-operations lib/Makefile
--- a/lib/Makefile~percpu-add-test-module-for-various-percpu-operations
+++ a/lib/Makefile
@@ -157,6 +157,8 @@ obj-$(CONFIG_INTERVAL_TREE_TEST) += inte
 
 interval_tree_test-objs := interval_tree_test_main.o interval_tree.o
 
+obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
+
 obj-$(CONFIG_ASN1) += asn1_decoder.o
 
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
diff -puN /dev/null lib/percpu_test.c
--- /dev/null
+++ a/lib/percpu_test.c
@@ -0,0 +1,138 @@
+#include <linux/module.h>
+
+/* validate @native and @pcp counter values match @expected */
+#define CHECK(native, pcp, expected)                                    \
+	do {                                                            \
+		WARN((native) != (expected),                            \
+		     "raw %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     (native), (native),				\
+		     (long long)(expected), (long long)(expected));	\
+		WARN(__this_cpu_read(pcp) != (expected),                \
+		     "pcp %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     __this_cpu_read(pcp), __this_cpu_read(pcp),	\
+		     (long long)(expected), (long long)(expected));	\
+	} while (0)
+
+static DEFINE_PER_CPU(long, long_counter);
+static DEFINE_PER_CPU(unsigned long, ulong_counter);
+
+static int __init percpu_test_init(void)
+{
+	/*
+	 * volatile prevents compiler from optimizing it uses, otherwise the
+	 * +ul_one/-ul_one below would replace with inc/dec instructions.
+	 */
+	volatile unsigned int ui_one = 1;
+	long l = 0;
+	unsigned long ul = 0;
+
+	pr_info("percpu test start\n");
+
+	preempt_disable();
+
+	l += -1;
+	__this_cpu_add(long_counter, -1);
+	CHECK(l, long_counter, -1);
+
+	l += 1;
+	__this_cpu_add(long_counter, 1);
+	CHECK(l, long_counter, 0);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += 1UL;
+	__this_cpu_add(ulong_counter, 1UL);
+	CHECK(ul, ulong_counter, 1);
+
+	ul += -1UL;
+	__this_cpu_add(ulong_counter, -1UL);
+	CHECK(ul, ulong_counter, 0);
+
+	ul += -(unsigned long)1;
+	__this_cpu_add(ulong_counter, -(unsigned long)1);
+	CHECK(ul, ulong_counter, -1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= 1;
+	__this_cpu_dec(ulong_counter);
+	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, ULONG_MAX);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, 0xffffffff);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, (long)0x100000000LL);
+
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	__this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, 1);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, (long)0x100000000LL);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+	CHECK(l, long_counter, ULONG_MAX);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += ui_one;
+	__this_cpu_add(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= ui_one;
+	__this_cpu_sub(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, ULONG_MAX);
+
+	ul = 3;
+	__this_cpu_write(ulong_counter, 3);
+
+	ul = this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 2);
+
+	ul = __this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 1);
+
+	preempt_enable();
+
+	pr_info("percpu test done\n");
+	return -EAGAIN;  /* Fail will directly unload the module */
+}
+
+static void __exit percpu_test_exit(void)
+{
+}
+
+module_init(percpu_test_init)
+module_exit(percpu_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Greg Thelen");
+MODULE_DESCRIPTION("percpu operations test");
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

