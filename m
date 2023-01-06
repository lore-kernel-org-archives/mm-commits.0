Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC8AC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjAFCnR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjAFCnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:43:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C00B671B3
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1DE8B81B32
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66067C433D2;
        Fri,  6 Jan 2023 02:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672972989;
        bh=353pFthTlWZGls1EHC7ZIrznyUGSVMt9P3pGBtYkSNg=;
        h=Date:To:From:Subject:From;
        b=g4zzAt2fQcpuyfRsCGCEGgR5JwXbJyZNdA0bRBVZR7Ds9/gHu2zmPUCUt4UbqFsZl
         RZRFCjlv2tRYlxvY6mSj7Bzk1DhSeCt3rkvGw8wMiZs/nqQB4RJa/YR0lHhefOYYSN
         8JUFJZc7xa4qL/TxeFGl9JpJrwVtHahIC98YtTlI=
Date:   Thu, 05 Jan 2023 18:43:08 -0800
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + util_macrosh-add-missing-insclusion.patch added to mm-nonmm-unstable branch
Message-Id: <20230106024309.66067C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: util_macros.h: add missing insclusion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     util_macrosh-add-missing-insclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/util_macrosh-add-missing-insclusion.patch

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
Subject: util_macros.h: add missing insclusion
Date: Tue, 3 Jan 2023 14:19:37 +0200

The header is the direct user of definitions from the math.h, include it.

Link: https://lkml.kernel.org/r/20230103121937.32085-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/util_macros.h~util_macrosh-add-missing-insclusion
+++ a/include/linux/util_macros.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_HELPER_MACROS_H_
 #define _LINUX_HELPER_MACROS_H_
 
+#include <linux/math.h>
+
 #define __find_closest(x, a, as, op)					\
 ({									\
 	typeof(as) __fc_i, __fc_as = (as) - 1;				\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

util_macrosh-add-missing-insclusion.patch

