Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAA7ECAAD4
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiH0Bvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiH0Bvs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:51:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95D8EA312
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 53A4FCE31E4
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB61C433B5;
        Sat, 27 Aug 2022 01:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661565103;
        bh=osf64rgMDnn0vzjviX8T+HgBRSSq8s4/adgbRi0yxjk=;
        h=Date:To:From:Subject:From;
        b=PDWMjeL1P7rBz1ulP4GNkxAaOR9RU94sMEQyLuJRaTo0D/iDn0PAcbH+RPyPeRc4G
         QBXN7ckLhxqahTCtAWQDsmeuiG3fFUhPBDTjd1KiP8KrL49qumW+V0Z/sj3yNkR5+8
         l4/9KK4pNZNRy1BnvEbB8+54+HQhDUnr+ebCqo0c=
Date:   Fri, 26 Aug 2022 18:51:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, ruansy.fnst@fujitsu.com,
        riteshh@linux.ibm.com, rgoldwyn@suse.de, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, hch@lst.de,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-detection-of-memory_failure-handlers.patch added to mm-hotfixes-unstable branch
Message-Id: <20220827015143.8DB61C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix detection of memory_failure() handlers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-detection-of-memory_failure-handlers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-detection-of-memory_failure-handlers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

xfs-quiet-notify_failure-eopnotsupp-cases.patch
xfs-fix-sb_born-check-in-xfs_dax_notify_failure.patch
mm-memory-failure-fix-detection-of-memory_failure-handlers.patch
mm-memory-failure-fall-back-to-vma_address-when-notify_failure-fails.patch

