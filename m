Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3D2C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 03:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B6C3225A9
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 03:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAXD50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 22:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbhAXD5Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 22:57:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17A26225A9;
        Sun, 24 Jan 2021 03:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611460605;
        bh=y4iXnONY0VQVtJGb0gomstgPGbnR1cgCzn5BgtYCufw=;
        h=Date:From:To:Subject:From;
        b=PSD7yUTQZQ2chwbF8lburzMWl6EZgVJPzv8iLok9dSQivDX1A/TIuqJPaqWtlmgTh
         F3Se1FIWiP4nKOpQaKmDxFAc3Tnc3kBCCIJ56m+GHsTsnfPXWit8bEdxlRUrWtpL4+
         jNJZmVsrKZok8cla9YgK8+MPxcYOseOV/umaLuiA=
Date:   Sat, 23 Jan 2021 19:56:43 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stephenzhangzsd@gmail.com
Subject:  + mm-memfd-replace-strcpy-by-strscpy.patch added to -mm
 tree
Message-ID: <20210124035643.w-SK7UT3m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memfd: replace strcpy() by strscpy()
has been added to the -mm tree.  Its filename is
     mm-memfd-replace-strcpy-by-strscpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memfd-replace-strcpy-by-strscpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memfd-replace-strcpy-by-strscpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memfd-replace-strcpy-by-strscpy.patch
mm-early_ioremapc-use-__func__-instead-of-function-name.patch

