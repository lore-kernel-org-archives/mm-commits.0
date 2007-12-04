From: akpm@linux-foundation.org
Subject: - freezer-fix-jffs2-garbage-collector-freezing-issue-rev-2.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:20 -0800
Message-ID: <200712040738.lB47cKgZ006890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbXLDHtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, armlinux@architechnical.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     freezer: fix JFFS2 garbage collector freezing issue
has been removed from the -mm tree.  Its filename was
     freezer-fix-jffs2-garbage-collector-freezing-issue-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: fix JFFS2 garbage collector freezing issue
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
"freezer: do not send signals to kernel threads" in
jffs2_garbage_collect_thread() that assumed it would be sent signals by the
freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Pete MacKay <armlinux@architechnical.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/background.c~freezer-fix-jffs2-garbage-collector-freezing-issue-rev-2 fs/jffs2/background.c
--- a/fs/jffs2/background.c~freezer-fix-jffs2-garbage-collector-freezing-issue-rev-2
+++ a/fs/jffs2/background.c
@@ -105,7 +105,7 @@ static int jffs2_garbage_collect_thread(
 
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
-		while (signal_pending(current)) {
+		while (signal_pending(current) || freezing(current)) {
 			siginfo_t info;
 			unsigned long signr;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
page-allocator-clean-up-pcp-draining-functions.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
