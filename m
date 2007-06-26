From: akpm@linux-foundation.org
Subject: + cdrom_sysctl_info-fix.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:45:48 -0700
Message-ID: <200706261945.l5QJjmtY000877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224AbXFZTp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, jens.axboe@oracle.com


The patch titled
     cdrom_sysctl_info fix
has been added to the -mm tree.  Its filename is
     cdrom_sysctl_info-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cdrom_sysctl_info fix
From: Dave Young <hidave.darkstar@gmail.com>

cdrom_sysctl_info may cause buffer overwrite.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |  186 +++++++++++++++++++++-------------------
 1 files changed, 102 insertions(+), 84 deletions(-)

diff -puN drivers/cdrom/cdrom.c~cdrom_sysctl_info-fix drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom_sysctl_info-fix
+++ a/drivers/cdrom/cdrom.c
@@ -3290,102 +3290,120 @@ static struct cdrom_sysctl_settings {
 } cdrom_sysctl_settings;
 
 static int cdrom_sysctl_info(ctl_table *ctl, int write, struct file * filp,
-                           void __user *buffer, size_t *lenp, loff_t *ppos)
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-        int pos;
+	int pos;
 	struct cdrom_device_info *cdi;
 	char *info = cdrom_sysctl_settings.info;
+	int size = sizeof(cdrom_sysctl_settings.info);
 	
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
 
-	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
+	pos = scnprintf(info, size, "CD-ROM information, " VERSION "\n");
 	
-	pos += sprintf(info+pos, "\ndrive name:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%s", cdi->name);
-
-	pos += sprintf(info+pos, "\ndrive speed:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->speed);
-
-	pos += sprintf(info+pos, "\ndrive # of slots:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->capacity);
-
-	pos += sprintf(info+pos, "\nCan close tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CLOSE_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan open tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_OPEN_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan lock tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_LOCK) != 0);
-
-	pos += sprintf(info+pos, "\nCan change speed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_SPEED) != 0);
-
-	pos += sprintf(info+pos, "\nCan select disk:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_DISC) != 0);
-
-	pos += sprintf(info+pos, "\nCan read multisession:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MULTI_SESSION) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MCN:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MCN) != 0);
-
-	pos += sprintf(info+pos, "\nReports media changed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
-
-	pos += sprintf(info+pos, "\nCan play audio:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_PLAY_AUDIO) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-R:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-RW:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_RW) != 0);
-
-	pos += sprintf(info+pos, "\nCan read DVD:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-R:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-RAM:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW) != 0);
-
-	pos += sprintf(info+pos, "\nCan write MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
-
-	pos += sprintf(info+pos, "\nCan write RAM:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
+	pos += scnprintf(info + pos, size - pos, "\ndrive name:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%s", cdi->name);
+
+	pos += scnprintf(info + pos, size - pos, "\ndrive speed:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", cdi->speed);
+
+	pos += scnprintf(info + pos, size - pos, "\ndrive # of slots:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d", cdi->capacity);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan close tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_CLOSE_TRAY) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan open tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_OPEN_TRAY) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan lock tray:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_LOCK) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan change speed:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_SELECT_SPEED) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan select disk:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_SELECT_DISC) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read multisession:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_MULTI_SESSION) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read MCN:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_MCN) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nReports media changed:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan play audio:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_PLAY_AUDIO) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write CD-R:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_CD_R) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write CD-RW:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_CD_RW) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read DVD:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_DVD) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write DVD-R:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_DVD_R) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write DVD-RAM:");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_DVD_RAM) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan read MRW:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_MRW) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write MRW:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_MRW_W) != 0);
+
+	pos += scnprintf(info + pos, size - pos, "\nCan write RAM:\t");
+	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
+		pos += scnprintf(info + pos, size - pos, "\t%d",
+					CDROM_CAN(CDC_RAM) != 0);
 
-	strcpy(info+pos,"\n\n");
+	scnprintf(info + pos, size - pos, "\n\n");
 		
-        return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+	return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
 }
 
 /* Unfortunately, per device settings are not implemented through
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

cdrom_sysctl_info-fix.patch
remove-useless-tolower-in-isofs.patch
