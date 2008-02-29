From: akpm@linux-foundation.org
Subject: + gdth-bugfix-for-the-at-exit-problems.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:02:43 -0800
Message-ID: <200802290102.m1T12hH7030110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175AbYB2BFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, jchelton@ffpglobal.com, joerg@dorchain.net, s.priebe@allied-internet.ag


The patch titled
     gdth: bugfix for the at-exit problems
has been added to the -mm tree.  Its filename is
     gdth-bugfix-for-the-at-exit-problems.patch

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
Subject: gdth: bugfix for the at-exit problems
From: Boaz Harrosh <bharrosh@panasas.com>

gdth_exit would first remove all cards then stop the timer and would not sync
with the timer function.  This caused a crash in gdth_timer() when module was
unloaded.  So del_timer_sync the timer before we delete the cards.

Also the reboot notifier function would crash.  So clean that up and fix the
crashes.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   82 ++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 54 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-bugfix-for-the-at-exit-problems drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-bugfix-for-the-at-exit-problems
+++ a/drivers/scsi/gdth.c
@@ -182,7 +182,6 @@ static int gdth_ioctl(struct inode *inod
                       unsigned int cmd, unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
@@ -417,12 +416,6 @@ static inline void gdth_set_sglist(struc
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
-/* notifier block to get a notify on system shutdown/halt/reboot */
-static struct notifier_block gdth_notifier = {
-    gdth_halt, NULL, 0
-};
-static int notifier_disabled = 0;
-
 static gdth_ha_str *gdth_find_ha(int hanum)
 {
 	gdth_ha_str *ha;
@@ -3778,6 +3771,8 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    BUG_ON(list_empty(&gdth_instances));
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
@@ -4653,45 +4648,6 @@ static void gdth_flush(gdth_ha_str *ha)
     }
 }
 
-/* shutdown routine */
-static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
-{
-    gdth_ha_str *ha;
-#ifndef __alpha__
-    gdth_cmd_str    gdtcmd;
-    char            cmnd[MAX_COMMAND_SIZE];   
-#endif
-
-    if (notifier_disabled)
-        return NOTIFY_OK;
-
-    TRACE2(("gdth_halt() event %d\n",(int)event));
-    if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
-        return NOTIFY_DONE;
-
-    notifier_disabled = 1;
-    printk("GDT-HA: Flushing all host drives .. ");
-    list_for_each_entry(ha, &gdth_instances, list) {
-        gdth_flush(ha);
-
-#ifndef __alpha__
-        /* controller reset */
-        memset(cmnd, 0xff, MAX_COMMAND_SIZE);
-        gdtcmd.BoardNode = LOCALBOARD;
-        gdtcmd.Service = CACHESERVICE;
-        gdtcmd.OpCode = GDT_RESET;
-        TRACE2(("gdth_halt(): reset controller %d\n", ha->hanum));
-        gdth_execute(ha->shost, &gdtcmd, cmnd, 10, NULL);
-#endif
-    }
-    printk("Done.\n");
-
-#ifdef GDTH_STATISTICS
-    del_timer(&gdth_timer);
-#endif
-    return NOTIFY_OK;
-}
-
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5134,13 +5090,13 @@ static void gdth_remove_one(gdth_ha_str 
 
 	scsi_remove_host(shp);
 
+	gdth_flush(ha);
+
 	if (ha->sdev) {
 		scsi_free_host_dev(ha->sdev);
 		ha->sdev = NULL;
 	}
 
-	gdth_flush(ha);
-
 	if (shp->irq)
 		free_irq(shp->irq,ha);
 
@@ -5166,6 +5122,24 @@ static void gdth_remove_one(gdth_ha_str 
 	scsi_host_put(shp);
 }
 
+static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
+{
+	gdth_ha_str *ha;
+
+	TRACE2(("gdth_halt() event %d\n", (int)event));
+	if (event != SYS_RESTART && event != SYS_HALT && event != SYS_POWER_OFF)
+		return NOTIFY_DONE;
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_flush(ha);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gdth_notifier = {
+    gdth_halt, NULL, 0
+};
+
 static int __init gdth_init(void)
 {
 	if (disable) {
@@ -5220,7 +5194,6 @@ static int __init gdth_init(void)
 	add_timer(&gdth_timer);
 #endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
-	notifier_disabled = 0;
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
@@ -5235,14 +5208,15 @@ static void __exit gdth_exit(void)
 		pci_unregister_driver(&gdth_pci_driver);
 #endif
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major, "gdth");
+	unregister_reboot_notifier(&gdth_notifier);
 
 #ifdef GDTH_STATISTICS
-	del_timer(&gdth_timer);
+	del_timer_sync(&gdth_timer);
 #endif
-	unregister_chrdev(major,"gdth");
-	unregister_reboot_notifier(&gdth_notifier);
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
 }
 
 module_init(gdth_init);
_

Patches currently in -mm which might be from bharrosh@panasas.com are

gdth-bugfix-for-the-at-exit-problems.patch
gdth-fix-to-internal-commands-execution.patch
gdth-remove-gdth-cooked-up-command-accessors.patch

