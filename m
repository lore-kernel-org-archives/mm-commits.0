From: akpm@linux-foundation.org
Subject: - uml-fix-incompatible-types-warning-in-previous-sg-fix.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:15 -0800
Message-ID: <200711060552.lA65qFCe007272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbXKFF4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:56:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@linux.intel.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix incompatible types warning in previous SG fix
has been removed from the -mm tree.  Its filename was
     uml-fix-incompatible-types-warning-in-previous-sg-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
