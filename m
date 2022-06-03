Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372F4CCA473
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347325AbiFCShg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347003AbiFCShH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:37:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B4F1E3D8
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B426061952
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15159C385A9;
        Fri,  3 Jun 2022 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654281151;
        bh=vXbi+xNBoijLq8YzifMFCHEgpVo6u+HLa6lTq9jDW+A=;
        h=Date:To:From:Subject:From;
        b=d+xSbpkADPXiy+VCTsb+sO6tJV3yLTFeUwWCF1/x9zn0g6PMYtfVw7saQOe5C89Ct
         F8s5aD4WGcGPNtgLGrjjC+UiSlgWIPi6MQE2af2apgCTW92kGVgcyYmanBWeR4ycZy
         A9PxnADLuB2ETAejzAkgHUkOSkr4UlEBlAiPIpds=
Date:   Fri, 03 Jun 2022 11:32:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-replace-kernelh-with-the-necessary-inclusions.patch added to mm-nonmm-unstable branch
Message-Id: <20220603183231.15159C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-replace-kernelh-with-the-necessary-inclusions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-replace-kernelh-with-the-necessary-inclusions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
Date: Fri, 3 Jun 2022 20:11:53 +0300

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/xarray.h~xarray-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/xarray.h
@@ -12,13 +12,18 @@
 #include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/kconfig.h>
-#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/lockdep.h>
+#include <linux/math.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
+#include <asm/bitsperlong.h>
+
 /*
  * The bottom two bits of the entry determine how the XArray interprets
  * the contents:
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

rbtree-replace-kernelh-with-the-necessary-inclusions.patch
xarray-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-move-sysfs-related-macro-to-sysfsh.patch

