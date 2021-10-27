Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E26C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA936103C
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 20:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbhJ0U23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239500AbhJ0U22 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 16:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C558E610A0;
        Wed, 27 Oct 2021 20:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635366362;
        bh=003K7EaON8oZ5D8GeOoMFr8j2vET0DuADimpaXxjMuI=;
        h=Date:From:To:Subject:From;
        b=ddB+8wbNTTCwb2p02s2bQyP3DGtFAZPsNrZsZrPkztaZ/pNlUQTs2QBUTnCBKk//y
         3SRc81Vw/ZZUwyxAfmy0FJ+OLSaoo2BR6YcpUw89FB9qQkgfR0R9YZu5zB+xca03rV
         Bc8ID3FoOfHafl3Gwk+iTxrYGzLhnOTE9lNrMBp4=
Date:   Wed, 27 Oct 2021 13:26:02 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject:  +
 sbitmap-replace-kernelh-with-the-necessary-inclusions.patch added to -mm
 tree
Message-ID: <20211027202602.XA4vL-WrA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sbitmap.h: replace kernel.h with the necessary inclusions
has been added to the -mm tree.  Its filename is
     sbitmap-replace-kernelh-with-the-necessary-inclusions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sbitmap-replace-kernelh-with-the-necessary-inclusions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sbitmap-replace-kernelh-with-the-necessary-inclusions.patch

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

