From: akpm@linux-foundation.org
Subject: - power-management-change-sys-power-disk-display.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:33 -0700
Message-ID: <200705080005.l4805XHl009105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967381AbXEHAGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power management: change /sys/power/disk display
has been removed from the -mm tree.  Its filename was
     power-management-change-sys-power-disk-display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
 static ssize_t disk_show(struct kset *kset, char *buf)
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

origin.patch
git-alsa.patch
git-powerpc.patch
power-management-remove-some-useless-code-from-arm.patch
git-wireless.patch
pm-separate-hibernation-code-from-suspend-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
kernel-doc-html-mode-struct-highlights.patch
