From: akpm@linux-foundation.org
Subject: + power-management-change-sys-power-disk-display.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:47:21 -0700
Message-ID: <200704131847.l3DIlLlk006737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45765 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbXDMSrb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     power management: change /sys/power/disk display
has been added to the -mm tree.  Its filename is
     power-management-change-sys-power-disk-display.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: power management: change /sys/power/disk display
From: Johannes Berg <johannes@sipsolutions.net>

Change /sys/power/disk to display all valid modes as well as the currently
selected one in a fashion known from the LED subsystem.

This changes userspace API, but it is apparently not used much (we asked
some userspace developers)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/interface.txt |    8 +++++--
 kernel/power/disk.c               |   29 +++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff -puN Documentation/power/interface.txt~power-management-change-sys-power-disk-display Documentation/power/interface.txt
--- a/Documentation/power/interface.txt~power-management-change-sys-power-disk-display
+++ a/Documentation/power/interface.txt
@@ -34,8 +34,12 @@ for 5 seconds, resume devices, unfreeze 
 we are able to look in the log messages and work out, for example, which code
 is being slow and which device drivers are misbehaving.
 
-Reading from this file will display what the mode is currently set
-to. Writing to this file will accept one of
+Reading from this file will display all supported modes and the currently
+selected one in brackets, for example
+
+	[shutdown] reboot test testproc
+
+Writing to this file will accept one of
 
        'platform' (only if the platform supports it)
        'shutdown'
diff -puN kernel/power/disk.c~power-management-change-sys-power-disk-display kernel/power/disk.c
--- a/kernel/power/disk.c~power-management-change-sys-power-disk-display
+++ a/kernel/power/disk.c
@@ -350,7 +350,34 @@ static const char * const pm_disk_modes[
 
 static ssize_t disk_show(struct subsystem * subsys, char * buf)
 {
-	return sprintf(buf, "%s\n", pm_disk_modes[pm_disk_mode]);
+	int i;
+	char *start = buf;
+
+	for (i = PM_DISK_PLATFORM; i < PM_DISK_MAX; i++) {
+		if (!pm_disk_modes[i])
+			continue;
+		switch (i) {
+		case PM_DISK_SHUTDOWN:
+		case PM_DISK_REBOOT:
+		case PM_DISK_TEST:
+		case PM_DISK_TESTPROC:
+			break;
+		default:
+			if (pm_ops && pm_ops->enter &&
+			    (i == pm_ops->pm_disk_mode))
+				break;
+			/* not a valid mode, continue with loop */
+			continue;
+		}
+		if (i == pm_disk_mode)
+			buf += sprintf(buf, "[%s]", pm_disk_modes[i]);
+		else
+			buf += sprintf(buf, "%s", pm_disk_modes[i]);
+		if (i+1 != PM_DISK_MAX)
+			buf += sprintf(buf, " ");
+	}
+	buf += sprintf(buf, "\n");
+	return buf-start;
 }
 
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
git-net.patch
git-wireless.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
kernel-doc-html-mode-struct-highlights.patch
