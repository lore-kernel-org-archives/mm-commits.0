From: akpm@linux-foundation.org
Subject: - dcdbas-add-dmi-based-module-autloading.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:05 -0800
Message-ID: <200802070020.m170KkF3006187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933930AbYBGAVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Matt_Domsch@dell.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     dcdbas: add DMI-based module autloading
has been removed from the -mm tree.  Its filename was
     dcdbas-add-dmi-based-module-autloading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
