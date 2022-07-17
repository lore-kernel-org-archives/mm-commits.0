Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE6DC43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiGQXZ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQXZ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:25:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02FB120B4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 959C4B80E4E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB9BC3411E;
        Sun, 17 Jul 2022 23:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100324;
        bh=QxLpvNmu4erleiMQB9x6zcwjEA8Of75L1OZvIR6Injs=;
        h=Date:To:From:Subject:From;
        b=LoqqR0WrPl48uXVBBIfxaGRqMJ65lzfp2+RyPqOM5JcTKzxuZzO5+JeupO97pE09v
         mkxmr0J4yC6hHX2kswr0tCtxmpL932j4A+oZGC+dLROHBn5wGCX/R8wz7BAQfTC/Sv
         pLYHL1+UQuzjKLuXmy9NgYzJNQHCf/+ibpgfWZnM=
Date:   Sun, 17 Jul 2022 16:25:23 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch removed from -mm tree
Message-Id: <20220717232524.4EB9BC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-factor-helpers-for-memory_failure_dev_pagemap-fix
has been removed from the -mm tree.  Its filename was
     mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch

This patch was dropped because it was folded into mm-factor-helpers-for-memory_failure_dev_pagemap.patch

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
@@ -1723,12 +1723,21 @@ out:
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

mm-factor-helpers-for-memory_failure_dev_pagemap.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

