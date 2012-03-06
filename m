From: akpm@linux-foundation.org
Subject: [merged] debugobjects-fix-selftest-for-static-warnings.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:14 -0800
Message-ID: <20120306193514.5FC0FA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:62855 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2CFTfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:15 -0500
Received: by mail-vx0-f202.google.com with SMTP id fk26so677488vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: Fix selftest for static warnings
has been removed from the -mm tree.  Its filename was
     debugobjects-fix-selftest-for-static-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reported-by: Thomas Gleixner <tglx@linutronix.de>
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

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch

