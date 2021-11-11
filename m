Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B453CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B801610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhKKCyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCya (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7332160F26;
        Thu, 11 Nov 2021 02:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599102;
        bh=uehkG0JjeQxi7IaWrvBPGPIZST0uiZylIifnaex7XI0=;
        h=Date:From:To:Subject:From;
        b=svTSE+3Wm61URTatATw761EEN0rb5W4sqNqsGHGl1XQEWbX8gqDGXpjkObpeuwCfQ
         31djTYlk4b1izMDyr+DSPYoJ4zH5faCzIORu33ODzSrKeFKIYtr0Ku640DLyt6kQh7
         HjJdsm8oGkbkXm8MujyKmKArk6fVbYdG+0yRMA2o=
Date:   Wed, 10 Nov 2021 18:51:42 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 sbitmap-replace-kernelh-with-the-necessary-inclusions.patch removed from
 -mm tree
Message-ID: <20211111025142.R32i6a-Kx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sbitmap.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     sbitmap-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/sbitmap.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211027150437.79921-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sbitmap.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/sbitmap.h~sbitmap-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/sbitmap.h
@@ -9,8 +9,17 @@
 #ifndef __LINUX_SCALE_BITMAP_H
 #define __LINUX_SCALE_BITMAP_H
 
-#include <linux/kernel.h>
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/list.h>
+#include <linux/log2.h>
+#include <linux/minmax.h>
+#include <linux/percpu.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/types.h>
+#include <linux/wait.h>
 
 struct seq_file;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


