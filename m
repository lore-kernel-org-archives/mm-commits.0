Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529B8C4707F
	for <mm-commits@archiver.kernel.org>; Fri, 28 May 2021 02:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0A8613AF
	for <mm-commits@archiver.kernel.org>; Fri, 28 May 2021 02:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhE1CWj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 May 2021 22:22:39 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2326 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhE1CWj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 May 2021 22:22:39 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FrpG35pd4z1BFsP;
        Fri, 28 May 2021 10:16:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 10:21:03 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <sh_def@163.com>, <catalin.marinas@arm.com>
CC:     <mm-commits@vger.kernel.org>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2] mm,kmemleak-test: add the dependency on CONFIG_SAMPLES
Date:   Fri, 28 May 2021 10:16:30 +0800
Message-ID: <1622168190-16160-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

As kmemleak-test.c is moved to samples dir, it is not compiled if just
setting CONFIG_DEBUG_KMEMLEAK_TEST as module and enabling
CONFIG_DEBUG_KMEMLEAK.
So move the DEBUG_KMEMLEAK_TEST option to samples dir as well and rename 
it to SAMPLE_KMEMLEAK_TEST. And also replace DEBUG_KMEMLEAK_TEST with
SAMPLE_KMEMLEAK_TEST in some other places.

Fixes: 1abbef4f5172 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 Documentation/dev-tools/kmemleak.rst | 2 +-
 lib/Kconfig.debug                    | 8 --------
 samples/Kconfig                      | 8 ++++++++
 samples/Makefile                     | 2 +-
 samples/kmemleak/Makefile            | 2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index 1c935f4..997b35d 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -228,7 +228,7 @@ Testing with kmemleak-test
 --------------------------
 
 To check if you have all set up to use kmemleak, you can use the kmemleak-test
-module, a module that deliberately leaks memory. Set CONFIG_DEBUG_KMEMLEAK_TEST
+module, a module that deliberately leaks memory. Set CONFIG_SAMPLE_KMEMLEAK_TEST
 as module (it can't be used as built-in) and boot the kernel with kmemleak
 enabled. Load the module and perform a scan with::
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e88287e..b40931e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -723,14 +723,6 @@ config DEBUG_KMEMLEAK_MEM_POOL_SIZE
 	  fully initialised, this memory pool acts as an emergency one
 	  if slab allocations fail.
 
-config DEBUG_KMEMLEAK_TEST
-	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK && m
-	help
-	  This option enables a module that explicitly leaks memory.
-
-	  If unsure, say N.
-
 config DEBUG_KMEMLEAK_DEFAULT_OFF
 	bool "Default kmemleak to off"
 	depends on DEBUG_KMEMLEAK
diff --git a/samples/Kconfig b/samples/Kconfig
index eaa06c0..3ce77c7 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -223,6 +223,14 @@ config SAMPLE_WATCH_QUEUE
 	  Build example userspace program to use the new mount_notify(),
 	  sb_notify() syscalls and the KEYCTL_WATCH_KEY keyctl() function.
 
+config SAMPLE_KMEMLEAK_TEST
+	tristate "Simple test for the kernel memory leak detector"
+	depends on DEBUG_KMEMLEAK && m
+	help
+	  This option enables a module that explicitly leaks memory.
+
+	  If unsure, say N.
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 291663e..ffb404b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -29,5 +29,5 @@ subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
 obj-$(CONFIG_SAMPLE_INTEL_MEI)		+= mei/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+= kmemleak/
+obj-$(CONFIG_SAMPLE_KMEMLEAK_TEST)	+= kmemleak/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
diff --git a/samples/kmemleak/Makefile b/samples/kmemleak/Makefile
index 16b6132..ce10176 100644
--- a/samples/kmemleak/Makefile
+++ b/samples/kmemleak/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_SAMPLE_KMEMLEAK_TEST) += kmemleak-test.o
-- 
2.8.1

