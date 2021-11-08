Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6197EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 23:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 438D761156
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 23:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbhKHX3J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 18:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240249AbhKHX3J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 18:29:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10BA610C8;
        Mon,  8 Nov 2021 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636413984;
        bh=WJ5wNZIeS/KzSSn4uUs9USGtmr8SjUHf3R5TefLoZGw=;
        h=Date:From:To:Subject:From;
        b=CpWd9gWzCyNjAFyZVOPCQ6xG3ELUQfxKQImN9iiXxjPjCgMK+WFmU9bpmIeP4Htmd
         jtvpI/IgXFb3qQ/DPYf9aTYKEwzMzoFc+kxsrssLFub6Crtm/CDGHYpaXRys/BPnTK
         auReZNtwjdlantPdn1oFe8WM/O33IM1qwopy99dA=
Date:   Mon, 08 Nov 2021 15:26:23 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux@roeck-us.net, mm-commits@vger.kernel.org, palmer@dabbelt.com,
        sfr@canb.auug.org.au
Subject:  +
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch added
 to -mm tree
Message-ID: <20211108232623.VGlgyna4s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix
has been added to the -mm tree.  Its filename is
     delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix

include/linux/fwnode.h needs bits.h for BIT()

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fwnode.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/fwnode.h~delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix
+++ a/include/linux/fwnode.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/bits.h>
 #include <linux/err.h>
 
 struct fwnode_operations;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

