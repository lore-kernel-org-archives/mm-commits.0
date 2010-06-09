From: akpm@linux-foundation.org
Subject: + panic-keep-blinking-in-spite-of-long-spin-timer-mode-update.patch added to -mm tree
Date: Wed, 09 Jun 2010 15:16:09 -0700
Message-ID: <201006092216.o59MG9wT024877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000Ab0FIWQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 18:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tamuki@linet.gr.jp


The patch titled
     panic-keep-blinking-in-spite-of-long-spin-timer-mode-update
has been added to the -mm tree.  Its filename is
     panic-keep-blinking-in-spite-of-long-spin-timer-mode-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: panic-keep-blinking-in-spite-of-long-spin-timer-mode-update
From: TAMUKI Shoichi <tamuki@linet.gr.jp>

 - brush up the explanation of panicblink= in kernel-parameters.txt
 - use the clamp() macro

Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++----
 kernel/panic.c                      |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN Documentation/kernel-parameters.txt~panic-keep-blinking-in-spite-of-long-spin-timer-mode-update Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~panic-keep-blinking-in-spite-of-long-spin-timer-mode-update
+++ a/Documentation/kernel-parameters.txt
@@ -1859,10 +1859,8 @@ and is between 256 and 4096 characters. 
 
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
-	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
-			The period of panic blink can be computed by the
-			formula T = 7200 / W, where T is the period in milli-
-			seconds, W is the speed in wpm (words per minute).
+	panicblink=	[KNL] The speed of panic blink (range is 1 to 100, the
+			lower the slower, the higher the faster, default is 12)
 			Should be 5 or less when running under a hypervisor
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
diff -puN kernel/panic.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode-update kernel/panic.c
--- a/kernel/panic.c~panic-keep-blinking-in-spite-of-long-spin-timer-mode-update
+++ a/kernel/panic.c
@@ -122,8 +122,7 @@ NORET_TYPE void panic(const char * fmt, 
 
 	bust_spinlocks(0);
 
-	if (panic_blink_wpm <= 0 || panic_blink_wpm > 100)
-		panic_blink_wpm = 12;
+	panic_blink_wpm = clamp(panic_blink_wpm, 1, 100);
 
 	if (!panic_blink)
 		panic_blink = no_blink;
_

Patches currently in -mm which might be from tamuki@linet.gr.jp are

panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode-update.patch

