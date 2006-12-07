From: akpm@osdl.org
Subject: - suspend-to-disk-fails-if-gdb-is-suspended-with-a-traced-child.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:39 -0800
Message-ID: <200612072259.kB7MxdlU029540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163690AbWLGW7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, pixi+kbug@burble.org, mm-commits@vger.kernel.org


The patch titled
     suspend to disk fails if gdb is suspended with a traced child
has been removed from the -mm tree.  Its filename was
     suspend-to-disk-fails-if-gdb-is-suspended-with-a-traced-child.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: suspend to disk fails if gdb is suspended with a traced child
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7534

Fix the freezing of processes so that it won't fail if there is a traced
process the parent of which has been stopped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: maurice barnum <pixi+kbug@burble.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/process.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/power/process.c~suspend-to-disk-fails-if-gdb-is-suspended-with-a-traced-child kernel/power/process.c
--- a/kernel/power/process.c~suspend-to-disk-fails-if-gdb-is-suspended-with-a-traced-child
+++ a/kernel/power/process.c
@@ -97,7 +97,9 @@ int freeze_processes(void)
 				continue;
 			if (frozen(p))
 				continue;
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
+			if (p->state == TASK_TRACED &&
+			    (frozen(p->parent) ||
+			     p->parent->state == TASK_STOPPED)) {
 				cancel_freezing(p);
 				continue;
 			}
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

