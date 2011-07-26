From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:12 -0700
Message-ID: <201107260751.p6Q7pF20002935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab1GZHv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.stein@systec-electronic.com, gregkh@suse.de, tomoya-linux@dsn.okisemi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/pch_phub.c: don't oops if dmi_get_system_info returns NULL
has been removed from the -mm tree.  Its filename was
     drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/pch_phub.c: don't oops if dmi_get_system_info returns NULL
From: Alexander Stein <alexander.stein@systec-electronic.com>

If dmi_get_system_info() returns NULL, pch_phub_probe() will dereferencea
a zero pointer.

This oops was observed on an Atom based board which has no BIOS, but a
bootloder which doesn't privde DMI data.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/misc/pch_phub.c~drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null
+++ a/drivers/misc/pch_phub.c
@@ -686,6 +686,8 @@ static int __devinit pch_phub_probe(stru
 	}
 
 	if (id->driver_data == 1) { /* EG20T PCH */
+		const char *board_name;
+
 		retval = sysfs_create_file(&pdev->dev.kobj,
 					   &dev_attr_pch_mac.attr);
 		if (retval)
@@ -701,7 +703,8 @@ static int __devinit pch_phub_probe(stru
 					       CLKCFG_CANCLK_MASK);
 
 		/* quirk for CM-iTC board */
-		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+		board_name = dmi_get_system_info(DMI_BOARD_NAME);
+		if (board_name && strstr(board_name, "CM-iTC"))
 			pch_phub_read_modify_write_reg(chip,
 						(unsigned int)CLKCFG_REG_OFFSET,
 						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

origin.patch
linux-next.patch

