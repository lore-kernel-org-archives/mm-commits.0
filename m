From: akpm@linux-foundation.org
Subject: - freezer-be-more-verbose.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:09 -0700
Message-ID: <200710190341.l9J3f96h012778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966249AbXJSD4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: be more verbose
has been removed from the -mm tree.  Its filename was
     freezer-be-more-verbose.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: be more verbose
From: Rafael J. Wysocki <rjw@sisk.pl>

Increase the freezer's verbosity a bit, so that it's easier to read problem
reports related to it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/power/process.c~freezer-be-more-verbose kernel/power/process.c
--- a/kernel/power/process.c~freezer-be-more-verbose
+++ a/kernel/power/process.c
@@ -227,18 +227,21 @@ int freeze_processes(void)
 {
 	int error;
 
-	printk("Stopping tasks ... ");
+	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(FREEZER_USER_SPACE);
 	if (error)
-		return error;
+		goto Exit;
+	printk("done.\n");
 
+	printk("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
 	if (error)
-		return error;
-
-	printk("done.\n");
+		goto Exit;
+	printk("done.");
+ Exit:
 	BUG_ON(in_atomic());
-	return 0;
+	printk("\n");
+	return error;
 }
 
 static void thaw_tasks(int thaw_user_space)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
