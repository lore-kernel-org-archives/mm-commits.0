From: akpm@linux-foundation.org
Subject: + unlock-when-ssp-tries-to-close-an-invalid-port.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:06:47 -0700
Message-ID: <200710292106.l9TL6lXe023197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbXJ2VH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, rmk@arm.linux.org.uk


The patch titled
     arm ssp: unlock when ssp tries to close an invalid port
has been added to the -mm tree.  Its filename is
     unlock-when-ssp-tries-to-close-an-invalid-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm ssp: unlock when ssp tries to close an invalid port
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/ssp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-pxa/ssp.c~unlock-when-ssp-tries-to-close-an-invalid-port arch/arm/mach-pxa/ssp.c
--- a/arch/arm/mach-pxa/ssp.c~unlock-when-ssp-tries-to-close-an-invalid-port
+++ a/arch/arm/mach-pxa/ssp.c
@@ -309,6 +309,7 @@ void ssp_exit(struct ssp_dev *dev)
 
     	if (dev->port > PXA_SSP_PORTS || dev->port == 0) {
 		printk(KERN_WARNING "SSP: tried to close invalid port\n");
+		mutex_unlock(&mutex);
 		return;
 	}
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-arm-master.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
itco_wdt_start-undo-locking-when-reboot-is-disabled.patch
i4l-errors-with-assignments-in-if.patch
