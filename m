From: akpm@linux-foundation.org
Subject: - hibernate-fix-lockdep-report.patch removed from -mm tree
Date: Wed, 31 Oct 2007 13:07:45 -0700
Message-ID: <200710312007.l9VK7j69023798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbXJaUIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, pavel@ucw.cz, rjw@sisk.pl, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     hibernate: fix lockdep report
has been removed from the -mm tree.  Its filename was
     hibernate-fix-lockdep-report.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: hibernate: fix lockdep report
From: Johannes Berg <johannes@sipsolutions.net>

Lockdep reports a circular locking dependency in the hibernate code
because
 - during system boot hibernate code (from an initcall) locks pm_mutex
   and then a sysfs buffer mutex via name_to_dev_t
 - during regular operation hibernate code locks pm_mutex under a
   sysfs buffer mutex because it's called from sysfs methods.

The deadlock can never happen because during initcall invocation nothing
can write to sysfs yet. This removes the lockdep report by marking the
initcall locking as being in a different class.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~hibernate-fix-lockdep-report kernel/power/disk.c
--- a/kernel/power/disk.c~hibernate-fix-lockdep-report
+++ a/kernel/power/disk.c
@@ -456,7 +456,17 @@ static int software_resume(void)
 	int error;
 	unsigned int flags;
 
-	mutex_lock(&pm_mutex);
+	/*
+	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
+	 * is configured into the kernel. Since the regular hibernate
+	 * trigger path is via sysfs which takes a buffer mutex before
+	 * calling hibernate functions (which take pm_mutex) this can
+	 * cause lockdep to complain about a possible ABBA deadlock
+	 * which cannot happen since we're in the boot code here and
+	 * sysfs can't be invoked yet. Therefore, we use a subclass
+	 * here to avoid lockdep complaining.
+	 */
+	mutex_lock_nested(&pm_mutex, 1);
 	if (!swsusp_resume_device) {
 		if (!strlen(resume_file)) {
 			mutex_unlock(&pm_mutex);
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-input.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kbuild.patch
git-wireless.patch
hibernate-fix-lockdep-report.patch
