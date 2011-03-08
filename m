From: akpm@linux-foundation.org
Subject: [nacked] power-disable-hibernation-if-module-loading-is-disabled.patch removed from -mm tree
Date: Mon, 07 Mar 2011 16:25:32 -0800
Message-ID: <201103080025.p280PWbC004525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab1CHA0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 19:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, kees.cook@canonical.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power: disable hibernation if module loading is disabled
has been removed from the -mm tree.  Its filename was
     power-disable-hibernation-if-module-loading-is-disabled.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power: disable hibernation if module loading is disabled
From: Vasiliy Kulikov <segoon@openwall.com>

If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
root) may not read/write arbitrary kernel memory.  In spite of it,
hibernation allows anyone with an access to either /dev/snapshot or
/sys/power/ make the full snapshot of the system.  This snapshot may be
freely changed and uploaded back.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/hibernate.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/power/hibernate.c~power-disable-hibernation-if-module-loading-is-disabled kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~power-disable-hibernation-if-module-loading-is-disabled
+++ a/kernel/power/hibernate.c
@@ -328,6 +328,9 @@ int hibernation_snapshot(int platform_mo
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = platform_begin(platform_mode);
 	if (error)
 		goto Close;
@@ -385,6 +388,9 @@ static int resume_target_kernel(bool pla
 {
 	int error;
 
+	if (modules_disabled)
+		return -EPERM;
+
 	error = dpm_suspend_noirq(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch

