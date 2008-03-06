From: akpm@linux-foundation.org
Subject: - arch-um-drivers-ubd_kernc-a-warning-fix.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:27:58 -0800
Message-ID: <200803062227.m26MRwKr021135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146AbYCFW30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     arch/um/drivers/ubd_kern.c: a warning fix
has been removed from the -mm tree.  Its filename was
     arch-um-drivers-ubd_kernc-a-warning-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/drivers/ubd_kern.c: a warning fix
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix an incompatible-pointer warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~arch-um-drivers-ubd_kernc-a-warning-fix arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~arch-um-drivers-ubd_kernc-a-warning-fix
+++ a/arch/um/drivers/ubd_kern.c
@@ -705,7 +705,7 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
 	INIT_LIST_HEAD(&ubd_dev->restart);
-	sg_init_table(&ubd_dev->sg, MAX_SG);
+	sg_init_table(ubd_dev->sg, MAX_SG);
 
 	err = -ENOMEM;
 	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

