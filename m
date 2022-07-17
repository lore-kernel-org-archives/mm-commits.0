Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15ACCCA47B
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiGQEd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiGQEd1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:33:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634E720BF7
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 001DE60FB2
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F426C341C0;
        Sun, 17 Jul 2022 04:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032405;
        bh=5sGpEcpBEqxMQBqZ8EjzPvWmFLUt8NB8CxQI5qTv6FQ=;
        h=Date:To:From:Subject:From;
        b=bSZBjgQ5jWlmJgQFKUwdfYKe5SCTHmrfVr4C+7SLRQQxtwgAYbaDx8JI6IEEk1Hqa
         LuPzzp3CMg74ssRJf60WLHh+DGtBqNMee3oJeFFpkEFMnK3WrN6xvnIzB88JNz2LF4
         easE6NxIEvqYwt76dYFpbX09lxrUtcvflTDbYpG8=
Date:   Sat, 16 Jul 2022 21:33:24 -0700
To:     mm-commits@vger.kernel.org, chenxiaosong2@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220717043325.4F426C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch

This patch was dropped because it was folded into ntfs-fix-use-after-free-in-ntfs_ucsncmp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes
Date: Mon Jul 11 01:42:02 PM PDT 2022


ERROR: code indent should use tabs where possible
#27: FILE: fs/ntfs/attrib.c:598:
+^I^I               a->name_length * sizeof(ntfschar);$

total: 1 errors, 0 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c~ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes
+++ a/fs/ntfs/attrib.c
@@ -595,7 +595,7 @@ static int ntfs_attr_find(const ATTR_TYP
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
 		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-		               a->name_length * sizeof(ntfschar);
+			       a->name_length * sizeof(ntfschar);
 		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
 		    name_end > mrec_end)
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ntfs-fix-use-after-free-in-ntfs_ucsncmp.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch

