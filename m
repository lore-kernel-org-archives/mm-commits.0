From: akpm@linux-foundation.org
Subject: - powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch removed from -mm tree
Date: Tue, 13 Nov 2007 12:30:16 -0800
Message-ID: <200711132030.lADKUGYl002642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943AbXKMUbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 15:31:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fs_enet: select PHYLIB as the driver needs it.
has been removed from the -mm tree.  Its filename was
     powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: powerpc: fs_enet: select PHYLIB as the driver needs it.
From: Jochen Friedrich <jochen@scram.de>

Add a select PHYLIB to config FS_ENET as the driver uses functions of
libphy.

LD      .tmp_vmlinux1
drivers/built-in.o: In function `fs_ioctl':
drivers/net/fs_enet/fs_enet-main.c:952: undefined reference to `phy_mii_ioctl'
[...]
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/fs_enet/Kconfig~powerpc-fs_enet-select-phylib-as-the-driver-needs-it drivers/net/fs_enet/Kconfig
--- a/drivers/net/fs_enet/Kconfig~powerpc-fs_enet-select-phylib-as-the-driver-needs-it
+++ a/drivers/net/fs_enet/Kconfig
@@ -1,7 +1,8 @@
 config FS_ENET
-       tristate "Freescale Ethernet Driver"
-       depends on CPM1 || CPM2
-       select MII
+	tristate "Freescale Ethernet Driver"
+	depends on CPM1 || CPM2
+	select MII
+	select PHYLIB
 
 config FS_ENET_HAS_SCC
 	bool "Chip has an SCC usable for ethernet"
_

Patches currently in -mm which might be from jochen@scram.de are

powerpc-kill-non-existent-symbols-from-ksyms-and-commproch.patch
powerpc-fix-fs_enet-module-build.patch
powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch
powerpc-fix-typo-ifdef-ifndef.patch
