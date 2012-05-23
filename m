From: akpm@linux-foundation.org
Subject: [merged] microblaze-dont-reimplement-force_sigsegv.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:24 -0700
Message-ID: <20120523195124.5C2A4A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54383 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2EWTv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:26 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so334535wer.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, monstr@monstr.eu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: don't reimplement force_sigsegv()
has been removed from the -mm tree.  Its filename was
     microblaze-dont-reimplement-force_sigsegv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: microblaze: don't reimplement force_sigsegv()

Instead of open coding the sequence from force_sigsegv() just call it. 
This also fixes a bug because we were modifying ka->sa.sa_handler (which
is a copy of sighand->action[]), whereas the intention of the code was to
modify sighand->action[] directly.

As the original code was working with a copy it had no effect on signal
delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/signal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/microblaze/kernel/signal.c~microblaze-dont-reimplement-force_sigsegv arch/microblaze/kernel/signal.c
--- a/arch/microblaze/kernel/signal.c~microblaze-dont-reimplement-force_sigsegv
+++ a/arch/microblaze/kernel/signal.c
@@ -270,9 +270,7 @@ static void setup_rt_frame(int sig, stru
 	return;
 
 give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 }
 
 /* Handle restarting system calls */
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

