Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4613BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F72861208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhKICPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:15:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA06611C4;
        Tue,  9 Nov 2021 02:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423979;
        bh=yrPs3Wujz9UlhOFhfkfZz0blQZfPil7oqceAiMlvy1U=;
        h=Date:From:To:Subject:From;
        b=OzSWjhR7XKm1TvX8NwhQuRnnCWorLRrkyQ6n4FZC9jkZHIiqxF/994WbZi9meWIqD
         qV6CTNL+zAPON3G5FFYiKjQ8bWmNCJ7EEhze2H6wwfL8GtEwD8liTUOjEKEYAci9qi
         8kGwFxq40/31BEBYCU9ZsbSGcRP6x+pCG3PzLCn4=
Date:   Mon, 08 Nov 2021 18:12:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux@roeck-us.net, mm-commits@vger.kernel.org, palmer@dabbelt.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch removed
 from -mm tree
Message-ID: <20211109021259.b40MBaemE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix
has been removed from the -mm tree.  Its filename was
     delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch

This patch was dropped because it was folded into delay-replace-kernelh-with-the-necessary-inclusions.patch

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

delay-replace-kernelh-with-the-necessary-inclusions.patch
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

