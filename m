From: akpm@linux-foundation.org
Subject: - sysctl-remove-broken-cdrom-binary-sysctls-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:47:55 -0700
Message-ID: <200710180847.l9I8ltQI002767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932342AbXJRIsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove broken cdrom binary sysctls (update)
has been removed from the -mm tree.  Its filename was
     sysctl-remove-broken-cdrom-binary-sysctls-update.patch

This patch was dropped because it was folded into sysctl-remove-broken-cdrom-binary-sysctls.patch

------------------------------------------------------
Subject: sysctl: remove broken cdrom binary sysctls (update)
From: ebiederm@xmission.com (Eric W. Biederman)

The binary interface for the cdrom sysctls can't possilby work.  So remove
the binary sysctls and reduce cdrom_sysctl_handler to it's essentials (to
kill the uses of ctl_name).

Since the last time this patch was posted I radically
simplified cdrom_sysctl_helper to meet address Alan's objections.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls-update drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls-update
+++ a/drivers/cdrom/cdrom.c
@@ -3458,40 +3458,19 @@ static void cdrom_update_settings(void)
 static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int *valp = ctl->data;
-	int val = *valp;
 	int ret;
 	
 	ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
 
-	if (write && *valp != val) {
+	if (write) {
 	
 		/* we only care for 1 or 0. */
-		if (*valp)
-			*valp = 1;
-		else
-			*valp = 0;
-
-		if (strcmp(ctl->procname, "autoclose") == 0) {
-			if (valp == &cdrom_sysctl_settings.autoclose)
-				autoclose = cdrom_sysctl_settings.autoclose;
-		}
-		else if (strcmp(ctl->procname, "autoeject") == 0) {
-			if (valp == &cdrom_sysctl_settings.autoeject)
-				autoeject = cdrom_sysctl_settings.autoeject;
-		}
-		else if (strcmp(ctl->procname, "debug") == 0) {
-			if (valp == &cdrom_sysctl_settings.debug)
-				debug = cdrom_sysctl_settings.debug;
-		}
-		else if (strcmp(ctl->procname, "lock") == 0) {
-			if (valp == &cdrom_sysctl_settings.lock)
-				lockdoor = cdrom_sysctl_settings.lock;
-		}
-		else if (strcmp(ctl->procname, "check_media") == 0) {
-			if (valp == &cdrom_sysctl_settings.check)
-				check_media_type = cdrom_sysctl_settings.check;
-		}
+		autoclose        = !!cdrom_sysctl_settings.autoclose;
+		autoeject        = !!cdrom_sysctl_settings.autoeject;
+		debug	         = !!cdrom_sysctl_settings.debug;
+		lockdoor         = !!cdrom_sysctl_settings.lock;
+		check_media_type = !!cdrom_sysctl_settings.check;
+
 		/* update the option flags according to the changes. we
 		   don't have per device options through sysctl yet,
 		   but we will have and then this will disappear. */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-remove-broken-cdrom-binary-sysctls-update.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-parport-remove-binary-paths.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
sysctl-update-sysctl_check_table.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
