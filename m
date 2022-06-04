Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C036DC43334
	for <mm-commits@archiver.kernel.org>; Sat,  4 Jun 2022 18:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiFDScL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Jun 2022 14:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiFDScK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Jun 2022 14:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DF46336
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 11:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC7AB803F7
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 18:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F15C385B8;
        Sat,  4 Jun 2022 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654367527;
        bh=ocSfCAPg98DBxCaRsJYN8aLx5R0s8W5dTSEZ43itPT0=;
        h=Date:To:From:Subject:From;
        b=nYIWJTt62ys+WsuNr2xPCrLZJKHHvCUf0I3eSERUHNIMvv3H6/HDTkBmytn5ysWfF
         ju1x9KsaTX3VPDJqGePXKZkYQzox2SkbgI7aieEvvk3VGPUjzh+6gTpRfjIMetjDkK
         9KstoBewRZjFjJRcERkqG+rQ8hRayIhczNWRQb/8=
Date:   Sat, 04 Jun 2022 11:32:06 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch added to mm-unstable branch
Message-Id: <20220604183206.E2F15C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-factor-helpers-for-memory_failure_dev_pagemap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-helpers-for-memory_failure_dev_pagemap-fix
Date: Sat Jun  4 11:31:06 AM PDT 2022

fix CONFIG_HUGETLB_PAGE=n build

Reported-by: kernel test robot <lkp@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-factor-helpers-for-memory_failure_dev_pagemap-fix
+++ a/mm/memory-failure.c
@@ -1714,12 +1714,21 @@ out:
 	unlock_page(head);
 	return res;
 }
+
 #else
+
+static inline int mf_generic_kill_procs(unsigned long long pfn, int flags,
+					struct dev_pagemap *pgmap)
+{
+	return 0;
+}
+
 static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
 	return 0;
 }
-#endif
+
+#endif	/* CONFIG_HUGETLB_PAGE */
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		struct dev_pagemap *pgmap)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch

