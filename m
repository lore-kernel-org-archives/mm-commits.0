Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06418C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A96F420897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816645;
	bh=6fkxcaizcryYOzgYu2QfAz+fupdQEocjCZMP/9GD1N0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Lt+n68fNXkTtd9AcLrritf/nMsIPAE9qfJGS9qHVtnBV/GIC9DfuNp3uDWEmVyrcG
	 K0styqt4qF9PGGkC7ybv2JdlHW/kwRSSV6DLI/cPEbvb1ThYgRuLE3aWh1RjbTOssi
	 7mpClD0Zing2l8S0OMOo9uRPhBea5KkZms/3MSLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404402AbgJPCup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404127AbgJPCup (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CC12087D;
        Fri, 16 Oct 2020 02:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816644;
        bh=6fkxcaizcryYOzgYu2QfAz+fupdQEocjCZMP/9GD1N0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OLAzP5IHGCvHAZDOhISURBxS5Fk1XkpU+dUziisldBoCc0q5NlYTij/Uh43EPv+3i
         /XEtMUYT+PFzpAfqghX6wFJOp7ZVyANN3gP24tGARpL9Q3akkpAq1zN0Ymqkaluqhe
         D/aqSpaq7qR0c4XMf3aia7AGkXvj6nPbbbULoFSU=
Date:   Thu, 15 Oct 2020 19:50:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akinobu.mita@gmail.com, akpm@linux-foundation.org,
        alinde@google.com, andreyknvl@google.com, arnd@arndb.de,
        bp@alien8.de, corbet@lwn.net, dvyukov@google.com, elver@google.com,
        glider@google.com, hch@lst.de, hpa@zytor.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 155/156] lib, include/linux: add usercopy failure
 capability
Message-ID: <20201016025042.udpLQq8wo%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Albert van der Linde <alinde@google.com>
Subject: lib, include/linux: add usercopy failure capability

Patch series "add fault injection to user memory access", v3.

The goal of this series is to improve testing of fault-tolerance in usages
of user memory access functions, by adding support for fault injection.

syzkaller/syzbot are using the existing fault injection modes and will use
this particular feature also.

The first patch adds failure injection capability for usercopy functions. 
The second changes usercopy functions to use this new failure capability
(copy_from_user, ...).  The third patch adds get/put/clear_user failures
to x86.


This patch (of 3):

Add a failure injection capability to improve testing of fault-tolerance
in usages of user memory access functions.

Add CONFIG_FAULT_INJECTION_USERCOPY to enable faults in usercopy
functions.  The should_fail_usercopy function is to be called by these
functions (copy_from_user, get_user, ...) in order to fail or not.

Link: http://lkml.kernel.org/r/20200831171733.955393-1-alinde@google.com
Link: http://lkml.kernel.org/r/20200831171733.955393-2-alinde@google.com
Signed-off-by: Albert van der Linde <alinde@google.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt   |    1 
 Documentation/fault-injection/fault-injection.rst |    7 +-
 include/linux/fault-inject-usercopy.h             |   22 ++++++
 lib/Kconfig.debug                                 |    7 ++
 lib/Makefile                                      |    1 
 lib/fault-inject-usercopy.c                       |   39 ++++++++++++
 6 files changed, 76 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~lib-include-linux-add-usercopy-failure-capability
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1343,6 +1343,7 @@
 			current integrity status.
 
 	failslab=
+	fail_usercopy=
 	fail_page_alloc=
 	fail_make_request=[KNL]
 			General fault injection mechanism.
--- a/Documentation/fault-injection/fault-injection.rst~lib-include-linux-add-usercopy-failure-capability
+++ a/Documentation/fault-injection/fault-injection.rst
@@ -16,6 +16,10 @@ Available fault injection capabilities
 
   injects page allocation failures. (alloc_pages(), get_free_pages(), ...)
 
+- fail_usercopy
+
+  injects failures in user memory access functions. (copy_from_user(), get_user(), ...)
+
 - fail_futex
 
   injects futex deadlock and uaddr fault errors.
@@ -177,6 +181,7 @@ use the boot option::
 
 	failslab=
 	fail_page_alloc=
+	fail_usercopy=
 	fail_make_request=
 	fail_futex=
 	mmc_core.fail_request=<interval>,<probability>,<space>,<times>
@@ -222,7 +227,7 @@ How to add new fault injection capabilit
 
 - debugfs entries
 
-  failslab, fail_page_alloc, and fail_make_request use this way.
+  failslab, fail_page_alloc, fail_usercopy, and fail_make_request use this way.
   Helper functions:
 
 	fault_create_debugfs_attr(name, parent, attr);
--- /dev/null
+++ a/include/linux/fault-inject-usercopy.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_FAULT_INJECT_USERCOPY_H__
+#define __LINUX_FAULT_INJECT_USERCOPY_H__
+
+/*
+ * This header provides a wrapper for injecting failures to user space memory
+ * access functions.
+ */
+
+#include <linux/types.h>
+
+#ifdef CONFIG_FAULT_INJECTION_USERCOPY
+
+bool should_fail_usercopy(void);
+
+#else
+
+static inline bool should_fail_usercopy(void) { return false; }
+
+#endif /* CONFIG_FAULT_INJECTION_USERCOPY */
+
+#endif /* __LINUX_FAULT_INJECT_USERCOPY_H__ */
--- /dev/null
+++ a/lib/fault-inject-usercopy.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/fault-inject.h>
+#include <linux/fault-inject-usercopy.h>
+
+static struct {
+	struct fault_attr attr;
+} fail_usercopy = {
+	.attr = FAULT_ATTR_INITIALIZER,
+};
+
+static int __init setup_fail_usercopy(char *str)
+{
+	return setup_fault_attr(&fail_usercopy.attr, str);
+}
+__setup("fail_usercopy=", setup_fail_usercopy);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init fail_usercopy_debugfs(void)
+{
+	struct dentry *dir;
+
+	dir = fault_create_debugfs_attr("fail_usercopy", NULL,
+					&fail_usercopy.attr);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	return 0;
+}
+
+late_initcall(fail_usercopy_debugfs);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+bool should_fail_usercopy(void)
+{
+	return should_fail(&fail_usercopy.attr, 1);
+}
+EXPORT_SYMBOL_GPL(should_fail_usercopy);
--- a/lib/Kconfig.debug~lib-include-linux-add-usercopy-failure-capability
+++ a/lib/Kconfig.debug
@@ -1768,6 +1768,13 @@ config FAIL_PAGE_ALLOC
 	help
 	  Provide fault-injection capability for alloc_pages().
 
+config FAULT_INJECTION_USERCOPY
+	bool "Fault injection capability for usercopy functions"
+	depends on FAULT_INJECTION
+	help
+	  Provides fault-injection capability to inject failures
+	  in usercopy functions (copy_from_user(), get_user(), ...).
+
 config FAIL_MAKE_REQUEST
 	bool "Fault-injection capability for disk IO"
 	depends on FAULT_INJECTION && BLOCK
--- a/lib/Makefile~lib-include-linux-add-usercopy-failure-capability
+++ a/lib/Makefile
@@ -210,6 +210,7 @@ obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += co
 
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_FAULT_INJECTION_USERCOPY) += fault-inject-usercopy.o
 obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 obj-$(CONFIG_NETDEV_NOTIFIER_ERROR_INJECT) += netdev-notifier-error-inject.o
_
