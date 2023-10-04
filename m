Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6392AE936E3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbjJDUZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbjJDUY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F04410DF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D4C433C9;
        Wed,  4 Oct 2023 20:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451033;
        bh=qn7Q73qFY0eKhICT+mTVOqJ07xPsG8QqnhZXLzKab4k=;
        h=Date:To:From:Subject:From;
        b=X7cP9zNOKrnj96gM8wmj1eQeEpf1+c0ELOaaNsLAHaqPwxZ3Ny8x4KInt1eF9elya
         mDYvttku0UWt7nOQoLCnDvLl/39qcy7aG5m8XZj9Tf8HdRzxd/LYSq0iNpytU9J5cy
         1roIEO+He3qgoJ813nsgzvHbaLk8rwl+obp8SypI=
Date:   Wed, 04 Oct 2023 13:23:51 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        herve.codina@bootlin.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmax-fix-header-inclusions.patch removed from -mm tree
Message-Id: <20231004202353.569D4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: minmax: fix header inclusions
has been removed from the -mm tree.  Its filename was
     minmax-fix-header-inclusions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: minmax: fix header inclusions
Date: Tue, 12 Sep 2023 12:23:55 +0300

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/minmax.h~minmax-fix-header-inclusions
+++ a/include/linux/minmax.h
@@ -2,7 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
-#include <linux/compiler_types.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


