Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB9FCDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJRVla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJRVla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:41:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49635FE
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:41:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDA1C433C8;
        Wed, 18 Oct 2023 21:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665287;
        bh=4N61wWCZnylPO/7WhLjQCT+tCMlVgtbu3FBYtte+p1E=;
        h=Date:To:From:Subject:From;
        b=ZX0LxCiD55lzCGO+V5OKtdELBN4cGiuozGfCBUZROr3KbnOqBeHC9+l1Zx0kp7/cr
         GAlPf/QTcO0uIAvsPafHWs6daJ3/C2bN9kpAurY4Z2N7HATNJY880uXBCKXUIBFwyJ
         4E0VR3VomwiXJjmw0q8bs32UsqA/GvBXLnFeo8lQ=
Date:   Wed, 18 Oct 2023 14:41:27 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mark-stuff-as-__ro_after_init-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20231018214127.CBDA1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mark-stuff-as-__ro_after_init-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mark-stuff-as-__ro_after_init-checkpatch-fixes.patch

This patch was dropped because it was folded into mark-stuff-as-__ro_after_init.patch

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
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init.patch
mark-stuff-as-__ro_after_init-fix.patch

