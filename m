From: akpm@linux-foundation.org
Subject: - unlock-when-ssp-tries-to-close-an-invalid-port.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:12 -0800
Message-ID: <200711262148.lAQLmC9k024580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbXKZVse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:48:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm ssp: unlock when ssp tries to close an invalid port
has been removed from the -mm tree.  Its filename was
     unlock-when-ssp-tries-to-close-an-invalid-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-arm.patch
git-powerpc.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
