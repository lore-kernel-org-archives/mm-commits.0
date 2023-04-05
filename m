Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5661C7619A
	for <mm-commits@archiver.kernel.org>; Wed,  5 Apr 2023 20:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjDEUEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 16:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDEUEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 16:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F13C38
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 13:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F75E62B40
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9612FC433D2;
        Wed,  5 Apr 2023 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680725080;
        bh=Ebfu9impAjXQbOzDOa7m4z2gmkJ2M3TFpKDufEK3tzs=;
        h=Date:To:From:Subject:From;
        b=rIMOPMib5JKyHym8himGyK3jynklda8g0qUI/f+VlPFPi9268b2TSX0hvTliZbGxA
         2KnoyCu8iMQd5GlZB8i5kEC7SMjhguQAsmo50BwtU8GjlcKOs6leBWyXEbx5ERPHgh
         aVA3/NQRMoAmkpRfYxs7KsnWtwb/GAJExb3gHmQQ=
Date:   Wed, 05 Apr 2023 13:04:39 -0700
To:     mm-commits@vger.kernel.org, thellstrom@vmware.com, lkp@intel.com,
        jgg@nvidia.com, hch@lst.de, adobriyan@gmail.com,
        steven.price@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + smaps-fix-defined-but-not-used-smaps_shmem_walk_ops.patch added to mm-unstable branch
Message-Id: <20230405200440.9612FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smaps: fix defined but not used smaps_shmem_walk_ops
has been added to the -mm mm-unstable branch.  Its filename is
     smaps-fix-defined-but-not-used-smaps_shmem_walk_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/smaps-fix-defined-but-not-used-smaps_shmem_walk_ops.patch

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
From: Steven Price <steven.price@arm.com>
Subject: smaps: fix defined but not used smaps_shmem_walk_ops
Date: Wed, 5 Apr 2023 11:38:19 +0100

When !CONFIG_SHMEM smaps_shmem_walk_ops is defined but not used,
triggering a compiler warning.  To avoid the warning remove the #ifdef
around the usage.  This has no effect because shmem_mapping() is a stub
returning false when !CONFIG_SHMEM so the code will be compiled out,
however we now need to also provide a stub for shmem_swap_usage().

Link: https://lkml.kernel.org/r/20230405103819.151246-1-steven.price@arm.com
Fixes: 7b86ac3371b7 ("pagewalk: separate function pointers from iterator data")
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202304031749.UiyJpxzF-lkp@intel.com/
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |    3 +--
 include/linux/shmem_fs.h |    7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-fix-defined-but-not-used-smaps_shmem_walk_ops
+++ a/fs/proc/task_mmu.c
@@ -782,7 +782,6 @@ static void smap_gather_stats(struct vm_
 	if (start >= vma->vm_end)
 		return;
 
-#ifdef CONFIG_SHMEM
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
 		 * For shared or readonly shmem mappings we know that all
@@ -803,7 +802,7 @@ static void smap_gather_stats(struct vm_
 			ops = &smaps_shmem_walk_ops;
 		}
 	}
-#endif
+
 	/* mmap_lock is held in m_start */
 	if (!start)
 		walk_page_vma(vma, ops, mss);
--- a/include/linux/shmem_fs.h~smaps-fix-defined-but-not-used-smaps_shmem_walk_ops
+++ a/include/linux/shmem_fs.h
@@ -96,7 +96,14 @@ int shmem_unuse(unsigned int type);
 
 extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 			  struct mm_struct *mm, unsigned long vm_flags);
+#ifdef CONFIG_SHMEM
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
+#else
+static inline unsigned long shmem_swap_usage(struct vm_area_struct *vma)
+{
+	return 0;
+}
+#endif
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
 
_

Patches currently in -mm which might be from steven.price@arm.com are

smaps-fix-defined-but-not-used-smaps_shmem_walk_ops.patch

