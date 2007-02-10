From: akpm@linux-foundation.org
Subject: - swsusp-change-pm_ops-handling-by-userland-interface-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:09:24 -0800
Message-ID: <200702100809.l1A89Ove006920@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbXBJIJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix possible oops in userland interface
has been removed from the -mm tree.  Its filename was
     swsusp-change-pm_ops-handling-by-userland-interface-fix.patch

This patch was dropped because it was folded into swsusp-change-pm_ops-handling-by-userland-interface.patch

------------------------------------------------------
Subject: swsusp: fix possible oops in userland interface
From: "Rafael J. Wysocki" <rjw@sisk.pl>

The SNAPSHOT_PMOPS and SNAPSHOT_S2RAM ioctls can Oops if they are called
from a kernel that doesn't set pm_ops (eg.  non-ACPI kernel on a PC).  Fix
it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff -puN kernel/power/user.c~swsusp-change-pm_ops-handling-by-userland-interface-fix kernel/power/user.c
--- a/kernel/power/user.c~swsusp-change-pm_ops-handling-by-userland-interface-fix
+++ a/kernel/power/user.c
@@ -341,6 +341,11 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_S2RAM:
+		if (!pm_ops) {
+			error = -ENOSYS;
+			break;
+		}
+
 		if (!data->frozen) {
 			error = -EPERM;
 			break;
@@ -383,8 +388,12 @@ static int snapshot_ioctl(struct inode *
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			data->platform_suspend = 1;
-			error = 0;
+			if (pm_ops && pm_ops->enter) {
+				data->platform_suspend = 1;
+				error = 0;
+			} else {
+				error = -ENOSYS;
+			}
 			break;
 
 		case PMOPS_ENTER:
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-order-in-diskc-fix.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
swsusp-change-pm_ops-handling-by-userland-interface-fix.patch
shrink_slab-handle-bad-shrinkers.patch
