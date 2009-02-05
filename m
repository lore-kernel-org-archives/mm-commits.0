From: akpm@linux-foundation.org
Subject: + fix-pm_notifiers-during-user-mode-hibernation.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:33:18 -0800
Message-ID: <200902052033.n15KXIVI021065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbZBEUeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: fix pm_notifiers during user mode hibernation
has been added to the -mm tree.  Its filename is
     fix-pm_notifiers-during-user-mode-hibernation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: fix pm_notifiers during user mode hibernation
From: Andrey Borzenkov <arvidjaar@mail.ru>

Snapshot device is opened with O_RDONLY during suspend and O_WRONLY durig
resume.  Make sure we also call notifiers with correct parameter telling
them what we are really doing.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/power/user.c~fix-pm_notifiers-during-user-mode-hibernation kernel/power/user.c
--- a/kernel/power/user.c~fix-pm_notifiers-during-user-mode-hibernation
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
fix-pm_notifiers-during-user-mode-hibernation.patch

