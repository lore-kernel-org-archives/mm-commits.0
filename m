From: akpm@linux-foundation.org
Subject: [merged] pm-fix-pm_notifiers-during-user-mode-hibernation.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:07:02 -0800
Message-ID: <200902232007.n1NK72MF013457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058AbZBWUHt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvidjaar@mail.ru, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: fix pm_notifiers during user mode hibernation
has been removed from the -mm tree.  Its filename was
     pm-fix-pm_notifiers-during-user-mode-hibernation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: fix pm_notifiers during user mode hibernation
From: Andrey Borzenkov <arvidjaar@mail.ru>

Snapshot device is opened with O_RDONLY during suspend and O_WRONLY durig
resume.  Make sure we also call notifiers with correct parameter telling
them what we are really doing.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/power/user.c~pm-fix-pm_notifiers-during-user-mode-hibernation kernel/power/user.c
--- a/kernel/power/user.c~pm-fix-pm_notifiers-during-user-mode-hibernation
+++ a/kernel/power/user.c
@@ -95,15 +95,15 @@ static int snapshot_open(struct inode *i
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
-		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (error)
-			pm_notifier_call_chain(PM_POST_RESTORE);
+			pm_notifier_call_chain(PM_POST_HIBERNATION);
 	} else {
 		data->swap = -1;
 		data->mode = O_WRONLY;
-		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
 		if (error)
-			pm_notifier_call_chain(PM_POST_HIBERNATION);
+			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
 	if (error)
 		atomic_inc(&snapshot_device_available);
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

linux-next.patch
fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch

