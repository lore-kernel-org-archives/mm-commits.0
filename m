From: akpm@linux-foundation.org
Subject: + crisv10-ethernet-declare-mac-fix.patch added to -mm tree
Date: Wed, 14 Nov 2007 08:41:23 -0800
Message-ID: <200711141641.lAEGfNmn014998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757275AbXKNQmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 11:42:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, jeff@garzik.org, mikael.starvik@axis.com


The patch titled
     CRISv10 Ethernet declare mac fix
has been added to the -mm tree.  Its filename is
     crisv10-ethernet-declare-mac-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRISv10 Ethernet declare mac fix
From: Jesper Nilsson <jesper.nilsson@axis.com>

Declare mac using DECLARE_MAC_BUF for use when calling print_mac().

This fixes compile error where mac was undeclared.
Also, remove unused variable i.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cris/eth_v10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/cris/eth_v10.c~crisv10-ethernet-declare-mac-fix drivers/net/cris/eth_v10.c
--- a/drivers/net/cris/eth_v10.c~crisv10-ethernet-declare-mac-fix
+++ a/drivers/net/cris/eth_v10.c
@@ -630,7 +630,7 @@ e100_set_mac_address(struct net_device *
 {
 	struct net_local *np = netdev_priv(dev);
 	struct sockaddr *addr = p;
-	int i;
+	DECLARE_MAC_BUF(mac);
 
 	spin_lock(&np->lock); /* preemption protection */
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

git-mtd.patch
cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
crisv32-add-cache-flush-operations.patch
cris-tlbh-should-include-linux-pagemaph.patch
crisv10-ethernet-declare-mac-fix.patch
