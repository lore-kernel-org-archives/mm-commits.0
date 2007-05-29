From: akpm@linux-foundation.org
Subject: - spi-potential-memleak-in-spidev_ioctl.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:06 -0700
Message-ID: <200705291851.l4TIp59X008319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbXE2Svg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmalita@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: potential memleak in spidev_ioctl
has been removed from the -mm tree.  Its filename was
     spi-potential-memleak-in-spidev_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
