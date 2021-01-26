Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57012C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 01:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA2C23107
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 01:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhAZBcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 20:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730587AbhAZBaK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 20:30:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EB6723102;
        Tue, 26 Jan 2021 01:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611623771;
        bh=GS2nMoSNAjzF6VxpDTzhtfCYPSMBlS+coViiMQABxRE=;
        h=Date:From:To:Subject:From;
        b=IxEabSWInnAOeXJ+BG1HZTVbdLxdiKitSc+W/mSG2M8AMsMBqGNdYVmZ7SZO2pLm/
         /SBtv6kwBFhsx2Vc2yQEGHKM8DtWVaYfr5Jt0civ4Eq34or8eBrZxi+K+r5VvUwNwq
         yjnjfG9c2mYzHKHjZLRGfTPpRYr9ibTKYx/UEsvY=
Date:   Mon, 25 Jan 2021 17:16:10 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stephenzhangzsd@gmail.com
Subject:  [to-be-updated] mm-memfd-replace-strcpy-by-strscpy.patch
 removed from -mm tree
Message-ID: <20210126011610.YHIacaS57%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memfd: replace strcpy() by strscpy()
has been removed from the -mm tree.  Its filename was
     mm-memfd-replace-strcpy-by-strscpy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: mm/memfd: replace strcpy() by strscpy()

strcpy() is being deprecated.  Replace it with the safer strscpy().

Link: https://lkml.kernel.org/r/1611455017-2210-1-git-send-email-stephenzhangzsd@gmail.com
Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~mm-memfd-replace-strcpy-by-strscpy
+++ a/mm/memfd.c
@@ -278,7 +278,7 @@ SYSCALL_DEFINE2(memfd_create,
 	if (!name)
 		return -ENOMEM;
 
-	strcpy(name, MFD_NAME_PREFIX);
+	strscpy(name, MFD_NAME_PREFIX, len + MFD_NAME_PREFIX_LEN);
 	if (copy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, len)) {
 		error = -EFAULT;
 		goto err_name;
_

Patches currently in -mm which might be from stephenzhangzsd@gmail.com are

mm-swapfilec-fix-debugging-information-problem.patch
mm-early_ioremapc-use-__func__-instead-of-function-name.patch

