Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97252C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDBD610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbhKKCyf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhKKCye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7992E60F26;
        Thu, 11 Nov 2021 02:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599106;
        bh=PE4w675iifC4mvmbQFPGP4Xl5Ost1zOqTcyfO7hUph8=;
        h=Date:From:To:Subject:From;
        b=wVRuQXArEvPC4+a5dz0vKSBvmAPhEZ8iVRBzuGK4XGIn4naJsBfR38gjDeBB+6uCO
         1VqIFaTXne8/OIGBDeXl+dItCGNMcIIvyzXzMkir20OO2B+k5QWvVldor+tXDL6Pq7
         AYkwWlV9eJum/sX4IlseFE6p6Z2zcBOiJZ0np3XE=
Date:   Wed, 10 Nov 2021 18:51:46 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
 removed from -mm tree
Message-ID: <20211111025146.PRr0ztmHJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/generic-radix-tree.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/generic-radix-tree.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

[akpm@linux-foundation.org: include math.h for round_up()]
Link: https://lkml.kernel.org/r/20211027150548.80042-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/generic-radix-tree.h~generic-radix-tree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/generic-radix-tree.h
@@ -38,8 +38,9 @@
 
 #include <asm/page.h>
 #include <linux/bug.h>
-#include <linux/kernel.h>
 #include <linux/log2.h>
+#include <linux/math.h>
+#include <linux/types.h>
 
 struct genradix_root;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


