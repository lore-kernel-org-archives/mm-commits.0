From: akpm@linux-foundation.org
Subject: [folded] nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch removed from -mm tree
Date: Fri, 08 Jun 2012 14:38:18 -0700
Message-ID: <20120608213818.AFE2FA02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51281 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761169Ab2FHViU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 17:38:20 -0400
Received: by mail-wi0-f202.google.com with SMTP id hn6so105201wib.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 14:38:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch

This patch was dropped because it was folded into nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sameer Nanda <snanda@chromium.org>
Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix

tweak comment further

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix
+++ a/kernel/watchdog.c
@@ -598,9 +598,10 @@ static struct notifier_block __cpuinitda
 };
 
 /*
- * On entry to suspend we force an offline->online transition on the boot CPU so
- * that PMU state is available to that CPU when it comes back online after
- * resume.  This information is required for restarting the NMI watchdog.
+ * On exit from suspend we force an offline->online transition on the boot CPU
+ * so that the PMU state that was lost while in suspended state gets set up
+ * properly for the boot CPU.  This information is required for restarting the
+ * NMI watchdog.
  */
 void lockup_detector_bootcpu_resume(void)
 {
_

Patches currently in -mm which might be from snanda@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch

