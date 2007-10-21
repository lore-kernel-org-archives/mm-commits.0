From: akpm@linux-foundation.org
Subject: - onenand-sim-fix-kernel-doc-and-typos.patch removed from -mm tree
Date: Sun, 21 Oct 2007 15:07:39 -0700
Message-ID: <200710212207.l9LM7d1W029734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXJUWH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 18:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     onenand-sim: fix kernel-doc and typos
has been removed from the -mm tree.  Its filename was
     onenand-sim-fix-kernel-doc-and-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: onenand-sim: fix kernel-doc and typos
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct kernel-doc notation and descriptions.  Correct other typos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_sim.c |   49 ++++++++++++++--------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff -puN drivers/mtd/onenand/onenand_sim.c~onenand-sim-fix-kernel-doc-and-typos drivers/mtd/onenand/onenand_sim.c
--- a/drivers/mtd/onenand/onenand_sim.c~onenand-sim-fix-kernel-doc-and-typos
+++ a/drivers/mtd/onenand/onenand_sim.c
@@ -88,11 +88,11 @@ do {									\
 
 /**
  * onenand_lock_handle - Handle Lock scheme
- * @param this		OneNAND device structure
- * @param cmd		The command to be sent
+ * @this:		OneNAND device structure
+ * @cmd:		The command to be sent
  *
  * Send lock command to OneNAND device.
- * The lock scheme is depends on chip type.
+ * The lock scheme depends on chip type.
  */
 static void onenand_lock_handle(struct onenand_chip *this, int cmd)
 {
@@ -131,8 +131,8 @@ static void onenand_lock_handle(struct o
 
 /**
  * onenand_bootram_handle - Handle BootRAM area
- * @param this		OneNAND device structure
- * @param cmd		The command to be sent
+ * @this:		OneNAND device structure
+ * @cmd:		The command to be sent
  *
  * Emulate BootRAM area. It is possible to do basic operation using BootRAM.
  */
@@ -153,10 +153,10 @@ static void onenand_bootram_handle(struc
 
 /**
  * onenand_update_interrupt - Set interrupt register
- * @param this         OneNAND device structure
- * @param cmd          The command to be sent
+ * @this:         OneNAND device structure
+ * @cmd:          The command to be sent
  *
- * Update interrupt register. The status is depends on command.
+ * Update interrupt register. The status depends on command.
  */
 static void onenand_update_interrupt(struct onenand_chip *this, int cmd)
 {
@@ -189,11 +189,12 @@ static void onenand_update_interrupt(str
 }
 
 /**
- * onenand_check_overwrite - Check over-write if happend
- * @param dest		The destination pointer
- * @param src		The source pointer
- * @param count		The length to be check
- * @return		0 on same, otherwise 1
+ * onenand_check_overwrite - Check if over-write happened
+ * @dest:		The destination pointer
+ * @src:		The source pointer
+ * @count:		The length to be check
+ *
+ * Returns:		0 on same, otherwise 1
  *
  * Compare the source with destination
  */
@@ -213,10 +214,10 @@ static int onenand_check_overwrite(void 
 
 /**
  * onenand_data_handle - Handle OneNAND Core and DataRAM
- * @param this		OneNAND device structure
- * @param cmd		The command to be sent
- * @param dataram	Which dataram used
- * @param offset	The offset to OneNAND Core
+ * @this:		OneNAND device structure
+ * @cmd:		The command to be sent
+ * @dataram:		Which dataram used
+ * @offset:		The offset to OneNAND Core
  *
  * Copy data from OneNAND Core to DataRAM (read)
  * Copy data from DataRAM to OneNAND Core (write)
@@ -295,8 +296,8 @@ static void onenand_data_handle(struct o
 
 /**
  * onenand_command_handle - Handle command
- * @param this		OneNAND device structure
- * @param cmd		The command to be sent
+ * @this:		OneNAND device structure
+ * @cmd:		The command to be sent
  *
  * Emulate OneNAND command.
  */
@@ -350,8 +351,8 @@ static void onenand_command_handle(struc
 
 /**
  * onenand_writew - [OneNAND Interface] Emulate write operation
- * @param value		value to write
- * @param addr		address to write
+ * @value:		value to write
+ * @addr:		address to write
  *
  * Write OneNAND register with value
  */
@@ -373,7 +374,7 @@ static void onenand_writew(unsigned shor
 
 /**
  * flash_init - Initialize OneNAND simulator
- * @param flash		OneNAND simulaotr data strucutres
+ * @flash:		OneNAND simulator data strucutres
  *
  * Initialize OneNAND simulator.
  */
@@ -416,7 +417,7 @@ static int __init flash_init(struct onen
 
 /**
  * flash_exit - Clean up OneNAND simulator
- * @param flash		OneNAND simulaotr data strucutres
+ * @flash:		OneNAND simulator data structures
  *
  * Clean up OneNAND simulator.
  */
@@ -449,7 +450,7 @@ static int __init onenand_sim_init(void)
 	info->onenand.write_word = onenand_writew;
 
 	if (flash_init(&info->flash)) {
-		printk(KERN_ERR "Unable to allocat flash.\n");
+		printk(KERN_ERR "Unable to allocate flash.\n");
 		kfree(ffchars);
 		kfree(info);
 		return -ENOMEM;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
profile-likely-unlikely-macros.patch
