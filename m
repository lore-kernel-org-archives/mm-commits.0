Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0004C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A6061404
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhEMTJY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhEMTJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C33F1613E9;
        Thu, 13 May 2021 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620932893;
        bh=7PbTMGc5202WiDaZZ2v9X6Uzln4T1zd1pr0jqg3i+iU=;
        h=Date:From:To:Subject:From;
        b=RRsp03u9IsHXqqzgnqDlXFXGU2G5g8XF2JzFFdIoW0bQtmtdly1T7ySBkShiBEvcj
         YeWfk8bLONz0kVmUjuR/iTSCbsEfpMCaBwYgpvqoive7Oqc6T8lJlBCrSycOxj3mwb
         M0dJklVuJ/UJeVPFCUR+1znFnV7MBNZVVz78r4+Q=
Date:   Thu, 13 May 2021 12:08:13 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  + kernelh-split-out-panic-and-oops-helpers-fix.patch
 added to -mm tree
Message-ID: <20210513190813.CYEeM3smt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernelh-split-out-panic-and-oops-helpers-fix
has been added to the -mm tree.  Its filename is
     kernelh-split-out-panic-and-oops-helpers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-panic-and-oops-helpers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-panic-and-oops-helpers-fix.patch

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
Subject: kernelh-split-out-panic-and-oops-helpers-fix

thread_info.h needs limits.h

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/thread_info.h~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/include/linux/thread_info.h
@@ -9,6 +9,7 @@
 #define _LINUX_THREAD_INFO_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #include <linux/bug.h>
 #include <linux/restart_block.h>
 #include <linux/errno.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

