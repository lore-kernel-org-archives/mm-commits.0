Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD8DC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E27611C5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhKICPj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICPj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:15:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C2EA6117A;
        Tue,  9 Nov 2021 02:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423974;
        bh=yhN4i7ywRYdbzPo/WD9JPqg2NI79LDEyoctXvKhZoq0=;
        h=Date:From:To:Subject:From;
        b=PYFxLeGvae5PpPVUnniKg/AzAESIFiBuAtnVvWFeIhWuAmEHCu/3MClPAvH0hq/Zw
         NRuxWxUE3PUpDlR4KKCABf3HfhyFSAIMzDTLAXp8WBgIKQpFD/gkOuUSbaiUlVakxV
         5xjc95avdT80rZxfFvddAYGd3Nhh1AQ8U30JniFg=
Date:   Mon, 08 Nov 2021 18:12:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        lkp@intel.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 delay-replace-kernelh-with-the-necessary-inclusions-fix.patch removed from
 -mm tree
Message-ID: <20211109021253.p98SewP14%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix
has been removed from the -mm tree.  Its filename was
     delay-replace-kernelh-with-the-necessary-inclusions-fix.patch

This patch was dropped because it was folded into delay-replace-kernelh-with-the-necessary-inclusions.patch

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

delay-replace-kernelh-with-the-necessary-inclusions.patch
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

