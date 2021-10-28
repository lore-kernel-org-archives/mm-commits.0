Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE9DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 453AF610FC
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJ1TZ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhJ1TZ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:25:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CD6610CA;
        Thu, 28 Oct 2021 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635449011;
        bh=odYtGBzn25rnqKG8RjVuEaNc2rEU3d4VTC24fVBYZVM=;
        h=Date:From:To:Subject:From;
        b=YYkllcxYr4iuDEt0ZT/BYDy67q169jAGRaPC3ZMtMeDH12GCClaqMGAspU98I9T0g
         VCOz/obh/Dgy5ra8/WSt4vdXE/otUdV03leItEvg93kcgmCyPjSPsxPtz3yVDGhLGS
         GJLdzUnBQfWKDiECV2Vb4u8MalCCnocQuSeVE90o=
Date:   Thu, 28 Oct 2021 12:23:31 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch added to
 -mm tree
Message-ID: <20211028192331.TXDKRLEIf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay.h: fix for removed kernel.h
has been added to the -mm tree.  Its filename is
     delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch
sbitmap-replace-kernelh-with-the-necessary-inclusions.patch
radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
seq_file-move-seq_escape-to-a-header.patch

