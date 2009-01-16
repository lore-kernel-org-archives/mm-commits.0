From: akpm@linux-foundation.org
Subject: [merged] synclink_gt-enable-ri-interrupt.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:47 -0800
Message-ID: <200901161916.n0GJGlf6025362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520AbZAPTTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: enable RI interrupt
has been removed from the -mm tree.  Its filename was
     synclink_gt-enable-ri-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: enable RI interrupt
From: Paul Fulghum <paulkf@microgate.com>

- Enable ring indicator interrupt.

- Remove vendor specific CVS version tags.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-enable-ri-interrupt drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-enable-ri-interrupt
+++ a/drivers/char/synclink_gt.c
@@ -1,6 +1,4 @@
 /*
- * $Id: synclink_gt.c,v 4.50 2007/07/25 19:29:25 paulkf Exp $
- *
  * Device driver for Microgate SyncLink GT serial adapters.
  *
  * written by Paul Fulghum for Microgate Corporation
@@ -91,7 +89,6 @@
  * module identification
  */
 static char *driver_name     = "SyncLink GT";
-static char *driver_version  = "$Revision: 4.50 $";
 static char *tty_driver_name = "synclink_gt";
 static char *tty_dev_prefix  = "ttySLG";
 MODULE_LICENSE("GPL");
@@ -1309,7 +1306,7 @@ static int read_proc(char *page, char **
 	off_t	begin = 0;
 	struct slgt_info *info;
 
-	len += sprintf(page, "synclink_gt driver:%s\n", driver_version);
+	len += sprintf(page, "synclink_gt driver\n");
 
 	info = slgt_device_list;
 	while( info ) {
@@ -2441,7 +2438,7 @@ static void program_hw(struct slgt_info 
 	info->ri_chkcount = 0;
 	info->dsr_chkcount = 0;
 
-	slgt_irq_on(info, IRQ_DCD | IRQ_CTS | IRQ_DSR);
+	slgt_irq_on(info, IRQ_DCD | IRQ_CTS | IRQ_DSR | IRQ_RI);
 	get_signals(info);
 
 	if (info->netcount ||
@@ -3576,7 +3573,7 @@ static void slgt_cleanup(void)
 	struct slgt_info *info;
 	struct slgt_info *tmp;
 
-	printk("unload %s %s\n", driver_name, driver_version);
+	printk(KERN_INFO "unload %s\n", driver_name);
 
 	if (serial_driver) {
 		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
@@ -3619,7 +3616,7 @@ static int __init slgt_init(void)
 {
 	int rc;
 
- 	printk("%s %s\n", driver_name, driver_version);
+	printk(KERN_INFO "%s\n", driver_name);
 
 	serial_driver = alloc_tty_driver(MAX_DEVICES);
 	if (!serial_driver) {
@@ -3650,9 +3647,8 @@ static int __init slgt_init(void)
 		goto error;
 	}
 
- 	printk("%s %s, tty major#%d\n",
-		driver_name, driver_version,
-		serial_driver->major);
+	printk(KERN_INFO "%s, tty major#%d\n",
+	       driver_name, serial_driver->major);
 
 	slgt_device_count = 0;
 	if ((rc = pci_register_driver(&pci_driver)) < 0) {
_

Patches currently in -mm which might be from paulkf@microgate.com are

origin.patch

