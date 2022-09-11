Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3384ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIKXXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIKXXG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2312F24F2D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B97B80BD1
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52503C433B5;
        Sun, 11 Sep 2022 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938583;
        bh=VHArKHscHSE/WT7YULNPTHyi9ugHlHSIG8SmfO4cOiI=;
        h=Date:To:From:Subject:From;
        b=MMsgT9qkggh8+OXFB8+U0lq2l51wdoE1i3pt14ubcF3sPSn03qDJURKH5plDh+9zb
         D/eEUebvA38YXsJdjjXmPxrUtytGLXZVI1cMD7PFlMykEw9zkQD3h7I9CD0ONS3Vtd
         L4iOSQTbEyMiwZhbA3J7bwmkpFuEoRBW8i8RjiN4=
Date:   Sun, 11 Sep 2022 16:23:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-detection-of-memory_failure-handlers.patch removed from -mm tree
Message-Id: <20220911232303.52503C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: fix detection of memory_failure() handlers
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-detection-of-memory_failure-handlers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memory-failure: fix detection of memory_failure() handlers
Date: Fri, 26 Aug 2022 10:18:07 -0700

Some pagemap types, like MEMORY_DEVICE_GENERIC (device-dax) do not even
have pagemap ops which results in crash signatures like this:

  BUG: kernel NULL pointer dereference, address: 0000000000000010
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 8000000205073067 P4D 8000000205073067 PUD 2062b3067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 22 PID: 4535 Comm: device-dax Tainted: G           OE    N 6.0.0-rc2+ #59
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:memory_failure+0x667/0xba0
 [..]
  Call Trace:
   <TASK>
   ? _printk+0x58/0x73
   do_madvise.part.0.cold+0xaf/0xc5

Check for ops before checking if the ops have a memory_failure()
handler.

Link: https://lkml.kernel.org/r/166153428781.2758201.1990616683438224741.stgit@dwillia2-xfh.jf.intel.com
Fixes: 33a8f7f2b3a3 ("pagemap,pmem: introduce ->memory_failure()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    5 +++++
 mm/memory-failure.c      |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/memremap.h~mm-memory-failure-fix-detection-of-memory_failure-handlers
+++ a/include/linux/memremap.h
@@ -139,6 +139,11 @@ struct dev_pagemap {
 	};
 };
 
+static inline bool pgmap_has_memory_failure(struct dev_pagemap *pgmap)
+{
+	return pgmap->ops && pgmap->ops->memory_failure;
+}
+
 static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 {
 	if (pgmap->flags & PGMAP_ALTMAP_VALID)
--- a/mm/memory-failure.c~mm-memory-failure-fix-detection-of-memory_failure-handlers
+++ a/mm/memory-failure.c
@@ -1928,7 +1928,7 @@ static int memory_failure_dev_pagemap(un
 	 * Call driver's implementation to handle the memory failure, otherwise
 	 * fall back to generic handler.
 	 */
-	if (pgmap->ops->memory_failure) {
+	if (pgmap_has_memory_failure(pgmap)) {
 		rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
 		/*
 		 * Fall back to generic handler too if operation is not
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


