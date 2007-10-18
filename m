From: akpm@linux-foundation.org
Subject: - handle-recursive-calls-to-bust_spinlocks.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:40 -0700
Message-ID: <200710180659.l9I6xeWx031003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbXJRHAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     handle recursive calls to bust_spinlocks()
has been removed from the -mm tree.  Its filename was
     handle-recursive-calls-to-bust_spinlocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: handle recursive calls to bust_spinlocks()
From: "Jan Beulich" <jbeulich@novell.com>

Various architectures may call bust_spinlocks() recursively; the function
itself, however, doesn't appear to be meant to be called in this manner. 
Nevertheless, this doesn't appear to be a problem as long as
bust_spinlocks(0) doesn't get called twice in a row (otherwise,
unblank_screen() may enter the scheduler).  However, at least on i386 die()
has been capable of returning (and on other architectures this should
really be that way, too) when notify_die() returns NOTIFY_STOP.

Short of getting a reply to a respective query, this patch makes
bust_spinlocks() increment/decrement oops_in_progress, and wake klogd only
when the count drops back to zero.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bust_spinlocks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/bust_spinlocks.c~handle-recursive-calls-to-bust_spinlocks lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~handle-recursive-calls-to-bust_spinlocks
+++ a/lib/bust_spinlocks.c
@@ -17,13 +17,13 @@
 void __attribute__((weak)) bust_spinlocks(int yes)
 {
 	if (yes) {
-		oops_in_progress = 1;
+		++oops_in_progress;
 	} else {
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
-		oops_in_progress = 0;
-		wake_up_klogd();
+		if (--oops_in_progress == 0)
+			wake_up_klogd();
 	}
 }
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
