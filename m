From: akpm@linux-foundation.org
Subject: + debugobjects-fix-selftest-for-static-warnings.patch added to -mm tree
Date: Thu, 15 Dec 2011 13:35:48 -0800
Message-ID: <20111215213549.09360200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:55576 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:35:51 -0500
Received: by eaad1 with SMTP id d1so71989eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:35:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, tglx@linutronix.de


The patch titled
     Subject: debugobjects: Fix selftest for static warnings
has been added to the -mm tree.  Its filename is
     debugobjects-fix-selftest-for-static-warnings.patch

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
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: debugobjects: Fix selftest for static warnings

debugobjects is now printing a warning when a fixup for a NOTAVAILABLE
object is run.  This causes the selftest to fail like:

[    0.000000] ODEBUG: selftest warnings failed 4 != 5

We could just increase the number of warnings that the selftest is
expecting to see because that is actually what has changed.  But, it turns
out that fixup_activate() was written with inverted logic and thus a fixup
for a static object returned 1 indicating the object had been fixed, and 0
otherwise.  Fix the logic to be correct and update the counts to reflect
that nothing needed fixing for a static object.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-By: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings
+++ a/lib/debugobjects.c
@@ -818,17 +818,9 @@ static int __init fixup_activate(void *a
 		if (obj->static_init == 1) {
 			debug_object_init(obj, &descr_type_test);
 			debug_object_activate(obj, &descr_type_test);
-			/*
-			 * Real code should return 0 here ! This is
-			 * not a fixup of some bad behaviour. We
-			 * merily call the debug_init function to keep
-			 * track of the object.
-			 */
-			return 1;
-		} else {
-			/* Real code needs to emit a warning here */
+			return 0;
 		}
-		return 0;
+		return 1;
 
 	case ODEBUG_STATE_ACTIVE:
 		debug_object_deactivate(obj, &descr_type_test);
@@ -967,7 +959,7 @@ static void __init debug_objects_selftes
 
 	obj.static_init = 1;
 	debug_object_activate(&obj, &descr_type_test);
-	if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
+	if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
 		goto out;
 	debug_object_init(&obj, &descr_type_test);
 	if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))
_
Subject: Subject: debugobjects: Fix selftest for static warnings

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
debugobjects-fix-selftest-for-static-warnings.patch
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch

