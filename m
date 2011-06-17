From: akpm@linux-foundation.org
Subject: + drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch added to -mm tree
Date: Fri, 17 Jun 2011 15:00:47 -0700
Message-ID: <201106172200.p5HM0lAo003603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875Ab1FQWAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 18:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.stein@systec-electronic.com, gregkh@suse.de, tomoya-linux@dsn.okisemi.com


The patch titled
     drivers/misc/pch_phub.c: don't oops if dmi_get_system_info returns NULL
has been added to the -mm tree.  Its filename is
     drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-misc-pch_phubc-dont-oops-if-dmi_get_system_info-returns-null.patch

