From: akpm@linux-foundation.org
Subject: + cpqarray-check-put_user-result.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:11:22 -0700
Message-ID: <201007302111.o6ULBMZA000503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab0G3VLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, chirag.kantharia@hp.com, jaxboe@fusionio.com


The patch titled
     cpqarray: check put_user() result
has been added to the -mm tree.  Its filename is
     cpqarray-check-put_user-result.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpqarray: check put_user() result
From: Kulikov Vasiliy <segooon@gmail.com>

put_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/cpqarray.c~cpqarray-check-put_user-result drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~cpqarray-check-put_user-result
+++ a/drivers/block/cpqarray.c
@@ -1179,7 +1179,8 @@ out_passthru:
 		return error;
 	case IDAGETCTLRSIG:
 		if (!arg) return -EINVAL;
-		put_user(host->ctlr_sig, (int __user *)arg);
+		if (put_user(host->ctlr_sig, (int __user *)arg))
+			return -EFAULT;
 		return 0;
 	case IDAREVALIDATEVOLS:
 		if (MINOR(bdev->bd_dev) != 0)
@@ -1187,7 +1188,8 @@ out_passthru:
 		return revalidate_allvol(host);
 	case IDADRIVERVERSION:
 		if (!arg) return -EINVAL;
-		put_user(DRIVER_VERSION, (unsigned long __user *)arg);
+		if (put_user(DRIVER_VERSION, (unsigned long __user *)arg))
+			return -EFAULT;
 		return 0;
 	case IDAGETPCIINFO:
 	{
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
cpqarray-check-put_user-result.patch
mm-vmallocc-check-kmalloc-return-value.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

