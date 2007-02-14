From: akpm@linux-foundation.org
Subject: + power-management-no-valid-states-w-o-pm_ops-docs.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:07:27 -0800
Message-ID: <200702142207.l1EM7RZK010779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXBNWHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, greg@kroah.com, pavel@ucw.cz, rdunlap@xenotime.net, rjw@sisk.pl


The patch titled
     power management: no valid states w/o pm_ops + docs
has been added to the -mm tree.  Its filename is
     power-management-no-valid-states-w-o-pm_ops-docs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: power management: no valid states w/o pm_ops + docs
From: Johannes Berg <johannes@sipsolutions.net>

Change /sys/power/state to not advertise any valid states (except for disk
if SOFTWARE_SUSPEND is enabled) when no pm_ops have been set so userspace
can easily discover what states should be available.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Macheck <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/power/main.c~power-management-no-valid-states-w-o-pm_ops-docs kernel/power/main.c
--- a/kernel/power/main.c~power-management-no-valid-states-w-o-pm_ops-docs
+++ a/kernel/power/main.c
@@ -167,7 +167,10 @@ static inline int valid_state(suspend_st
 	if (state == PM_SUSPEND_DISK)
 		return 1;
 
-	if (pm_ops && pm_ops->valid && !pm_ops->valid(state))
+	/* all other states need lowlevel support and need to be
+	 * valid to the lowlevel implementation, no valid callback
+	 * implies that all are valid. */
+	if (!pm_ops || (pm_ops->valid && !pm_ops->valid(state)))
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
power-management-no-valid-states-w-o-pm_ops-docs.patch
a.patch
