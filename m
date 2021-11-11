Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9EBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7876E61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhKKCyd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhKKCyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7406460F26;
        Thu, 11 Nov 2021 02:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599104;
        bh=k6y+VGQd9gzo+vZqI5g2CrQzKK5pfHt2cctrGg2/8Us=;
        h=Date:From:To:Subject:From;
        b=Zk7ytJPwCoM17UzDvcoq9ZNRxoHq8Ty4zvDm8Yi0VmhLGRmzlxfbS8b1HKEgnzQ02
         uWlFs0jyoJ9ZBhc2abbpPFl8Qq98pkk5i9/CChZnk7ubI/bTbS7r+dc4OzYgJ12zvp
         Y7AIsWAt7AZQKvlnpFL8dkg7YJgErfI6hwC+Mll8=
Date:   Wed, 10 Nov 2021 18:51:44 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  [merged]
 radix-tree-replace-kernelh-with-the-necessary-inclusions.patch removed from
 -mm tree
Message-ID: <20211111025144.fzQv7uH5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/radix-tree.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     radix-tree-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/radix-tree.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211027150528.80003-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/radix-tree.h~radix-tree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/radix-tree.h
@@ -9,8 +9,10 @@
 #define _LINUX_RADIX_TREE_H
 
 #include <linux/bitops.h>
-#include <linux/kernel.h>
+#include <linux/gfp.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/math.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate.h>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


