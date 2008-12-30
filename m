From: akpm@linux-foundation.org
Subject: + kmemleak-simple-testing-module-for-kmemleak.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:23:13 -0800
Message-ID: <200812300023.mBU0NDmZ006205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYL3AXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com


The patch titled
     kmemleak: simple testing module for kmemleak
has been added to the -mm tree.  Its filename is
     kmemleak-simple-testing-module-for-kmemleak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: simple testing module for kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>

Add a loadable module that deliberately leaks memory.  It is used for
testing various memory leaking scenarios.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |   11 ++++
 mm/Makefile        |    1 
 mm/kmemleak-test.c |  111 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)

diff -puN lib/Kconfig.debug~kmemleak-simple-testing-module-for-kmemleak lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmemleak-simple-testing-module-for-kmemleak
+++ a/lib/Kconfig.debug
@@ -320,6 +320,17 @@ config DEBUG_KMEMLEAK
 	  In order to access the kmemleak file, debugfs needs to be
 	  mounted (usually at /sys/kernel/debug).
 
+config DEBUG_KMEMLEAK_TEST
+	tristate "Simple test for the kernel memory leak detector"
+	default n
+	depends on DEBUG_KMEMLEAK
+	help
+	  Say Y or M here to build a test for the kernel memory leak
+	  detector. This option enables a module that explicitly leaks
+	  memory.
+
+	  If unsure, say N.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff -puN mm/Makefile~kmemleak-simple-testing-module-for-kmemleak mm/Makefile
--- a/mm/Makefile~kmemleak-simple-testing-module-for-kmemleak
+++ a/mm/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
+obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
diff -puN /dev/null mm/kmemleak-test.c
--- /dev/null
+++ a/mm/kmemleak-test.c
@@ -0,0 +1,111 @@
+/*
+ * mm/kmemleak-test.c
+ *
+ * Copyright (C) 2008 ARM Limited
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/fdtable.h>
+
+#include <linux/kmemleak.h>
+
+struct test_node {
+	long header[25];
+	struct list_head list;
+	long footer[25];
+};
+
+static LIST_HEAD(test_list);
+static DEFINE_PER_CPU(void *, test_pointer);
+
+/*
+ * Some very simple testing. This function needs to be extended for
+ * proper testing.
+ */
+static int __init kmemleak_test_init(void)
+{
+	struct test_node *elem;
+	int i;
+
+	printk(KERN_INFO "Kmemleak testing\n");
+
+	/* make some orphan objects */
+	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+#ifndef CONFIG_MODULES
+	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+#endif
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+
+	/*
+	 * Add elements to a list. They should only appear as orphan
+	 * after the module is removed.
+	 */
+	for (i = 0; i < 10; i++) {
+		elem = kmalloc(sizeof(*elem), GFP_KERNEL);
+		pr_info("kmemleak: kmalloc(sizeof(*elem)) = %p\n", elem);
+		if (!elem)
+			return -ENOMEM;
+		memset(elem, 0, sizeof(*elem));
+		INIT_LIST_HEAD(&elem->list);
+
+		list_add_tail(&elem->list, &test_list);
+	}
+
+	for_each_possible_cpu(i) {
+		per_cpu(test_pointer, i) = kmalloc(129, GFP_KERNEL);
+		pr_info("kmemleak: kmalloc(129) = %p\n",
+			per_cpu(test_pointer, i));
+	}
+
+	return 0;
+}
+module_init(kmemleak_test_init);
+
+static void __exit kmemleak_test_exit(void)
+{
+	struct test_node *elem, *tmp;
+
+	/*
+	 * Remove the list elements without actually freeing the
+	 * memory.
+	 */
+	list_for_each_entry_safe(elem, tmp, &test_list, list)
+		list_del(&elem->list);
+}
+module_exit(kmemleak_test_exit);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

