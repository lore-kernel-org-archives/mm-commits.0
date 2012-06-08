From: akpm@linux-foundation.org
Subject: [folded] nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch removed from -mm tree
Date: Fri, 08 Jun 2012 14:38:24 -0700
Message-ID: <20120608213824.BE31FA02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63198 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508Ab2FHVi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 17:38:26 -0400
Received: by ghbz15 with SMTP id z15so211466ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 14:38:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: fix for lockup detector breakage on resume
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2.patch

This patch was dropped because it was folded into nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from snanda@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch

