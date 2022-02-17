Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43EC2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 20:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiBQU4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 15:56:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243566AbiBQU4P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 15:56:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBBC137586
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 12:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16962B82520
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 20:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ECCC340EB;
        Thu, 17 Feb 2022 20:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645131357;
        bh=5QjyXIqDRlpNwxfjdFv+lenJsmTNxrRobPNyFEiERCM=;
        h=Date:To:From:Subject:From;
        b=e5RHmu09/XFcyOsdS2lpf7Di5VWvYm4b83NxQeJHJYQFI+hfACbBuTudNWLiFAk+r
         m+DCKy5eHMauebZFUM1p4UF+XV2uEHKLSUf61g7jgU12jKxVvAxSlfntoqIe/Diife
         r1GWTecwPlK1mFLDBXpMKliPO3gd4Ga1+kBJ+Dik=
Date:   Thu, 17 Feb 2022 12:55:57 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com,
        hch@lst.de, akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch added to -mm tree
Message-Id: <20220217205557.92ECCC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch

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
Subject: mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix

fix arch/powerpc/mm/book3s64/pgtable.c

Reported-by: kernel test robot <lkp@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/pgtable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/memblock.h>
+#include <linux/memremap.h>
 #include <linux/debugfs.h>
 #include <misc/cxl-base.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

