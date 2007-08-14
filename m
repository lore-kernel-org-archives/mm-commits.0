From: akpm@linux-foundation.org
Subject: - acpi-ec-remove-potential-deadlock-from-ec.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:00 -0700
Message-ID: <200708141912.l7EJC0HS016342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933813AbXHNTML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: astarikivskiy@suse.de, astarikovskiy@suse.de, mm-commits@vger.kernel.org


The patch titled
     ACPI EC: remove potential deadlock from EC
has been removed from the -mm tree.  Its filename was
     acpi-ec-remove-potential-deadlock-from-ec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
