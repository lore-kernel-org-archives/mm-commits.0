From: akpm@linux-foundation.org
Subject: + freezer-document-relationship-with-memory-shrinking.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:48:11 -0700
Message-ID: <200707232348.l6NNmBW7018369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757328AbXGWXs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     freezer: document relationship with memory shrinking
has been added to the -mm tree.  Its filename is
     freezer-document-relationship-with-memory-shrinking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: document relationship with memory shrinking
From: Rafael J. Wysocki <rjw@sisk.pl>

One important reason to freeze tasks, which is that we don't want them to
allocate memory after freeing it for the hibernation image, has not been
documented.  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/freezing-of-tasks.txt |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff -puN Documentation/power/freezing-of-tasks.txt~freezer-document-relationship-with-memory-shrinking Documentation/power/freezing-of-tasks.txt
--- a/Documentation/power/freezing-of-tasks.txt~freezer-document-relationship-with-memory-shrinking
+++ a/Documentation/power/freezing-of-tasks.txt
@@ -81,7 +81,16 @@ hibernation image has been created and b
 The majority of these are user space processes, but if any of the kernel threads
 may cause something like this to happen, they have to be freezable.
 
-2. The second reason is to prevent user space processes and some kernel threads
+2. Next, to create the hibernation image we need to free a sufficient amount of
+memory (approximately 50% of available RAM) and we need to do that before
+devices are deactivated, because we generally need them for swapping out.  Then,
+after the memory for the image has been freed, we don't want tasks to allocate
+additional memory and we prevent them from doing that by freezing them earlier.
+[Of course, this also means that device drivers should not allocate substantial
+amounts of memory from their .suspend() callbacks before hibernation, but this
+is e separate issue.]
+
+3. The third reason is to prevent user space processes and some kernel threads
 from interfering with the suspending and resuming of devices.  A user space
 process running on a second CPU while we are suspending devices may, for
 example, be troublesome and without the freezing of tasks we would need some
@@ -111,7 +120,7 @@ frozen before the driver's .suspend() ca
 thawed after the driver's .resume() callback has run, so it won't be accessing
 the device while it's suspended.
 
-3. Another reason for freezing tasks is to prevent user space processes from
+4. Another reason for freezing tasks is to prevent user space processes from
 realizing that hibernation (or suspend) operation takes place.  Ideally, user
 space processes should not notice that such a system-wide operation has occurred
 and should continue running without any problems after the restore (or resume
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch
