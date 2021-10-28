Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8F4C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD5D610FD
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJ1T1N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhJ1T1L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA69B610CA;
        Thu, 28 Oct 2021 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635449084;
        bh=8A+KlGkR/KtTFy6SqBOD579YVEQSEnSv7ot/p+y/CNI=;
        h=Date:From:To:Subject:From;
        b=GfvStZDxPDIeVlFGq20l6qy1SWtP2/wzoumwKormIzr1Gv6GY8vxfnQXf/PEaUNdn
         XS2HYwlN49yKMmLhs5RswzDrVOgRxanjhiuME2OnckGcEAykfJZf0G2IsQrxsM/d1c
         LicDvWXKyTCWehIX4D8V4jYhVkV1MVet4w/eQ2q4=
Date:   Thu, 28 Oct 2021 12:24:43 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  + kernelh-split-out-instruction-pointer-accessors.patch
 added to -mm tree
Message-ID: <20211028192443.ScBAdmcmI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out instruction pointer accessors
has been added to the -mm tree.  Its filename is
     kernelh-split-out-instruction-pointer-accessors.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-instruction-pointer-accessors.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-instruction-pointer-accessors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel.h: split out instruction pointer accessors

bottom_half.h needs _THIS_IP_ to be standalone, so split that and _RET_IP_
out from kernel.h into the new instruction_pointer.h.  kernel.h directly
needs them, so include it there and replace the include of kernel.h with
this new file in bottom_half.h.

Link: https://lkml.kernel.org/r/20211028161248.45232-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bottom_half.h         |    2 +-
 include/linux/instruction_pointer.h |    8 ++++++++
 include/linux/kernel.h              |    4 +---
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/include/linux/bottom_half.h~kernelh-split-out-instruction-pointer-accessors
+++ a/include/linux/bottom_half.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
-#include <linux/kernel.h>
+#include <linux/instruction_pointer.h>
 #include <linux/preempt.h>
 
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_TRACE_IRQFLAGS)
--- /dev/null
+++ a/include/linux/instruction_pointer.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_INSTRUCTION_POINTER_H
+#define _LINUX_INSTRUCTION_POINTER_H
+
+#define _RET_IP_		(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+
+#endif /* _LINUX_INSTRUCTION_POINTER_H */
--- a/include/linux/kernel.h~kernelh-split-out-instruction-pointer-accessors
+++ a/include/linux/kernel.h
@@ -20,6 +20,7 @@
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <linux/static_call_types.h>
+#include <linux/instruction_pointer.h>
 #include <asm/byteorder.h>
 
 #include <uapi/linux/kernel.h>
@@ -53,9 +54,6 @@
 }					\
 )
 
-#define _RET_IP_		(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
-
 /**
  * upper_32_bits - return bits 32-63 of a number
  * @n: the number we're accessing
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch
kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch
kernelh-split-out-instruction-pointer-accessors.patch

