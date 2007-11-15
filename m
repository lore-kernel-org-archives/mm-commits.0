From: akpm@linux-foundation.org
Subject: - crisv10-ethernet-declare-mac-fix.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:17 -0800
Message-ID: <200711152112.lAFLCHdj015854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932597AbXKOVRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, jeff@garzik.org, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRISv10 Ethernet declare mac fix
has been removed from the -mm tree.  Its filename was
     crisv10-ethernet-declare-mac-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
