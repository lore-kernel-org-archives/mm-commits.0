Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8741CA0ED2
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjILRL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbjILRL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:11:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E8E10EB
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:11:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F24C433C7;
        Tue, 12 Sep 2023 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694538713;
        bh=hQ6y+SGEVVPSydbMKwQZwWRuAXb3LqIySUQv7nUVJWQ=;
        h=Date:To:From:Subject:From;
        b=diXb/Sly8IvgY5ws1MsVKRL6wGO40KGDctbZeJpXui6fBxLa9ERKxHf3UmKjqg1vW
         4C+gtIfNXWWTkYGb8H1UFuSe7D+QZzTD3McQuh/Fq+Yq+r/TnpiTqsQnBIk5jKRduc
         IAVYuZ/cqIjQpouKhvxpS0QVTykegd1CONzXM1nQ=
Date:   Tue, 12 Sep 2023 10:11:52 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        herve.codina@bootlin.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-fix-header-inclusions.patch added to mm-nonmm-unstable branch
Message-Id: <20230912171153.40F24C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: fix header inclusions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-fix-header-inclusions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-fix-header-inclusions.patch

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

minmax-deduplicate-__unconst_integer_typeof.patch
minmax-fix-header-inclusions.patch

