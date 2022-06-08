Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C64C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiFHTAJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 15:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiFHTAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 15:00:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594A233EA7
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 12:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 238E8CE2844
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51819C34116;
        Wed,  8 Jun 2022 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654714797;
        bh=P92R/BmIhScKgHB/Zyy1ILjK1WvuTGBKtWDi+x0KrWw=;
        h=Date:To:From:Subject:From;
        b=0xzmG86yL54jLbbLxjOoL/73Jt3Htjy2/iWTSXRlKqSmFoi0KIAHO54s1UEJ6EI5/
         pmp8zKfmEjNo2HN3PAbrlHKSNyczvxPyyQzC21HGzcX8uVjmfIiYKdS5UUmhdXT4qd
         ScLD0k1aptN6kt3xXByOZHAZHPsVs7un99eHbWuo=
Date:   Wed, 08 Jun 2022 11:59:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xarray-replace-kernelh-with-the-necessary-inclusions.patch removed from -mm tree
Message-Id: <20220608185957.51819C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     xarray-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because an updated version will be merged

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

