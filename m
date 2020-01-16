From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-fix-possible-soft-lockup-warning-at-bootup-v2.patch removed from -mm
 tree
Date: Thu, 16 Jan 2020 15:46:22 -0800
Message-ID: <20200116234622.9V-fA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730698AbgAPXqX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 18:46:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@linux.ibm.com, mingo@kernel.org, keescook@chromium.org, longman@redhat.com


The patch titled
     Subject: watchdog: Fix possible soft lockup warning at bootup
has been removed from the -mm tree.  Its filename was
     watchdog-fix-possible-soft-lockup-warning-at-bootup-v2.patch

This patch was dropped because it was folded into watchdog-fix-possible-soft-lockup-warning-at-bootup.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: watchdog: Fix possible soft lockup warning at bootup

Link: http://lkml.kernel.org/r/20200103151032.19590-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/watchdog.c~watchdog-fix-possible-soft-lockup-warning-at-bootup-v2
+++ a/kernel/watchdog.c
@@ -496,9 +496,7 @@ static void watchdog_enable(unsigned int
 		      HRTIMER_MODE_REL_PINNED_HARD);
 
 	/* Initialize timestamp */
-	if (system_state != SYSTEM_BOOTING)
-		__touch_watchdog();
