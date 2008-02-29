From: akpm@linux-foundation.org
Subject: + watchdog-hpwdt-fix-return-value-warning.patch added to -mm tree
Date: Fri, 29 Feb 2008 14:49:11 -0800
Message-ID: <200802292249.m1TMnBaH024772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYB2Wtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 17:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, Thomas.Mingarelli@hp.com, rolandd@cisco.com, wim@iguana.be


The patch titled
     watchdog: hpwdt: fix return value warning
has been added to the -mm tree.  Its filename is
     watchdog-hpwdt-fix-return-value-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: hpwdt: fix return value warning
From: Roland Dreier <rdreier@cisco.com>

The return value of smbios_scan_machine() is never used, and when it
succeeds it doesn't return anything, so just make it void.  This fixes:

    drivers/watchdog/hpwdt.c: In function 'smbios_scan_machine':
    drivers/watchdog/hpwdt.c:562: warning: control reaches end of non-void function

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/watchdog/hpwdt.c~watchdog-hpwdt-fix-return-value-warning drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~watchdog-hpwdt-fix-return-value-warning
+++ a/drivers/watchdog/hpwdt.c
@@ -528,20 +528,19 @@ static int __devinit smbios_present(cons
 	return -ENODEV;
 }
 
-static int __devinit smbios_scan_machine(void)
+static void __devinit smbios_scan_machine(void)
 {
 	char __iomem *p, *q;
-	int rc;
 
 	if (efi_enabled) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			return -ENODEV;
+			return;
 
 		p = ioremap(efi.smbios, 32);
 		if (p == NULL)
-			return -ENOMEM;
+			return;
 
-		rc = smbios_present(p);
+		smbios_present(p);
 		iounmap(p);
 	} else {
 		/*
@@ -549,14 +548,12 @@ static int __devinit smbios_scan_machine
 		 */
 		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
 		if (p == NULL)
-			return -ENOMEM;
+			return;
 
-		for (q = p; q < p + ROM_SIZE; q += 16) {
-			rc = smbios_present(q);
-			if (!rc) {
+		for (q = p; q < p + ROM_SIZE; q += 16)
+			if (!smbios_present(q))
 				break;
-			}
-		}
+
 		iounmap(p);
 	}
 }
_

Patches currently in -mm which might be from rdreier@cisco.com are

input-i8042-fix-warning-on-non-x86-builds.patch
git-net.patch
watchdog-hpwdt-fix-declaration-of-struct-smbios_entry_point.patch
watchdog-hpwdt-fix-return-value-warning.patch
watchdog-hpwdt-use-dmi_walk-instead-of-own-copy.patch

