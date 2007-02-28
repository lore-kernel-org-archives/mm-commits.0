From: akpm@linux-foundation.org
Subject: - power-management-no-valid-states-w-o-pm_ops-docs.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:51:37 -0800
Message-ID: <200702282351.l1SNpbaR030934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645AbXB1Xw1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, greg@kroah.com, pavel@ucw.cz, rdunlap@xenotime.net, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power management: no valid states w/o pm_ops
has been removed from the -mm tree.  Its filename was
     power-management-no-valid-states-w-o-pm_ops-docs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: power management: no valid states w/o pm_ops
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
