Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63DFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F37610FF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhIJDLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFAE610C8;
        Fri, 10 Sep 2021 03:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243423;
        bh=9PLXQmGiMYtEl2i3CBqUrO+hMQnh/6AOtl2HYoBQTyA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1sGmiQN4DM1bE+wtgMF91VJnKwbWbiIoniT/99RqIWxbxHgCYElxv984Nsdbef79q
         J9WWYtD3BpeoVSRjE1Sh+9M9fn/01/PP7u9FQSaIdTYsdMe6icCiTNQD6M1gl8z5k0
         D0fWTuvVCPMK2UtV3eRN5/1rmVgsIss/AphRA57k=
Date:   Thu, 09 Sep 2021 20:10:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com,
        gustavoars@kernel.org, ira.weiny@intel.com, jhubbard@nvidia.com,
        jingxiangfeng@huawei.com, jrdr.linux@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        torvalds@linux-foundation.org
Subject:  [patch 2/9] rapidio: avoid bogus __alloc_size warning
Message-ID: <20210910031022.kmBJ5voRH%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: rapidio: avoid bogus __alloc_size warning

GCC 9.3 (but not later) incorrectly evaluates the arguments to
check_copy_size(), getting seemingly confused by the size being returned
from array_size().  Instead, perform the calculation once, which both
makes the code more readable and avoids the bug in GCC.

   In file included from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:55,
                    from include/linux/mm_types.h:9,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from drivers/rapidio/devices/rio_mport_cdev.c:13:
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:191:6,
       inlined from 'rio_mport_transfer_ioctl' at drivers/rapidio/devices/rio_mport_cdev.c:983:6:
   include/linux/thread_info.h:213:4: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
     213 |    __bad_copy_to();
         |    ^~~~~~~~~~~~~~~

But the allocation size and the copy size are identical:

	transfer = vmalloc(array_size(sizeof(*transfer), transaction.count));
	if (!transfer)
		return -ENOMEM;

	if (unlikely(copy_from_user(transfer,
				    (void __user *)(uintptr_t)transaction.block,
				    array_size(sizeof(*transfer), transaction.count)))) {

Link: https://lkml.kernel.org/r/20210909161409.2250920-1-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/202109091134.FHnRmRxu-lkp@intel.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-avoid-bogus-__alloc_size-warning
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -965,6 +965,7 @@ static int rio_mport_transfer_ioctl(stru
 	struct rio_transfer_io *transfer;
 	enum dma_data_direction dir;
 	int i, ret = 0;
+	size_t size;
 
 	if (unlikely(copy_from_user(&transaction, arg, sizeof(transaction))))
 		return -EFAULT;
@@ -976,13 +977,14 @@ static int rio_mport_transfer_ioctl(stru
 	     priv->md->properties.transfer_mode) == 0)
 		return -ENODEV;
 
-	transfer = vmalloc(array_size(sizeof(*transfer), transaction.count));
+	size = array_size(sizeof(*transfer), transaction.count);
+	transfer = vmalloc(size);
 	if (!transfer)
 		return -ENOMEM;
 
 	if (unlikely(copy_from_user(transfer,
 				    (void __user *)(uintptr_t)transaction.block,
-				    array_size(sizeof(*transfer), transaction.count)))) {
+				    size))) {
 		ret = -EFAULT;
 		goto out_free;
 	}
@@ -994,8 +996,7 @@ static int rio_mport_transfer_ioctl(stru
 			transaction.sync, dir, &transfer[i]);
 
 	if (unlikely(copy_to_user((void __user *)(uintptr_t)transaction.block,
-				  transfer,
-				  array_size(sizeof(*transfer), transaction.count))))
+				  transfer, size)))
 		ret = -EFAULT;
 
 out_free:
_
