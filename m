Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7919DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 23:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6D1610CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 23:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhJ0Xpz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 19:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ0Xpz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 19:45:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF0C761073;
        Wed, 27 Oct 2021 23:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635378209;
        bh=w32BuWTOyJTAkLe1CCwIJVxEDQizfL0Gg1wVSRKRMxM=;
        h=Date:From:To:Subject:From;
        b=ZY/CYfoSkxsvQMwDvxLpp5cZckAnz6wJpXYr6B5q/ig4UpIXyA8zgOLGhpaylLEsl
         e13PLfgS08I8HwWE3t12eNAAaGKbr62Hd9fKcvoyo5vybsH2Z4W3rgJdP5AzktaPw9
         SdVrcNb3UnAO30DcGK5uC/zPlsrg5PAzm2PzW22c=
Date:   Wed, 27 Oct 2021 16:43:28 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        lkp@intel.com, mm-commits@vger.kernel.org
Subject:  +
 delay-replace-kernelh-with-the-necessary-inclusions-fix.patch added to -mm
 tree
Message-ID: <20211027234328.x1aWWVi-e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix
has been added to the -mm tree.  Its filename is
     delay-replace-kernelh-with-the-necessary-inclusions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delay-replace-kernelh-with-the-necessary-inclusions-fix.patch

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
Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix

drivers/media/dvb-frontends/cxd2880/cxd2880_common.h needs bits.h for GENMASK()

Reported-by: kernel test robot <lkp@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h~delay-replace-kernelh-with-the-necessary-inclusions-fix
+++ a/drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/bits.h>
 #include <linux/string.h>
 
 int cxd2880_convert2s_complement(u32 value, u32 bitlen);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch

