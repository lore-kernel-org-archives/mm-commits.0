From: akpm@linux-foundation.org
Subject: [to-be-updated] nmi-watchdog-quiet-down-the-boot-messages-v3.patch removed from -mm tree
Date: Wed, 13 Jun 2012 12:49:33 -0700
Message-ID: <20120613194933.558C0A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:53691 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FMTtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:49:35 -0400
Received: by bkty5 with SMTP id y5so52818bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:49:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, mingo@elte.hu, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi-watchdog-quiet-down-the-boot-messages-v3
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-quiet-down-the-boot-messages-v3.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: nmi-watchdog-quiet-down-the-boot-messages-v3

V3: printk cleanup based on Ingo's feedback; checkpatch fix

Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-v3 kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-v3
+++ a/kernel/watchdog.c
@@ -404,8 +404,8 @@ static int watchdog_nmi_enable(int cpu)
 
 	if (!IS_ERR(event)) {
 		/* only print for cpu0 or different than cpu0 */
-		if (cpu ==0 || cpu0_err)
-			pr_info("enabled, takes one hw-pmu counter.\n");
+		if (cpu == 0 || cpu0_err)
+			pr_info("enabled on all CPUs, permanently consumes one hw-PMU counter.\n");
 		goto out_save;
 	}
 
_

Patches currently in -mm which might be from dzickus@redhat.com are

linux-next.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

