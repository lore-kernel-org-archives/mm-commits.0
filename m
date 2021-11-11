Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911F1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71692610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhKKCy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCy2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A17610A2;
        Thu, 11 Nov 2021 02:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599100;
        bh=c2h1Y8G4V6b85WotGnffRL5475LADGkT7zLLbUwL0eU=;
        h=Date:From:To:Subject:From;
        b=zey5RRRy4mX/wsdc4a4EpZEex3mBWRZ0Z2qh6ou0F33oQDaFD0I4FaDvZd+q8l3ch
         0LcMCuN2Hg8+Xl7HJijnumGXAJlbv2e4sjQtWwzVTJdGoILEf0nVVXetqX/KUbaB5T
         Ihneo/YaI6B0ZRcJf6VGAs7UTd7A12xISZXOZCCI=
Date:   Wed, 10 Nov 2021 18:51:40 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 delay-replace-kernelh-with-the-necessary-inclusions.patch removed from -mm
 tree
Message-ID: <20211111025140.v-kVVI-hn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/delay.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     delay-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/delay.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

[akpm@linux-foundation.org: cxd2880_common.h needs bits.h for GENMASK()]
[andriy.shevchenko@linux.intel.com: delay.h: fix for removed kernel.h]
  Link: https://lkml.kernel.org/r/20211028170143.56523-1-andriy.shevchenko@linux.intel.com
[akpm@linux-foundation.org: include/linux/fwnode.h needs bits.h for BIT()]
Link: https://lkml.kernel.org/r/20211027150324.79827-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/lib/delay.c                               |    4 ++++
 arch/s390/include/asm/facility.h                     |    4 ++++
 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h |    1 +
 include/linux/delay.h                                |    2 +-
 include/linux/fwnode.h                               |    1 +
 5 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/riscv/lib/delay.c~delay-replace-kernelh-with-the-necessary-inclusions
+++ a/arch/riscv/lib/delay.c
@@ -4,10 +4,14 @@
  */
 
 #include <linux/delay.h>
+#include <linux/math.h>
 #include <linux/param.h>
 #include <linux/timex.h>
+#include <linux/types.h>
 #include <linux/export.h>
 
+#include <asm/processor.h>
+
 /*
  * This is copies from arch/arm/include/asm/delay.h
  *
--- a/arch/s390/include/asm/facility.h~delay-replace-kernelh-with-the-necessary-inclusions
+++ a/arch/s390/include/asm/facility.h
@@ -9,8 +9,12 @@
 #define __ASM_FACILITY_H
 
 #include <asm/facility-defs.h>
+
+#include <linux/minmax.h>
 #include <linux/string.h>
+#include <linux/types.h>
 #include <linux/preempt.h>
+
 #include <asm/lowcore.h>
 
 #define MAX_FACILITY_BIT (sizeof(stfle_fac_list) * 8)
--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h~delay-replace-kernelh-with-the-necessary-inclusions
+++ a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/bits.h>
 #include <linux/string.h>
 
 int cxd2880_convert2s_complement(u32 value, u32 bitlen);
--- a/include/linux/delay.h~delay-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/delay.h
@@ -19,7 +19,7 @@
  *   https://lists.openwall.net/linux-kernel/2011/01/09/56
  */
 
-#include <linux/kernel.h>
+#include <linux/math.h>
 
 extern unsigned long loops_per_jiffy;
 
--- a/include/linux/fwnode.h~delay-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/fwnode.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/bits.h>
 #include <linux/err.h>
 
 struct fwnode_operations;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


