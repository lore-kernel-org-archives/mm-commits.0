From: akpm@linux-foundation.org
Subject: + power-management-force-pm_opsvalid-callback-to-be.patch added to -mm tree
Date: Thu, 22 Mar 2007 09:37:34 -0800
Message-ID: <200703221737.l2MHbYGR025798__49882.7157928192$1174585126$gmane$org@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934147AbXCVRiD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 13:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, greg@kroah.com, linux-pm@lists.linux-foundation.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     power management: force pm_ops.valid callback to be assigned
has been added to the -mm tree.  Its filename is
     power-management-force-pm_opsvalid-callback-to-be.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: power management: force pm_ops.valid callback to be assigned
From: Johannes Berg <johannes@sipsolutions.net>

This patch changes the docs and behaviour from "all states valid" to "no
states valid" if no .valid callback is assigned.  Users of pm_ops that only
need mem sleep can assign pm_valid_only_mem without any overhead, others
will require more elaborate callbacks.

Now that all users of pm_ops have a .valid callback this is a safe thing to
do and prevents things from getting messy again as they were before.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <linux-pm@lists.linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h  |   12 ++++++------
 kernel/power/main.c |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/pm.h~power-management-force-pm_opsvalid-callback-to-be include/linux/pm.h
--- a/include/linux/pm.h~power-management-force-pm_opsvalid-callback-to-be
+++ a/include/linux/pm.h
@@ -125,12 +125,12 @@ typedef int __bitwise suspend_disk_metho
  * struct pm_ops - Callbacks for managing platform dependent suspend states.
  * @valid: Callback to determine whether the given state can be entered.
  * 	If %CONFIG_SOFTWARE_SUSPEND is set then %PM_SUSPEND_DISK is
- *	always valid and never passed to this call.
- *	If not assigned, all suspend states are advertised as valid
- *	in /sys/power/state (but can still be rejected by prepare or enter.)
- *	Since new states can be added for other platforms, you should
- *	assign this callback. There is a %pm_valid_only_mem function
- *	available if you only implemented mem sleep.
+ *	always valid and never passed to this call. If not assigned,
+ *	no suspend states are valid.
+ *	Valid states are advertised in /sys/power/state but can still
+ *	be rejected by prepare or enter if the conditions aren't right.
+ *	There is a %pm_valid_only_mem function available that can be assigned
+ *	to this if you only implement mem sleep.
  *
  * @prepare: Prepare the platform for the given suspend state. Can return a
  *	negative error code if necessary.
diff -puN kernel/power/main.c~power-management-force-pm_opsvalid-callback-to-be kernel/power/main.c
--- a/kernel/power/main.c~power-management-force-pm_opsvalid-callback-to-be
+++ a/kernel/power/main.c
@@ -186,8 +186,8 @@ static inline int valid_state(suspend_st
 
 	/* all other states need lowlevel support and need to be
 	 * valid to the lowlevel implementation, no valid callback
-	 * implies that all are valid. */
-	if (!pm_ops || (pm_ops->valid && !pm_ops->valid(state)))
+	 * implies that none are valid. */
+	if (!pm_ops || !pm_ops->valid || !pm_ops->valid(state))
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-alsa.patch
git-wireless.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
