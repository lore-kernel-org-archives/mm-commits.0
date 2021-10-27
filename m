Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF79C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5BE610A0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbhJ0U2b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhJ0U2a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1386103C;
        Wed, 27 Oct 2021 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635366364;
        bh=LyzZfGmpXuWDzAjd0M7N+sv0feMdrkV7HBSweaUJhV8=;
        h=Date:From:To:Subject:From;
        b=SgTzPGM/5UD7VOixD69zxez0BWFPeQSc/4K5gkaxaooI0zMiSJtn39x0MSsrxIvrr
         vvQk9WBYv9KCzShkr8t7Azmd/KfIvfy5XekQ/sedJD9JVUoFtx2lTEe5OzeGpuYssw
         XlUUy8XDCMoTyUOFDFFos5LtU0LB3UZmLfz9Jx/c=
Date:   Wed, 27 Oct 2021 13:26:04 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  +
 radix-tree-replace-kernelh-with-the-necessary-inclusions.patch added to -mm
 tree
Message-ID: <20211027202604.YDqFlGrh3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/radix-tree.h: replace kernel.h with the necessary inclusions
has been added to the -mm tree.  Its filename is
     radix-tree-replace-kernelh-with-the-necessary-inclusions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-replace-kernelh-with-the-necessary-inclusions.patch

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

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
kernelh-split-out-container_of-and-typeof_member-macros.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
list-replace-kernelh-with-the-necessary-inclusions.patch
llist-replace-kernelh-with-the-necessary-inclusions.patch
plist-replace-kernelh-with-the-necessary-inclusions.patch
media-entity-replace-kernelh-with-the-necessary-inclusions.patch
delay-replace-kernelh-with-the-necessary-inclusions.patch
sbitmap-replace-kernelh-with-the-necessary-inclusions.patch
radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
seq_file-move-seq_escape-to-a-header.patch

