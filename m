From: akpm@linux-foundation.org
Subject: + spi-potential-memleak-in-spidev_ioctl.patch added to -mm tree
Date: Thu, 17 May 2007 12:17:35 -0700
Message-ID: <200705171917.l4HJHZtV030897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEQTTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fmalita@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi: potential memleak in spidev_ioctl
has been added to the -mm tree.  Its filename is
     spi-potential-memleak-in-spidev_ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: potential memleak in spidev_ioctl
From: Florin Malita <fmalita@gmail.com>

'ioc' should be deallocated if __copy_from_user fails (found by Coverity
- CID 1644).

Signed-off-by: Florin Malita <fmalita@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/spi/spidev.c~spi-potential-memleak-in-spidev_ioctl drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-potential-memleak-in-spidev_ioctl
+++ a/drivers/spi/spidev.c
@@ -364,6 +364,7 @@ spidev_ioctl(struct inode *inode, struct
 			break;
 		}
 		if (__copy_from_user(ioc, (void __user *)arg, tmp)) {
+			kfree(ioc);
 			retval = -EFAULT;
 			break;
 		}
_

Patches currently in -mm which might be from fmalita@gmail.com are

git-ubi.patch
spi-potential-memleak-in-spidev_ioctl.patch
