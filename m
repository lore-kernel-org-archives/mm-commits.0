From: akpm@linux-foundation.org
Subject: + gdth-try-to-fix-the-timer-at-exit-problem.patch added to -mm tree
Date: Tue, 12 Feb 2008 11:47:39 -0800
Message-ID: <200802121947.m1CJld94019091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbYBLTtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 14:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, davemilter@gmail.com


The patch titled
     gdth: Try to fix the Timer at exit problem
has been added to the -mm tree.  Its filename is
     gdth-try-to-fix-the-timer-at-exit-problem.patch

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
Subject: gdth: Try to fix the Timer at exit problem
From: Boaz Harrosh <bharrosh@panasas.com>

Remove_sync the timer before we delete the cards.

Testing-patches: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Dave Milter" <davemilter@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-try-to-fix-the-timer-at-exit-problem drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-try-to-fix-the-timer-at-exit-problem
+++ a/drivers/scsi/gdth.c
@@ -5100,6 +5100,9 @@ static int __init gdth_pci_probe_one(gdt
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
@@ -5135,8 +5138,6 @@ static void gdth_remove_one(gdth_ha_str 
 		ha->sdev = NULL;
 	}
 
-	gdth_flush(ha);
-
 	if (shp->irq)
 		free_irq(shp->irq,ha);
 
@@ -5234,14 +5235,15 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major,"gdth");
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

origin.patch
gdth-try-to-fix-the-timer-at-exit-problem.patch
