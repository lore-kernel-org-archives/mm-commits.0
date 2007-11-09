From: akpm@linux-foundation.org
Subject: + powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:05:23 -0800
Message-ID: <200711090405.lA945Nti028559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758361AbXKIEFj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:05:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jochen@scram.de, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org


The patch titled
     powerpc: fs_enet: select PHYLIB as the driver needs it.
has been added to the -mm tree.  Its filename is
     powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
powerpc-fs_enet-select-phylib-as-the-driver-needs-it.patch
powerpc-fix-typo-ifdef-ifndef.patch
