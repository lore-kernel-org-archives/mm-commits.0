From: akpm@linux-foundation.org
Subject: + uml-fix-incompatible-types-warning-in-previous-sg-fix.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:35:38 -0700
Message-ID: <200711012335.lA1NZcnL021349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbXKAXfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@linux.intel.com, jens.axboe@oracle.com


The patch titled
     uml: fix incompatible types warning in previous SG fix
has been added to the -mm tree.  Its filename is
     uml-fix-incompatible-types-warning-in-previous-sg-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix incompatible types warning in previous SG fix
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix an incompatible-pointer warning.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-fix-incompatible-types-warning-in-previous-sg-fix arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-fix-incompatible-types-warning-in-previous-sg-fix
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

origin.patch
uml-fix-incompatible-types-warning-in-previous-sg-fix.patch
git-watchdog.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-code-tidying-under-arch-um-os-linux.patch
