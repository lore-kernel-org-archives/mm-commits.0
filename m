From: akpm@linux-foundation.org
Subject: + drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch added to -mm tree
Date: Fri, 04 May 2007 13:48:42 -0700
Message-ID: <200705042048.l44KmgaF013811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376145AbXEDUst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 16:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ssatyam@cse.iitk.ac.in


The patch titled
     drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
has been added to the -mm tree.  Its filename is
     drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

drivers/message/i2o/device.c:i2o_parm_field_get() unnecessarily passes
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not
atomic. Remove the pointless GFP_ATOMIC.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/message/i2o/device.c
@@ -485,7 +485,7 @@ int i2o_parm_field_get(struct i2o_device
 	u8 *resblk;		/* 8 bytes for header */
 	int rc;
 
-	resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
+	resblk = kmalloc(buflen + 8, GFP_KERNEL);
 	if (!resblk)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
