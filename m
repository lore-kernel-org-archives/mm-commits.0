From: akpm@osdl.org
Subject: - correct-bus_num-and-buffer-bug-in-spi-core.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:23 -0800
Message-ID: <200612072302.kB7N2N3f029847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51702 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163794AbWLGXCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: correct bus_num and buffer bug in spi core
has been removed from the -mm tree.  Its filename was
     correct-bus_num-and-buffer-bug-in-spi-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: correct bus_num and buffer bug in spi core
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Correct the following in driver/spi/spi.c in function spi_busnum_to_master:

 * must allow bus_num 0, the if is really not needed.
 * correct the name buffer which is too small for bus_num >= 10000. It

should be 9 bytes big, not 8.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi.c~correct-bus_num-and-buffer-bug-in-spi-core drivers/spi/spi.c
--- a/drivers/spi/spi.c~correct-bus_num-and-buffer-bug-in-spi-core
+++ a/drivers/spi/spi.c
@@ -465,15 +465,13 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
  */
 struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
-	if (bus_num) {
-		char			name[8];
-		struct kobject		*bus;
-
-		snprintf(name, sizeof name, "spi%u", bus_num);
-		bus = kset_find_obj(&spi_master_class.subsys.kset, name);
-		if (bus)
-			return container_of(bus, struct spi_master, cdev.kobj);
-	}
+	char			name[9];
+	struct kobject		*bus;
+
+	snprintf(name, sizeof name, "spi%u", bus_num);
+	bus = kset_find_obj(&spi_master_class.subsys.kset, name);
+	if (bus)
+		return container_of(bus, struct spi_master, cdev.kobj);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

origin.patch

