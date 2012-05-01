From: akpm@linux-foundation.org
Subject: + nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch added to -mm tree
Date: Tue, 01 May 2012 12:20:34 -0700
Message-ID: <20120501192034.BDCEDA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:39043 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2EATUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:20:36 -0400
Received: by ghbz15 with SMTP id z15so499683ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:20:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: watchdog: fix for lockup detector breakage on resume
has been added to the -mm tree.  Its filename is
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch

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
Subject: watchdog: fix for lockup detector breakage on resume

Signed-off-by: Sameer Nanda <snanda@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2 kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2
+++ a/kernel/watchdog.c
@@ -608,8 +608,9 @@ void lockup_detector_bootcpu_resume(void
 {
 	void *cpu = (void *)(long)smp_processor_id();
 
-	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
-	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+	cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_UP_PREPARE_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
 }
 #endif
 
_
Subject: Subject: watchdog: fix for lockup detector breakage on resume

Patches currently in -mm which might be from snanda@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch

