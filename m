Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A38C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 23:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbjKFX0f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 18:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjKFX0T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 18:26:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ACC210C
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 15:21:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC843C433CB;
        Mon,  6 Nov 2023 23:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699312866;
        bh=mwCmaID51aOFBrlcbkqpbknHCPmADLrQEueodg1CD3k=;
        h=Date:To:From:Subject:From;
        b=FkWDde5WTtG42CxLv3wvZTGj5Jq+7B2mvSIo8FcFacxXrVM7v4d2ja7ncXiwT6QJa
         A9Wz22mR9BeM8JreFfsZCp7uOZEMPOpijWoI+ViWlRGeVt74iojqHbo1wOs1Cmeajj
         6lamvY8wzI/aUiQXs8pAYfVyjqUcoDNDNGr4Fhgc=
Date:   Mon, 06 Nov 2023 15:21:05 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        airlied@redhat.com, pstanner@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-nilfs2-use-standard-array-copy-function.patch added to mm-nonmm-unstable branch
Message-Id: <20231106232105.EC843C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: use standard array-copy-function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-nilfs2-use-standard-array-copy-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-nilfs2-use-standard-array-copy-function.patch

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
From: Philipp Stanner <pstanner@redhat.com>
Subject: fs/nilfs2: use standard array-copy-function
Date: Tue, 7 Nov 2023 07:44:16 +0900

ioctl.c utilizes memdup_user() to copy a userspace array.  An overflow
check is performed manually before the function's invocation.

The new function memdup_array_user() standardizes copying userspace
arrays, thus, improving readability by making it more clear that an array
is being copied.  Additionally, it also performs an overflow check.

Remove the (now redundant) manual overflow-check and replace memdup_user()
with memdup_array_user().

In addition, improve the grammar of the comment above
memdup_array_user().

Link: https://lkml.kernel.org/r/20231106224416.3055-1-konishi.ryusuke@gmail.com
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Link: https://lkml.kernel.org/r/20231103184831.99406-2-pstanner@redhat.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/ioctl.c~fs-nilfs2-use-standard-array-copy-function
+++ a/fs/nilfs2/ioctl.c
@@ -872,16 +872,14 @@ static int nilfs_ioctl_clean_segments(st
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
 		goto out;
-	if (nsegs > UINT_MAX / sizeof(__u64))
-		goto out;
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
-	 * use kmalloc() for its buffer because memory used for the
-	 * segment numbers is enough small.
+	 * use kmalloc() for its buffer because the memory used for the
+	 * segment numbers is small enough.
 	 */
-	kbufs[4] = memdup_user((void __user *)(unsigned long)argv[4].v_base,
-			       nsegs * sizeof(__u64));
+	kbufs[4] = memdup_array_user((void __user *)(unsigned long)argv[4].v_base,
+				     nsegs, sizeof(__u64));
 	if (IS_ERR(kbufs[4])) {
 		ret = PTR_ERR(kbufs[4]);
 		goto out;
_

Patches currently in -mm which might be from pstanner@redhat.com are

fs-nilfs2-use-standard-array-copy-function.patch

