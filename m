From: akpm@linux-foundation.org
Subject: + nmi-watchdog-quiet-down-the-boot-messages-v3.patch added to -mm tree
Date: Mon, 11 Jun 2012 13:57:33 -0700
Message-ID: <20120611205734.EDC6EA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35460 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2FKU5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 16:57:36 -0400
Received: by ggeh3 with SMTP id h3so411249gge.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 13:57:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dzickus@redhat.com, mingo@elte.hu, nzimmer@sgi.com


The patch titled
     Subject: nmi-watchdog-quiet-down-the-boot-messages-v3
has been added to the -mm tree.  Its filename is
     nmi-watchdog-quiet-down-the-boot-messages-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: nmi-watchdog-quiet-down-the-boot-messages-v3

V3: printk cleanup based on Ingo's feedback; checkpatch fix

Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-v3 kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-quiet-down-the-boot-messages-v3
+++ a/kernel/watchdog.c
@@ -404,8 +404,10 @@ static int watchdog_nmi_enable(int cpu)
 
 	if (!IS_ERR(event)) {
 		/* only print for cpu0 or different than cpu0 */
-		if (cpu ==0 || cpu0_err)
-			pr_info("enabled, takes one hw-pmu counter.\n");
+		if (cpu == 0 || cpu0_err) {
+			pr_info("enabled on all CPUs, permanently consumes ");
+			pr_cont("one hw-PMU counter.\n");
+		}
 		goto out_save;
 	}
 
_
Subject: Subject: nmi-watchdog-quiet-down-the-boot-messages-v3

Patches currently in -mm which might be from dzickus@redhat.com are

linux-next.patch
nmi-watchdog-quiet-down-the-boot-messages.patch
nmi-watchdog-quiet-down-the-boot-messages-v3.patch
nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

