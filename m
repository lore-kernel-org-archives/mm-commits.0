From: akpm@linux-foundation.org
Subject: + percpu-add-test-module-for-various-percpu-operations.patch
 added to -mm tree
Date: Tue, 29 Oct 2013 13:51:23 -0700
Message-ID: <52701fcb.uRvGW7UKgGuzPMRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3J2UvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Oct 2013 16:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, gthelen@google.com

Subject: + percpu-add-test-module-for-various-percpu-operations.patch added to -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Oct 2013 13:51:23 -0700


The patch titled
     Subject: percpu: add test module for various percpu operations
has been added to the -mm tree.  Its filename is
     percpu-add-test-module-for-various-percpu-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-add-test-module-for-various-percpu-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-test-module-for-various-percpu-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1472,6 +1472,15 @@ config INTERVAL_TREE_TEST
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
+		     "raw %ld (0x%lx) != expected %ld (0x%lx)",         \
+		     (long)(native), (long)(native),                    \
+		     (long)(expected), (long)(expected));               \
+		WARN(__this_cpu_read(pcp) != (expected),                \
+		     "pcp %ld (0x%lx) != expected %ld (0x%lx)",         \
+		     (long)__this_cpu_read(pcp), (long)__this_cpu_read(pcp), \
+		     (long)(expected), (long)(expected));               \
+	} while (0)
+
+static DEFINE_PER_CPU(long, long_counter);
+static DEFINE_PER_CPU(unsigned long, ulong_counter);
+
+static int __init percpu_test_init(void)
+{
+	/*
+	 * volatile prevents compiler from optimizing it uses, otherwise the
+	 * +ul_one and -ul_one below would replace with inc/dec instructions.
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
+	CHECK(ul, ulong_counter, 0xffffffffffffffff);
+	CHECK(ul, ulong_counter, -1);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, 0xffffffff);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, 0x100000000);
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
+	CHECK(l, long_counter, 0x100000000);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+	CHECK(l, long_counter, 0xffffffffffffffff);
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
+	CHECK(ul, ulong_counter, 0xffffffffffffffff);
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

percpu-fix-this_cpu_sub-subtrahend-casting-for-unsigneds.patch
memcg-refactor-mem_control_numa_stat_show.patch
memcg-support-hierarchical-memorynuma_stats.patch
percpu-add-test-module-for-various-percpu-operations.patch
memcg-use-__this_cpu_sub-to-dec-stats-to-avoid-incorrect-subtrahend-casting.patch

