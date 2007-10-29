From: akpm@linux-foundation.org
Subject: + dcdbas-add-dmi-based-module-autloading.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:34:47 -0700
Message-ID: <200710292134.l9TLYl8G024417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbXJ2Vew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Matt_Domsch@dell.com, kay.sievers@vrfy.org


The patch titled
     dcdbas: add DMI-based module autloading
has been added to the -mm tree.  Its filename is
     dcdbas-add-dmi-based-module-autloading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dcdbas: add DMI-based module autloading
From: Matt Domsch <Matt_Domsch@dell.com>

DMI autoload dcdbas on all Dell systems.

This looks for BIOS Vendor or System Vendor == Dell, so this should
work for systems both Dell-branded and those Dell builds but brands
for others.  It causes udev to load the dcdbas module at startup,
which is used by tools called by HAL for wireless control and
backlight control, among other uses.

Thanks to Kay Sievers for figuring out how to do this with a single alias.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/firmware/dcdbas.c~dcdbas-add-dmi-based-module-autloading drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~dcdbas-add-dmi-based-module-autloading
+++ a/drivers/firmware/dcdbas.c
@@ -658,4 +658,5 @@ MODULE_DESCRIPTION(DRIVER_DESCRIPTION " 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_AUTHOR("Dell Inc.");
 MODULE_LICENSE("GPL");
-
+/* Any System or BIOS claiming to be by Dell */
+MODULE_ALIAS("dmi:*:[bs]vnD[Ee][Ll][Ll]*:*");
_

Patches currently in -mm which might be from Matt_Domsch@dell.com are

pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
dcdbas-add-dmi-based-module-autloading.patch
