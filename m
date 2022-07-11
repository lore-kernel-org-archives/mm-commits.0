Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF71C43334
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiGKUmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGKUmg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 16:42:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9CD6BC04
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 13:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F80B81203
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 20:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6FDC341C0;
        Mon, 11 Jul 2022 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657572153;
        bh=QDQCzvmsYNSbtf57OVdhp8gSjvILPLSI13kXsLkABkg=;
        h=Date:To:From:Subject:From;
        b=J098juZmWaIU3j40JKis0dnIcXVgCeEkxZv9wxTVNW/D3Fgm+b8/psgn+LrG6U84O
         af5ATr7SIoCoSVioW2+DAweBU6kls0WKH1WRqW4cAXteHCxdG5EaR75mhurv+RMJHl
         KVh39rpPriF5lMs1a4R6x38aD8u4JfOeJfmXvFIY=
Date:   Mon, 11 Jul 2022 13:42:32 -0700
To:     mm-commits@vger.kernel.org, chenxiaosong2@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch added to mm-hotfixes-unstable branch
Message-Id: <20220711204233.0A6FDC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch

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

ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch

