Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B28C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C2E20936
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598898996;
	bh=KbdafvisIs+jApMBHLOiSVNCmPwaqrU9MtASlIwnq1k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wGJFGQF3Lgg4NPBlyktpv8uyCmYUfj5DD5jdMZSBm/Wq02yA8XzcEctXie5vyAl6g
	 E2t2qXFtGplcwv/U2duob9Q7olT8Dey5e0Ocv7W8MD5RV3C8FYEHzVRz+aHmCQEMFI
	 tgISBcNgi/N/MPS/dSs05a/jmSK9AbsPdvM7n1j0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgHaSgf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgHaSge (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:36:34 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFBA207DA;
        Mon, 31 Aug 2020 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598898993;
        bh=KbdafvisIs+jApMBHLOiSVNCmPwaqrU9MtASlIwnq1k=;
        h=Date:From:To:Subject:From;
        b=b69mFJhC7pmN8WlsX+zvNzUCCw1TNnrCVfOSOmS1Hv2cB4oS/7xUUptrsxLRpf/gp
         9jnZgahXdaKS16Vk/jSFMykyzcNOOF5mDEt5zm1y22XFJLZEeVifqOmjY5Ak84e9JD
         F2U9hsaXrbkGoZSU/jSyyVbmTmHRzmTBtoA3/EdA=
Date:   Mon, 31 Aug 2020 11:36:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        hpa@zytor.com, hch@lst.de, glider@google.com, elver@google.com,
        dvyukov@google.com, corbet@lwn.net, bp@alien8.de, arnd@arndb.de,
        andreyknvl@google.com, akinobu.mita@gmail.com, alinde@google.com
Subject:  + lib-include-linux-add-usercopy-failure-capability.patch
 added to -mm tree
Message-ID: <20200831183631.Cq2nG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, include/linux: add usercopy failure capability
has been added to the -mm tree.  Its filename is
     lib-include-linux-add-usercopy-failure-capability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-include-linux-add-usercopy-failure-capability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-include-linux-add-usercopy-failure-capability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Albert van der Linde <alinde@google.com>
Subject: lib, include/linux: add usercopy failure capability

Patch series "add fault injection to user memory access", v3.

The goal of this series is to improve testing of fault-tolerance in usages
of user memory access functions, by adding support for fault injection.

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
@@ -1332,6 +1332,7 @@
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
@@ -1776,6 +1776,13 @@ config FAIL_PAGE_ALLOC
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
@@ -207,6 +207,7 @@ obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += co
 
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_FAULT_INJECTION_USERCOPY) += fault-inject-usercopy.o
 obj-$(CONFIG_NOTIFIER_ERROR_INJECTION) += notifier-error-inject.o
 obj-$(CONFIG_PM_NOTIFIER_ERROR_INJECT) += pm-notifier-error-inject.o
 obj-$(CONFIG_NETDEV_NOTIFIER_ERROR_INJECT) += netdev-notifier-error-inject.o
_

Patches currently in -mm which might be from alinde@google.com are

lib-include-linux-add-usercopy-failure-capability.patch
lib-uaccess-add-failure-injection-to-usercopy-functions.patch
x86-add-failure-injection-to-get-put-clear_user.patch

