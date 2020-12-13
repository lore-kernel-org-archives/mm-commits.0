Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60898C4361B
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F7823139
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgLMGGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Dec 2020 01:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbgLMGGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Dec 2020 01:06:02 -0500
Date:   Sat, 12 Dec 2020 22:05:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607839522;
        bh=spYkvCljEXGZyP/fQGcpgtggkv5GCXq1BrlraJ9Espo=;
        h=From:To:Subject:From;
        b=X//bX633ab/sduD2RT3YAuJnwB/yRT7P5Lj4VM7o+fNs4BMchBYU5J5hcUBy0TB9e
         IhTsI4Izp2hsJ7zz9Z5BCzIYtJ/yZ4aAh6WmGC8WkQeO2Ueb8A/mgXDyslSaUTEZ3X
         91WRXPIvxIXlg03GBdRtNI0ZUQN1CPJFaR1z5jEk=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject:  [merged] elfcore-fix-building-with-clang.patch removed
 from -mm tree
Message-ID: <20201213060521.KLgUTzOy4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: elfcore: fix building with clang
has been removed from the -mm tree.  Its filename was
     elfcore-fix-building-with-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: elfcore: fix building with clang

kernel/elfcore.c only contains weak symbols, which triggers a bug with
clang in combination with recordmcount:

Cannot find symbol for section 2: .text.
kernel/elfcore.o: failed

Move the empty stubs into linux/elfcore.h as inline functions.  As only
two architectures use these, just use the architecture specific Kconfig
symbols to key off the declaration.

Link: https://lkml.kernel.org/r/20201204165742.3815221-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore.h |   22 ++++++++++++++++++++++
 kernel/Makefile         |    1 -
 kernel/elfcore.c        |   26 --------------------------
 3 files changed, 22 insertions(+), 27 deletions(-)

--- a/include/linux/elfcore.h~elfcore-fix-building-with-clang
+++ a/include/linux/elfcore.h
@@ -104,6 +104,7 @@ static inline int elf_core_copy_task_fpr
 #endif
 }
 
+#if defined(CONFIG_UM) || defined(CONFIG_IA64)
 /*
  * These functions parameterize elf_core_dump in fs/binfmt_elf.c to write out
  * extra segments containing the gate DSO contents.  Dumping its
@@ -118,5 +119,26 @@ elf_core_write_extra_phdrs(struct coredu
 extern int
 elf_core_write_extra_data(struct coredump_params *cprm);
 extern size_t elf_core_extra_data_size(void);
+#else
+static inline Elf_Half elf_core_extra_phdrs(void)
+{
+	return 0;
+}
+
+static inline int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
+{
+	return 1;
+}
+
+static inline int elf_core_write_extra_data(struct coredump_params *cprm)
+{
+	return 1;
+}
+
+static inline size_t elf_core_extra_data_size(void)
+{
+	return 0;
+}
+#endif
 
 #endif /* _LINUX_ELFCORE_H */
--- a/kernel/elfcore.c
+++ /dev/null
@@ -1,26 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/elf.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/binfmts.h>
-#include <linux/elfcore.h>
-
-Elf_Half __weak elf_core_extra_phdrs(void)
-{
-	return 0;
-}
-
-int __weak elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
-{
-	return 1;
-}
-
-int __weak elf_core_write_extra_data(struct coredump_params *cprm)
-{
-	return 1;
-}
-
-size_t __weak elf_core_extra_data_size(void)
-{
-	return 0;
-}
--- a/kernel/Makefile~elfcore-fix-building-with-clang
+++ a/kernel/Makefile
@@ -97,7 +97,6 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_ELFCORE) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_TRACE_CLOCK) += trace/
_

Patches currently in -mm which might be from arnd@arndb.de are


