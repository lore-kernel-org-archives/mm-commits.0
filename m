Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD7AC433E2
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0598720786
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594424115;
	bh=ESRm34R0HHREFKwZfbARvIoNJ7ay9yu+6kq/+qN2P6E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fb44TDaKnXOZRmz7yNv6cdDFhZ8lMnMNMfFhkbJQyHsbJy2S9ut18oAT/qfkRg/jC
	 hct+0A7S58juCRiJOi9YE3mInwXanMLT1vVsWnQ4vaVqUPaJtKMVqORNbyQAl1xAU7
	 3D/Uyao3sfZOyRKQ88tNRnUE+VNuQitixJMg+5/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGJXfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 19:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgGJXfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 19:35:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9352220657;
        Fri, 10 Jul 2020 23:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594424113;
        bh=ESRm34R0HHREFKwZfbARvIoNJ7ay9yu+6kq/+qN2P6E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LtfE+nN1zivFVR6ok29UiwNmf0JsMgDZHKRdoriJSTewhtNIz94uOSc/e0JlDcNKe
         6YXNvvTMeNYQDp2UmP8M+VyEKcnKKxjqRXuxiDi85HJorYGsTsaPF7SlxIUjV093sq
         Z6yMAPSvtWlqlsDyCVDbJyeTV/we7Yfl/qashNFU=
Date:   Fri, 10 Jul 2020 16:35:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alex.bou9@gmail.com, gustavoars@kernel.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org
Subject:  +
 rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch
 added to -mm tree
Message-ID: <20200710233513.fR5PV21QZ%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_mport_cdev: Use array_size() helper in copy_{from,to}_user()
has been added to the -mm tree.  Its filename is
     rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: rapidio/rio_mport_cdev: Use array_size() helper in copy_{from,to}_user()

Use array_size() helper instead of the open-coded version in
copy_{from,to}_user().  These sorts of multiplication factors need to be
wrapped in array_size().

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Link: http://lkml.kernel.org/r/20200616183050.GA31840@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -981,7 +981,7 @@ static int rio_mport_transfer_ioctl(stru
 
 	if (unlikely(copy_from_user(transfer,
 				    (void __user *)(uintptr_t)transaction.block,
-				    transaction.count * sizeof(*transfer)))) {
+				    array_size(sizeof(*transfer), transaction.count)))) {
 		ret = -EFAULT;
 		goto out_free;
 	}
@@ -994,7 +994,7 @@ static int rio_mport_transfer_ioctl(stru
 
 	if (unlikely(copy_to_user((void __user *)(uintptr_t)transaction.block,
 				  transfer,
-				  transaction.count * sizeof(*transfer))))
+				  array_size(sizeof(*transfer), transaction.count))))
 		ret = -EFAULT;
 
 out_free:
_

Patches currently in -mm which might be from gustavoars@kernel.org are

rapidio-rio_mport_cdev-use-struct_size-helper.patch
rapidio-use-struct_size-helper.patch
rapidio-rio_mport_cdev-use-array_size-helper-in-copy_fromto_user.patch

