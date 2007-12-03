From: akpm@linux-foundation.org
Subject: - freezer-fix-jffs2-garbage-collector-freezing-issue.patch removed from -mm tree
Date: Mon, 03 Dec 2007 15:56:24 -0800
Message-ID: <200712032356.lB3NuOQf023978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbXLCX5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:57:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, armlinux@architechnical.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Freezer: fix JFFS2 garbage collector freezing issue
has been removed from the -mm tree.  Its filename was
     freezer-fix-jffs2-garbage-collector-freezing-issue.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Freezer: fix JFFS2 garbage collector freezing issue
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
"freezer: do not send signals to kernel threads" in
jffs2_garbage_collect_thread() that assumed it would be sent signals by the
freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pete MacKay <armlinux@architechnical.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/jffs2/background.c~freezer-fix-jffs2-garbage-collector-freezing-issue fs/jffs2/background.c
--- a/fs/jffs2/background.c~freezer-fix-jffs2-garbage-collector-freezing-issue
+++ a/fs/jffs2/background.c
@@ -103,15 +103,17 @@ static int jffs2_garbage_collect_thread(
 		   get there first. */
 		yield();
 
+		/* If system suspend is in progress, go to the refrigerator and
+		   start again when the suspend is done */
+		if (try_to_freeze())
+			goto again;
+
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current)) {
 			siginfo_t info;
 			unsigned long signr;
 
-			if (try_to_freeze())
-				goto again;
-
 			signr = dequeue_signal_lock(current, &current->blocked, &info);
 
 			switch(signr) {
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
freezer-fix-jffs2-garbage-collector-freezing-issue.patch
fix-proc-net-breakage.patch
hwmon-coretemp-suspend-fix.patch
hwmon-coretemp-suspend-fix-fix.patch
page-allocator-clean-up-pcp-draining-functions.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
