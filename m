Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9D6C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbiFCShg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347555AbiFCShH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0171E3D6
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A73B82431
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE51C385B8;
        Fri,  3 Jun 2022 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654281149;
        bh=hjTo36tkRHPNImxprdZTnyTBZhnvg+lDEwCMr93gfzM=;
        h=Date:To:From:Subject:From;
        b=ebdHEJc7I0hn+m2ExJtK6nIx+0C1DDAKruam6zqBceP7LSRcUL+r3K0dGeCNkGpZJ
         iLcWRKf4ZCSoM3mwTDm6Fes1+v6Zwf5VA/AyTDh/ktWPIjUBkkGUPuMnT165tXWml1
         7BisBEJe6kHVeWgwbuI0xtBd0jDgGWWeFhnIPGoM=
Date:   Fri, 03 Jun 2022 11:32:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-replace-kernelh-with-the-necessary-inclusions.patch added to mm-nonmm-unstable branch
Message-Id: <20220603183229.3AE51C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/rbtree.h: replace kernel.h with the necessary inclusions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-replace-kernelh-with-the-necessary-inclusions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-replace-kernelh-with-the-necessary-inclusions.patch

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
Subject: include/linux/rbtree.h: replace kernel.h with the necessary inclusions
Date: Fri, 3 Jun 2022 20:10:12 +0300

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20220603171012.48880-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rbtree.h~rbtree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/rbtree.h
@@ -17,9 +17,9 @@
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
 
+#include <linux/container_of.h>
 #include <linux/rbtree_types.h>
 
-#include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/rcupdate.h>
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

rbtree-replace-kernelh-with-the-necessary-inclusions.patch
xarray-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-move-sysfs-related-macro-to-sysfsh.patch

