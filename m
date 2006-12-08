From: akpm@osdl.org
Subject: - fault-injection-capabilities-infrastructure-tweaks.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:58:59 -0800
Message-ID: <200612080858.kB88wxHx014214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425264AbWLHI7L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, akinobu.mita@gmail.com, dwm@meer.net, okuji@enbug.org, mm-commits@vger.kernel.org


The patch titled
     fault-injection-capabilities-infrastructure-retval-fix
has been removed from the -mm tree.  Its filename was
     fault-injection-capabilities-infrastructure-tweaks.patch

This patch was dropped because it was folded into fault-injection-capabilities-infrastructure.patch

------------------------------------------------------
Subject: fault-injection-capabilities-infrastructure-retval-fix
From: Andrew Morton <akpm@osdl.org>

- Add comment explaining weird return value

- Make setup_fault_attr __init.

Cc: <okuji@enbug.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/fault-inject.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN lib/fault-inject.c~fault-injection-capabilities-infrastructure-tweaks lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-capabilities-infrastructure-tweaks
+++ a/lib/fault-inject.c
@@ -7,7 +7,11 @@
 #include <linux/module.h>
 #include <linux/fault-inject.h>
 
-int setup_fault_attr(struct fault_attr *attr, char *str)
+/*
+ * setup_fault_attr() is a helper function for various __setup handlers, so it
+ * returns 0 on error, because that is what __setup handlers do.
+ */
+int __init setup_fault_attr(struct fault_attr *attr, char *str)
 {
 	unsigned long probability;
 	unsigned long interval;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

