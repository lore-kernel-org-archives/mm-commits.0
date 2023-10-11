Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B872CDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjJKRxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjJKRxV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:53:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422548F
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:53:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F330C433C7;
        Wed, 11 Oct 2023 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046799;
        bh=UKkE3+HyTRZUy2sriVd7GeSyDX6iFSgkWaBdDtlxioo=;
        h=Date:To:From:Subject:From;
        b=bv8SWQ+UkZCxQULirqfwBodYioNF2hzUI+7eMeE3EsdTyc67cHw0GHYzYR58kKqN5
         3OaZxWXtCq5F05D4qr+TbWxPDJkHPgWCGWR7UillPe7H/Lwh0ABzDgXWlNzJVHj7Do
         sARI3cfXZnMTFiJswZWQszXypDOSP0Y5fI9L4+KI=
Date:   Wed, 11 Oct 2023 10:53:10 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mark-stuff-as-__ro_after_init-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20231011175318.7F330C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mark-stuff-as-__ro_after_init-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mark-stuff-as-__ro_after_init-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mark-stuff-as-__ro_after_init-checkpatch-fixes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mark-stuff-as-__ro_after_init-checkpatch-fixes
Date: Wed Oct 11 10:07:07 AM PDT 2023

ERROR: "foo * bar" should be "foo *bar"
#52: FILE: block/bdev.c:295:
+static struct kmem_cache * bdev_cachep __ro_after_init;

total: 1 errors, 0 warnings, 383 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mark-stuff-as-__ro_after_init.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bdev.c~mark-stuff-as-__ro_after_init-checkpatch-fixes
+++ a/block/bdev.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(thaw_bdev);
  */
 
 static  __cacheline_aligned_in_smp DEFINE_MUTEX(bdev_lock);
-static struct kmem_cache * bdev_cachep __ro_after_init;
+static struct kmem_cache *bdev_cachep __ro_after_init;
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch

