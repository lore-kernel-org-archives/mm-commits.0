Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED589C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D628461207
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhKICPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:15:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC51461181;
        Tue,  9 Nov 2021 02:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423976;
        bh=u4VcdmZtzCyjj45kDy+IEdkvZo+F4A/46T5pWTRVXyk=;
        h=Date:From:To:Subject:From;
        b=2W8SLB72x9brOLvBIFX4JsPA6Hu+dq7Mr/sRz0Zfk4Ql+WOub8DbdOUszSx3Xx3vG
         i618iAAkzdVrfMDoU+UjquC2VxQ/T1sHOBvxAh/opeu+EBAFlwy80C048zg3FHPIN0
         Ch47xiGmBAVebZnlO353yscgjfzODSeYTWwTT2HI=
Date:   Mon, 08 Nov 2021 18:12:56 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch removed
 from -mm tree
Message-ID: <20211109021256.pfcCmJ68M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay.h: fix for removed kernel.h
has been removed from the -mm tree.  Its filename was
     delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch

This patch was dropped because it was folded into delay-replace-kernelh-with-the-necessary-inclusions.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: delay.h: fix for removed kernel.h

To be folded to the commit 0d280a9fbbd9 ("include/linux/delay.h:
replace kernel.h with the necessary inclusions")

Link: https://lkml.kernel.org/r/20211028170143.56523-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/lib/delay.c           |    4 ++++
 arch/s390/include/asm/facility.h |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/riscv/lib/delay.c~delay-replace-kernelh-with-the-necessary-inclusions-fix-2
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
--- a/arch/s390/include/asm/facility.h~delay-replace-kernelh-with-the-necessary-inclusions-fix-2
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
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
kernelh-split-out-container_of-and-typeof_member-macros.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
list-replace-kernelh-with-the-necessary-inclusions.patch
llist-replace-kernelh-with-the-necessary-inclusions.patch
plist-replace-kernelh-with-the-necessary-inclusions.patch
media-entity-replace-kernelh-with-the-necessary-inclusions.patch
delay-replace-kernelh-with-the-necessary-inclusions.patch
sbitmap-replace-kernelh-with-the-necessary-inclusions.patch
radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
seq_file-move-seq_escape-to-a-header.patch

