From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-update-version-and-changelog.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:32:41 -0700
Message-ID: <200709141032.l8EAWfmA000569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323AbXINKcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bo.yang@lsi.com, James.Bottomley@steeleye.com


The patch titled
     scsi: megaraid_sas: update version and Changelog
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-update-version-and-changelog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: megaraid_sas: update version and Changelog
From: Bo Yang <bo.yang@lsi.com>

Update version and Changelog

Signed-off-by: Bo Yang <bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.megaraid_sas |  236 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 
 drivers/scsi/megaraid/megaraid_sas.h      |    6 
 3 files changed, 240 insertions(+), 4 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-update-version-and-changelog Documentation/scsi/ChangeLog.megaraid_sas
--- a/Documentation/scsi/ChangeLog.megaraid_sas~scsi-megaraid_sas-update-version-and-changelog
+++ a/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,239 @@
+1 Release Date    : Tue. Aug. 14 10:09:32 PDT 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+
+2 Current Version : 00.00.03.14-RC2
+3 Older Version   : 00.00.03.13
+
+1. convert to use the data buffer accessors
+
+>From: James Bottomley [mailto:jejb@kernel.org]
+>Sent: Thursday, May 31, 2007 3:40 PM
+>To: FUJITA Tomonori; Patro, Sumant; James Bottomley
+>Subject: Patch added to scsi-misc-2.6: [SCSI] megaraid_sas: convert to use the data buffer accessors
+    - remove the unnecessary map_single path.
+    - convert to use the new accessors for the sg lists and the
+    parameters.
+
+2. Clean up the codes and take off the compile warning.
+
+1 Release Date    : Thu. May. 31 11:25:21 PDT 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+
+2 Current Version : 00.00.03.13
+3 Older Version   : 00.00.03.12
+
+1.	Added the megasas_reset_timer routine to intercept cmd timeout
+	and throttle io.
+
+On Fri, 2007-03-16 at 16:44 -0600, James Bottomley wrote:
+It looks like megaraid_sas at least needs this to throttle its commands
+> as they begin to time out.  The code keeps the existing transport
+> template use of eh_timed_out (and allows the transport to override the
+> host if they both have this callback).
+>
+> James
+
+1 Release Date    : Sat. May. 14 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.12
+3 Older Version   : 00.00.03.11
+
+1.  When MegaSAS driver receives reset call from OS, driver waits in reset
+routine for max 3 minutes for all pending command completion. Now driver will
+call completion routine every 5 seconds from the reset routine instead of
+waiting for cmd completion from isr path.
+
+1 Release Date    : Mon Apr. 30 10:25:52 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.11
+3 Older Version   : 00.00.03.10
+
+	1. Following module parameters added -
+		fast_load: Faster loading of the driver, skips physical devices
+		cmd_per_lun: Maximum number of commands per logical unit
+		max_sectors: Maximum number of sectors per IO command
+	2. Hibernation support added
+	3. Performing diskdump while running IO in RHEL 4 was failing. Fixed.
+
+1 Release Date    : Wed Mar. 28 10:25:52 PST 2007
+2 Current Version : 00.00.03.10
+3 Older Version   : 00.00.03.09
+
+i.	Replaced pci_alloc_consistent with dma_alloc_coherent in ioctl path
+ii.	eh_timed_out call back (megasas_reset_timer) is now used to throttle io to the
+	adapter when it is called the first time for a scmd.
+	The MEGASAS_FW_BUSY flag is set and can_queue reduced to 16. The can_queue is
+	restored from completion routine in following two conditions :
+	5 seconds has elapsed and the # of outstanding cmds in FW is < 17.
+	This implementation replaces the throttling mechanism of 3.08 ver.
+
+On Thu, 2007-02-15 at 19:53 -0700, Patro, Sumant wrote:
+> Hello James,
+>
+>       I re-submitted the patch yesterday with the "space" issue fixed
+> (adhering to coding guideline).
+>
+>       I will check for alternative to calculate the time driver have
+> been sending host busy to OS. Will check with time_before() as you have
+> suggested.
+>
+>       Throttling from megasas_generic_reset() handler did not help.
+> megaraid does not have feature to abort cmds. So, in the generic reset
+> routine, the driver just waits for cmd completion by FW. These timed-out
+> cmds gets retried by mid-layer with "retries" incremented by 1.
+> Eventually we see retries equals max_allowed followed by SCSI error with
+> "DRIVER_TIMEOUT".
+
+That's rather what worries me.  When the error handler activates (which
+it will on the first timeout), it waits for all commands to complete or
+time out before running.  Your reset handler does nothing other than
+wait for the firmware to complete the commands (now uselessly), so we
+now wait for the entire firmware command queue to drain, then you tell
+the mid layer everything is OK, so it loads you up again with all the
+commands plus a few test unit readies for good measure, then you
+throttle.
+
+You really want to catch the device going into this condition and do
+something at that point ... prime candidate would be lowering the
+can_queue depth to get fewer commands transiting the firmware.
+
+James <James.Bottomley@SteelEye.com>
+
+On Thu, 2007-03-01 at 13:29 -0800, Sumant Patro wrote:
+> Driver to throttle IO to reduce risk of OS timing out cmds.
+>
+> Implemented a circular queue to keep track of pending OS cmds in FW.
+> This queue is periodically (every 10 sec) checked by a timer routine.
+> If there is any cmd that is in risk of getting timed-out by the OS,
+> the host->can_queue is reduced to 16 and MEGASAS_FW_BUSY flag is set.
+> The host->can_queue will be restored to default value when the following
+> two conditions are met : 5 secs has elapsed and the # of outstanding cmds
+> in FW is less than 17.
+> Also increased the per cmd timeout to 120*HZ from 90*HZ.
+
+OK, this is still not nice.  What you need to be doing is intercepting
+the timeout before it fires (and quiesces the machine).  Currently the
+eh_timed_out() callback is only exposed to transport classes, I'll put
+it back into the host template and then you can use it.
+
+James <James.Bottomley@SteelEye.com>
+
+Fri, 16 Mar 2007 16:44:41 -0600  (15:44 PDT)
+
+It looks like megaraid_sas at least needs this to throttle its commands
+as they begin to time out.  The code keeps the existing transport
+template use of eh_timed_out (and allows the transport to override the
+host if they both have this callback).
+
+James <James.Bottomley@SteelEye.com>
+
+diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
+index b8edcf5..7a1a1bb 100644
+--- a/drivers/scsi/scsi_error.c
++++ b/drivers/scsi/scsi_error.c
+@@ -184,10 +184,19 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
+  **/
+ void scsi_times_out(struct scsi_cmnd *scmd)
+ {
++       enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
++
+        scsi_log_completion(scmd, TIMEOUT_ERROR);
+
+        if (scmd->device->host->transportt->eh_timed_out)
+-               switch (scmd->device->host->transportt->eh_timed_out(scmd)) {
++               eh_timed_out = scmd->device->host->transportt->eh_timed_out;
++       else if (scmd->device->host->hostt->eh_timed_out)
++               eh_timed_out = scmd->device->host->hostt->eh_timed_out;
++       else
++               eh_timed_out = NULL;
++
++       if (eh_timed_out)
++               switch (eh_timed_out(scmd)) {
+                case EH_HANDLED:
+                        __scsi_done(scmd);
+                        return;
+diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
+index 965b6b8..68f461b 100644
+--- a/include/scsi/scsi_host.h
++++ b/include/scsi/scsi_host.h
+@@ -326,6 +326,19 @@ struct scsi_host_template {
+        int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
+
+        /*
++        * This is an optional routine that allows the transport to become
++        * involved when a scsi io timer fires. The return value tells the
++        * timer routine how to finish the io timeout handling:
++        * EH_HANDLED:          I fixed the error, please complete the command
++        * EH_RESET_TIMER:      I need more time, reset the timer and
++        *                      begin counting again
++        * EH_NOT_HANDLED       Begin normal error recovery
++        *
++        * Status: OPTIONAL
++        */
++       enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
++
++       /*
+         * suspend support
+         */
+        int (*resume)(struct scsi_device *);
+
+1 Release Date    : Fri Feb. 09 14:36:28 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.09
+3 Older Version   : 00.00.03.08
+
+i.	Under heavy IO mid-layer prints "DRIVER_TIMEOUT" errors
+
+	The driver now waits for 10 seconds to elapse instead of 5 (as in
+	previous release) to resume IO when FW busy is set.
+
+1 Release Date    : Mon Feb. 05 11:35:24 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+2 Current Version : 00.00.03.08
+3 Older Version   : 00.00.03.07
+
+i.	Under heavy IO mid-layer prints "DRIVER_TIMEOUT" errors
+
+	Fix:	The driver is now throttling IO.
+	Checks added in megasas_queue_command to know if FW is able to
+	process commands within timeout period. If number of retries
+	is 2 or greater,the driver stops sending cmd to FW temporarily. IO is
+	resumed if pending cmd count reduces to 16 or 5 seconds has elapsed
+	from the time cmds were last sent to FW.
+
+ii.	FW enables WCE bit in Mode Sense cmd for drives that are configured
+	as WriteBack. The OS may send "SYNCHRONIZE_CACHE" cmd when Logical
+	Disks are exposed with WCE=1. User is advised to enable Write Back
+	mode only when the controller has battery backup. At this time
+	Synhronize cache is not supported by the FW. Driver will short-cycle
+	the cmd and return sucess without sending down to FW.
+
+1 Release Date    : Sun Jan. 14 11:21:32 PDT 2007 -
+		 Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
+2 Current Version : 00.00.03.07
+3 Older Version   : 00.00.03.06
+
+i.	bios_param entry added in scsi_host_template that returns disk geometry
+	information.
+
+1 Release Date    : Fri Oct 20 11:21:32 PDT 2006 - Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
+2 Current Version : 00.00.03.06
+3 Older Version   : 00.00.03.05
+
+1. Added new memory management module to support the IOCTL memory allocation. For IOCTL we try to allocate from the memory pool created during driver initialization. If mem pool is empty then we allocate at run time.
+2. Added check in megasas_queue_command and dpc/isr routine to see if we have already declared adapter dead
+   (hw_crit_error=1). If hw_crit_error==1, now we donot accept any processing of pending cmds/accept any cmd from OS
 
 1 Release Date    : Mon Oct 02 11:21:32 PDT 2006 - Sumant Patro <Sumant.Patro@lsil.com>
 2 Current Version : 00.00.03.05
diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-version-and-changelog drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-update-version-and-changelog
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.10-rc5
+ * Version	: v00.00.03.14-rc2
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-version-and-changelog drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-update-version-and-changelog
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.10-rc5"
-#define MEGASAS_RELDATE				"May 17, 2007"
-#define MEGASAS_EXT_VERSION			"Thu May 17 10:09:32 PDT 2007"
+#define MEGASAS_VERSION				"00.00.03.14-rc2"
+#define MEGASAS_RELDATE				"Aug. 14, 2007"
+#define MEGASAS_EXT_VERSION			"Tue Aug. 14 10:09:32 PDT 2007"
 
 /*
  * Device IDs
_

Patches currently in -mm which might be from bo.yang@lsi.com are

scsi-megaraid_sas-add-hibernation-support.patch
scsi-megaraid_sas-add-module-param-fast_load.patch
scsi-megaraid_sas-add-module-param-max_sectors-cmd_per_lun.patch
scsi-megaraid_sas-update-version-and-changelog.patch
