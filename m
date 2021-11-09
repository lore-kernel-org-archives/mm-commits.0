Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CDCC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121E1610E9
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhKICfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C7360F9B;
        Tue,  9 Nov 2021 02:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425153;
        bh=weMsctRUWlLExHUnba5hZ4CCc0K91Fs1ZbQZfPKdaYE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D/pmRpp9ZIkx/sbLQBu8b7rvd8WP8d1MiqgH3Ys4y9Zr0jZSg0Tci4p7aBROheS+j
         swMnenHiWqkG4Ok1rtAZvw2s8hzdXzRr7iMA0fMSegM7cyvXErag4CPlhb6ad1Lftz
         0YmEtUAPNrY+717UftnhtvIBUTJnjAi+CzNWlSNU=
Date:   Mon, 08 Nov 2021 18:32:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 21/87] include/linux/delay.h: replace kernel.h
 with the necessary inclusions
Message-ID: <20211109023232.SqfSJxVsC%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
