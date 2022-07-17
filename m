Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF9FC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiGQX0Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQX0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572BC120B9
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E432560C56
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722BC3411E;
        Sun, 17 Jul 2022 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100383;
        bh=kVxnT7X1vX7RMieMQfbkodYy/GxvboXgvzpmKmk4pkM=;
        h=Date:To:From:Subject:From;
        b=SE1mAzF2HxcX9x9/swxtLqv8ZKDYtm/m+luP+LLHwpeF+yWfEG1IYdd9V7H+VkM2u
         joPLpihVZFlUlT0qSt+zWxcLjUq7lFBI6CTLY+ImFezJIfxthCkPr+CIT4YKtvye0O
         /oDeF6buHyk4v3aCAU78M4gWUQF1tT8gtSE9/QgQ=
Date:   Sun, 17 Jul 2022 16:26:22 -0700
To:     mm-commits@vger.kernel.org, riteshh@linux.ibm.com, hch@lst.de,
        djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch removed from -mm tree
Message-Id: <20220717232623.4722BC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
has been removed from the -mm tree.  Its filename was
     fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21.patch

This patch was dropped because it was folded into fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
Date: Tue, 7 Jun 2022 22:38:37 +0800

initialize `rc', per Dan.

Link: https://lore.kernel.org/linux-fsdevel/Yp8FUZnO64Qvyx5G@kili/
Link: https://lkml.kernel.org/r/20220607143837.161174-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c~fsdax-output-address-in-dax_iomap_pfn-and-rename-it-v21
+++ a/fs/dax.c
@@ -1030,7 +1030,7 @@ static int dax_iomap_direct_access(const
 		size_t size, void **kaddr, pfn_t *pfnp)
 {
 	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
-	int id, rc;
+	int id, rc = 0;
 	long length;
 
 	id = dax_read_lock();
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

dax-introduce-holder-for-dax_device.patch
mm-factor-helpers-for-memory_failure_dev_pagemap.patch
pagemappmem-introduce-memory_failure.patch
fsdax-introduce-dax_lock_mapping_entry.patch
mm-introduce-mf_dax_kill_procs-for-fsdax-case.patch
xfs-implement-notify_failure-for-xfs.patch
fsdax-set-a-cow-flag-when-associate-reflink-mappings.patch
fsdax-output-address-in-dax_iomap_pfn-and-rename-it.patch
fsdax-introduce-dax_iomap_cow_copy.patch
fsdax-replace-mmap-entry-in-case-of-cow.patch
fsdax-add-dax_iomap_cow_copy-for-dax-zero.patch
fsdax-dedup-file-range-to-use-a-compare-function.patch
xfs-support-cow-in-fsdax-mode.patch
xfs-add-dax-dedupe-support.patch

