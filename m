Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE3C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB24F21D81
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632936;
	bh=+mylflqBDMgSSv+mM1vRwxPpAWzbnptAlpg64pr3BX4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bx19nlI2lZAPlSh3QEkoF08P4WCoxY5C1qt+PAlwY4jFNcYYS1BFWlcqAe+52t26V
	 4WEr1Lwp7QsClA1IIK2bOQbm/37mXwPdx8F0NZf4Mmtz3ZsFqr+2zVWaKyNBYHrBNe
	 aqOCG680g26M1d4EKZlH+wMNYKPfjXM0pOaUMhoY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgJMXs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D799922202;
        Tue, 13 Oct 2020 23:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632934;
        bh=+mylflqBDMgSSv+mM1vRwxPpAWzbnptAlpg64pr3BX4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fPS5tmobE6ycnOwIF9m8Mvpg4NqQLic+EsIVLaUoMy9Vwr7WLfBfUhfqsbVWPop5B
         xIZilJZe+6JLM5sfvtD5oXwtVOkNopbwfPqCD8fZ1u9KPykDxYtUV3M4ScstCKgWGE
         bncOT7YZ64D7KSqu0kD1GbsEBgFuVbVAbBnIdPR4=
Date:   Tue, 13 Oct 2020 16:48:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com, corbet@lwn.net,
        davem@davemloft.net, dhowells@redhat.com, divya.indi@oracle.com,
        jpoimboe@redhat.com, linux-mm@kvack.org, mchehab+huawei@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        robh@kernel.org, rostedt@goodmis.org, sam@ravnborg.org,
        sh_def@163.com, tomas.winkler@intel.com,
        torvalds@linux-foundation.org, yamada.masahiro@socionext.com
Subject:  [patch 025/181] mm,kmemleak-test.c: move kmemleak-test.c
 to samples dir
Message-ID: <20201013234853.gIPhNHGaa%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm,kmemleak-test.c: move kmemleak-test.c to samples dir

kmemleak-test.c is just a kmemleak test module, which also can not be used
as a built-in kernel module.  Thus, i think it may should not be in mm
dir, and move the kmemleak-test.c to samples/kmemleak/kmemleak-test.c. 
Fix the spelling of built-in by the way.

Link: https://lkml.kernel.org/r/20200925183729.GA172837@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Divya Indi <divya.indi@oracle.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst |    2 
 MAINTAINERS                          |    2 
 mm/Makefile                          |    1 
 mm/kmemleak-test.c                   |   99 -------------------------
 samples/Makefile                     |    1 
 samples/kmemleak/Makefile            |    3 
 samples/kmemleak/kmemleak-test.c     |   99 +++++++++++++++++++++++++
 7 files changed, 105 insertions(+), 102 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~mmkmemleak-testc-move-kmemleak-testc-to-samples-dir
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -229,7 +229,7 @@ Testing with kmemleak-test
 
 To check if you have all set up to use kmemleak, you can use the kmemleak-test
 module, a module that deliberately leaks memory. Set CONFIG_DEBUG_KMEMLEAK_TEST
-as module (it can't be used as bult-in) and boot the kernel with kmemleak
+as module (it can't be used as built-in) and boot the kernel with kmemleak
 enabled. Load the module and perform a scan with::
 
         # modprobe kmemleak-test
--- a/MAINTAINERS~mmkmemleak-testc-move-kmemleak-testc-to-samples-dir
+++ a/MAINTAINERS
@@ -9727,8 +9727,8 @@ M:	Catalin Marinas <catalin.marinas@arm.
 S:	Maintained
 F:	Documentation/dev-tools/kmemleak.rst
 F:	include/linux/kmemleak.h
-F:	mm/kmemleak-test.c
 F:	mm/kmemleak.c
+F:	samples/kmemleak/kmemleak-test.c
 
 KMOD KERNEL MODULE LOADER - USERMODE HELPER
 M:	Luis Chamberlain <mcgrof@kernel.org>
--- a/mm/kmemleak-test.c
+++ /dev/null
@@ -1,99 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * mm/kmemleak-test.c
- *
- * Copyright (C) 2008 ARM Limited
- * Written by Catalin Marinas <catalin.marinas@arm.com>
- */
-
-#define pr_fmt(fmt) "kmemleak: " fmt
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/list.h>
-#include <linux/percpu.h>
-#include <linux/fdtable.h>
-
-#include <linux/kmemleak.h>
-
-struct test_node {
-	long header[25];
-	struct list_head list;
-	long footer[25];
-};
-
-static LIST_HEAD(test_list);
-static DEFINE_PER_CPU(void *, kmemleak_test_pointer);
-
-/*
- * Some very simple testing. This function needs to be extended for
- * proper testing.
- */
-static int __init kmemleak_test_init(void)
-{
-	struct test_node *elem;
-	int i;
-
-	pr_info("Kmemleak testing\n");
-
-	/* make some orphan objects */
-	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-#ifndef CONFIG_MODULES
-	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
-		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
-		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-#endif
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("vmalloc(64) = %p\n", vmalloc(64));
-
-	/*
-	 * Add elements to a list. They should only appear as orphan
-	 * after the module is removed.
-	 */
-	for (i = 0; i < 10; i++) {
-		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
-		if (!elem)
-			return -ENOMEM;
-		INIT_LIST_HEAD(&elem->list);
-		list_add_tail(&elem->list, &test_list);
-	}
-
-	for_each_possible_cpu(i) {
-		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
-		pr_info("kmalloc(129) = %p\n",
-			per_cpu(kmemleak_test_pointer, i));
-	}
-
-	return 0;
-}
-module_init(kmemleak_test_init);
-
-static void __exit kmemleak_test_exit(void)
-{
-	struct test_node *elem, *tmp;
-
-	/*
-	 * Remove the list elements without actually freeing the
-	 * memory.
-	 */
-	list_for_each_entry_safe(elem, tmp, &test_list, list)
-		list_del(&elem->list);
-}
-module_exit(kmemleak_test_exit);
-
-MODULE_LICENSE("GPL");
--- a/mm/Makefile~mmkmemleak-testc-move-kmemleak-testc-to-samples-dir
+++ a/mm/Makefile
@@ -94,7 +94,6 @@ obj-$(CONFIG_GUP_BENCHMARK) += gup_bench
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_DEBUG_RODATA_TEST) += rodata_test.o
 obj-$(CONFIG_DEBUG_VM_PGTABLE) += debug_vm_pgtable.o
 obj-$(CONFIG_PAGE_OWNER) += page_owner.o
--- /dev/null
+++ a/samples/kmemleak/kmemleak-test.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * samples/kmemleak/kmemleak-test.c
+ *
+ * Copyright (C) 2008 ARM Limited
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
+ */
+
+#define pr_fmt(fmt) "kmemleak: " fmt
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
+static DEFINE_PER_CPU(void *, kmemleak_test_pointer);
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
+	pr_info("Kmemleak testing\n");
+
+	/* make some orphan objects */
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+#ifndef CONFIG_MODULES
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+#endif
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+
+	/*
+	 * Add elements to a list. They should only appear as orphan
+	 * after the module is removed.
+	 */
+	for (i = 0; i < 10; i++) {
+		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
+		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
+		if (!elem)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&elem->list);
+		list_add_tail(&elem->list, &test_list);
+	}
+
+	for_each_possible_cpu(i) {
+		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
+		pr_info("kmalloc(129) = %p\n",
+			per_cpu(kmemleak_test_pointer, i));
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
--- /dev/null
+++ a/samples/kmemleak/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
--- a/samples/Makefile~mmkmemleak-testc-move-kmemleak-testc-to-samples-dir
+++ a/samples/Makefile
@@ -28,3 +28,4 @@ subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
 obj-$(CONFIG_SAMPLE_INTEL_MEI)		+= mei/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
+obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+= kmemleak/
_
