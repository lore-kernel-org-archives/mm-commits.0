From: akpm@linux-foundation.org
Subject: + acpi-ec-remove-potential-deadlock-from-ec.patch added to -mm tree
Date: Thu, 09 Aug 2007 15:56:04 -0700
Message-ID: <200708092256.l79Mu4KG023791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbXHIW4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikivskiy@suse.de, astarikovskiy@suse.de


The patch titled
     ACPI EC: remove potential deadlock from EC
has been added to the -mm tree.  Its filename is
     acpi-ec-remove-potential-deadlock-from-ec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI EC: remove potential deadlock from EC
From: Alexey Starikovskiy <astarikivskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/acpi/ec.c~acpi-ec-remove-potential-deadlock-from-ec drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-remove-potential-deadlock-from-ec
+++ a/drivers/acpi/ec.c
@@ -710,9 +710,7 @@ static int acpi_ec_add(struct acpi_devic
 	/* Check if we found the boot EC */
 	if (boot_ec) {
 		if (boot_ec->gpe == ec->gpe) {
-			mutex_lock(&boot_ec->lock);
 			ec_remove_handlers(boot_ec);
-			mutex_unlock(&boot_ec->lock);
 			mutex_destroy(&boot_ec->lock);
 			kfree(boot_ec);
 			first_ec = boot_ec = NULL;
_

Patches currently in -mm which might be from astarikivskiy@suse.de are

git-acpi.patch
acpi-ec-remove-potential-deadlock-from-ec.patch
