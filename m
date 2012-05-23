From: akpm@linux-foundation.org
Subject: [alternative-merged] microblaze-no-need-to-reset-handler-if-sa_oneshot.patch removed from -mm tree
Date: Wed, 23 May 2012 12:48:51 -0700
Message-ID: <20120523194851.81767A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34092 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EWTsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:48:52 -0400
Received: by yhgm50 with SMTP id m50so1091702yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:48:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, monstr@monstr.eu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: no need to reset handler if SA_ONESHOT
has been removed from the -mm tree.  Its filename was
     microblaze-no-need-to-reset-handler-if-sa_oneshot.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: microblaze: no need to reset handler if SA_ONESHOT

get_signal_to_deliver() already resets the signal handler if SA_ONESHOT is
set in ka->sa.sa_flags, there's no need to do it again in handle_signal().
 Furthermore, because we were modifying ka->sa.sa_handler (which is a copy
of sighand->action[]) instead of sighand->action[] the original code
actually had no effect on signal delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/signal.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/microblaze/kernel/signal.c~microblaze-no-need-to-reset-handler-if-sa_oneshot arch/microblaze/kernel/signal.c
--- a/arch/microblaze/kernel/signal.c~microblaze-no-need-to-reset-handler-if-sa_oneshot
+++ a/arch/microblaze/kernel/signal.c
@@ -320,9 +320,6 @@ handle_signal(unsigned long sig, struct 
 	else
 		setup_rt_frame(sig, ka, NULL, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
