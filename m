Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6FCC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABBA611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhKEUi4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232695AbhKEUi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA9D611C0;
        Fri,  5 Nov 2021 20:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144576;
        bh=AR/knvV7sZbF+P9B2GhmwtHpsmXX+YC0xLG1nzE6cYw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NvFehpFFVOHqL0N0aPIsTe79qe6o9c4yferioqNC+KE9FJw28aQGDe2f0UKseKscO
         xXTvHnxS7dVR/6FFtj+2BbjczUNY9Zy6ZNpgZw1N67Om7478rt9S/si9aKAmsGimPF
         yrb17qyLZxIUi4K1Q8QkpG9ijV2xd2T3jNwRiAUQ=
Date:   Fri, 05 Nov 2021 13:36:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com, apw@canonical.com,
        cl@linux.com, danielmicay@gmail.com, dennis@kernel.org,
        dwaipayanray1@gmail.com, gustavoars@kernel.org,
        iamjoonsoo.kim@lge.com, ira.weiny@intel.com, jhubbard@nvidia.com,
        jingxiangfeng@huawei.com, joe@perches.com, jrdr.linux@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org, lkp@intel.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 032/262] rapidio: avoid bogus __alloc_size warning
Message-ID: <20211105203615.KtXTy0MDX%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: rapidio: avoid bogus __alloc_size warning

Patch series "Add __alloc_size()", v3.

GCC and Clang both use the "alloc_size" attribute to assist with bounds
checking around the use of allocation functions.  Add the attribute,
adjust the Makefile to silence needless warnings, and add the hints to the
allocators where possible.  These changes have been in use for a while now
in GrapheneOS.


This patch (of 8):

After adding __alloc_size attributes to the allocators, GCC 9.3 (but not
later) may incorrectly evaluate the arguments to check_copy_size(),
getting seemingly confused by the size being returned from array_size(). 
Instead, perform the calculation once, which both makes the code more
readable and avoids the bug in GCC.

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

Link: https://lkml.kernel.org/r/20210930222704.2631604-1-keescook@chromium.org
Link: https://lkml.kernel.org/r/20210930222704.2631604-2-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/202109091134.FHnRmRxu-lkp@intel.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
