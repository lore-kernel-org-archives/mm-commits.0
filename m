From: akpm@linux-foundation.org
Subject: + nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch added to -mm tree
Date: Fri, 27 Apr 2012 15:04:18 -0700
Message-ID: <20120427220419.59E38A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42150 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2D0WEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 18:04:20 -0400
Received: by yenq2 with SMTP id q2so137398yen.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 15:04:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl


The patch titled
     Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix
has been added to the -mm tree.  Its filename is
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix

Patches currently in -mm which might be from snanda@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch

