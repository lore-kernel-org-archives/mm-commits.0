From: akpm@linux-foundation.org
Subject: + cdrom_sysctl_info-fix.patch added to -mm tree
Date: Tue, 26 Jun 2007 21:39:25 -0700
Message-ID: <200706270439.l5R4dTGC009939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbXF0Ejq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 00:39:46 -0400
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

 drivers/cdrom/cdrom.c |  216 +++++++++++++++++++++++-----------------
 1 file changed, 125 insertions(+), 91 deletions(-)

diff -puN drivers/cdrom/cdrom.c~cdrom_sysctl_info-fix drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom_sysctl_info-fix
+++ a/drivers/cdrom/cdrom.c
@@ -302,7 +302,7 @@ module_param(lockdoor, bool, 0);
 module_param(check_media_type, bool, 0);
 module_param(mrw_format_restart, bool, 0);
 
-static DEFINE_SPINLOCK(cdrom_lock);
+static DEFINE_MUTEX(cdrom_mutex);
 
 static const char *mrw_format_status[] = {
 	"not mrw",
@@ -438,10 +438,10 @@ int register_cdrom(struct cdrom_device_i
 		cdo->generic_packet = cdrom_dummy_generic_packet;
 
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
-	spin_lock(&cdrom_lock);
+	mutex_lock(&cdrom_mutex);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
-	spin_unlock(&cdrom_lock);
+	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
 #undef ENSURE
@@ -452,7 +452,7 @@ int unregister_cdrom(struct cdrom_device
 	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
 
 	prev = NULL;
-	spin_lock(&cdrom_lock);
+	mutex_lock(&cdrom_mutex);
 	cdi = topCdromPtr;
 	while (cdi && cdi != unreg) {
 		prev = cdi;
@@ -460,7 +460,7 @@ int unregister_cdrom(struct cdrom_device
 	}
 
 	if (cdi == NULL) {
-		spin_unlock(&cdrom_lock);
+		mutex_unlock(&cdrom_mutex);
 		return -2;
 	}
 	if (prev)
@@ -468,7 +468,7 @@ int unregister_cdrom(struct cdrom_device
 	else
 		topCdromPtr = cdi->next;
 
-	spin_unlock(&cdrom_lock);
+	mutex_unlock(&cdrom_mutex);
 
 	if (cdi->exit)
 		cdi->exit(cdi);
@@ -3289,103 +3289,137 @@ static struct cdrom_sysctl_settings {
 	int	check;			/* check media type */
 } cdrom_sysctl_settings;
 
+enum cdrom_print_option {
+	CTL_NAME,
+	CTL_SPEED,
+	CTL_SLOTS,
+	CTL_CAPABILITY
+};
+
+static int cdrom_print_info(const char *header, int val, char *info,
+				int *pos, enum cdrom_print_option option)
+{
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
+	struct cdrom_device_info *cdi;
+	int ret;
+
+	ret = scnprintf(info + *pos, max_size - *pos, header);
+	if (!ret)
+		return 1;
+
+	*pos += ret;
+
+	for (cdi = topCdromPtr; cdi; cdi = cdi->next) {
+		switch (option) {
+		case CTL_NAME:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%s", cdi->name);
+			break;
+		case CTL_SPEED:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->speed);
+			break;
+		case CTL_SLOTS:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->capacity);
+			break;
+		case CTL_CAPABILITY:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", CDROM_CAN(val) != 0);
+			break;
+		default:
+			printk(KERN_INFO "cdrom: invalid option%d\n", option);
+			return 1;
+		}
+		if (!ret)
+			return 1;
+		*pos += ret;
+	}
+
+	return 0;
+}
+
 static int cdrom_sysctl_info(ctl_table *ctl, int write, struct file * filp,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-        int pos;
-	struct cdrom_device_info *cdi;
+	int pos;
 	char *info = cdrom_sysctl_settings.info;
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
 	
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
 
+	mutex_lock(&cdrom_mutex);
+
 	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
 	
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
-
-	strcpy(info+pos,"\n\n");
-		
-        return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
+		goto done;
+	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
+		goto done;
+	if (cdrom_print_info("\ndrive # of slots:", 0, info, &pos, CTL_SLOTS))
+		goto done;
+	if (cdrom_print_info("\nCan close tray:\t",
+				CDC_CLOSE_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan open tray:\t",
+				CDC_OPEN_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan lock tray:\t",
+				CDC_LOCK, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan change speed:",
+				CDC_SELECT_SPEED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan select disk:",
+				CDC_SELECT_DISC, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read multisession:",
+				CDC_MULTI_SESSION, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MCN:\t",
+				CDC_MCN, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nReports media changed:",
+				CDC_MEDIA_CHANGED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan play audio:\t",
+				CDC_PLAY_AUDIO, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-R:\t",
+				CDC_CD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-RW:",
+				CDC_CD_RW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read DVD:\t",
+				CDC_DVD, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-R:",
+				CDC_DVD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-RAM:",
+				CDC_DVD_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MRW:\t",
+				CDC_MRW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write MRW:\t",
+				CDC_MRW_W, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write RAM:\t",
+				CDC_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
+		goto done;
+doit:
+	mutex_unlock(&cdrom_mutex);
+	return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+done:
+	printk(KERN_INFO "cdrom: info buffer too small\n");
+	goto doit;
 }
 
 /* Unfortunately, per device settings are not implemented through
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

cdrom_sysctl_info-fix.patch
remove-useless-tolower-in-isofs.patch
