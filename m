Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D183C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353410AbiD1XuO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353304AbiD1XuO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4194EA0F;
        Thu, 28 Apr 2022 16:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469876212C;
        Thu, 28 Apr 2022 23:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9627EC385AD;
        Thu, 28 Apr 2022 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651189616;
        bh=dzloeFneAwUatQ82nBzs4vry1IR3EoFMQekP5IA5WnY=;
        h=Date:To:From:Subject:From;
        b=Bk2AsfeR4QZrVd9TJMyUk2ef6f1nCFww80JKBBTbSrACD72SgQ0+j7BBrv1ZfS3rG
         GQHtfx4vv6rrASN4l1Mihg588H0RpmtvPmBD+mvnjfK3OuApufBF5j5oxhHsKWEAJx
         lXLy40GfoLZ2jcyZO8QTFDCkA1+bgluIZ8o1dee0=
Date:   Thu, 28 Apr 2022 16:46:55 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, almasrymina@google.com,
        dossche.niels@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-sign-for-efault-error-return-value.patch added to -mm tree
Message-Id: <20220428234656.9627EC385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mremap: fix sign for EFAULT error return value
has been added to the -mm tree.  Its filename is
     mm-mremap-fix-sign-for-efault-error-return-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-fix-sign-for-efault-error-return-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-fix-sign-for-efault-error-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Niels Dossche <dossche.niels@gmail.com>
Subject: mm: mremap: fix sign for EFAULT error return value

The mremap syscall is supposed to return a pointer to the new virtual
memory area on success, and a negative value of the error code in case of
failure.  Currently, EFAULT is returned when the VMA is not found, instead
of -EFAULT.  The users of this syscall will therefore believe the syscall
succeeded in case the VMA didn't exist, as it returns a pointer to address
0xe (0xe being the value of EFAULT).  Fix the sign of the error value.

Link: https://lkml.kernel.org/r/20220427224439.23828-2-dossche.niels@gmail.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-sign-for-efault-error-return-value
+++ a/mm/mremap.c
@@ -941,7 +941,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		return -EINTR;
 	vma = vma_lookup(mm, addr);
 	if (!vma) {
-		ret = EFAULT;
+		ret = -EFAULT;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from dossche.niels@gmail.com are

mm-mremap-fix-sign-for-efault-error-return-value.patch

