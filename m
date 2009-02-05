From: akpm@linux-foundation.org
Subject: + clocksource-pass-clocksource-to-read-callback-fix.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:02:15 -0800
Message-ID: <200902052102.n15L2FiH027585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZBEVCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:02:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, lethal@linux-sh.org


The patch titled
     clocksource-pass-clocksource-to-read-callback fix
has been added to the -mm tree.  Its filename is
     clocksource-pass-clocksource-to-read-callback-fix.patch

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
Subject: clocksource-pass-clocksource-to-read-callback fix
From: Magnus Damm <magnus.damm@gmail.com>

post-conflict fixup

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/time_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback-fix arch/sh/kernel/time_32.c
--- a/arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback-fix
+++ a/arch/sh/kernel/time_32.c
@@ -208,7 +208,7 @@ unsigned long long sched_clock(void)
 	if (!clocksource_sh.rating)
 		return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 
-	cycles = clocksource_sh.read();
+	cycles = clocksource_sh.read(&clocksource_sh);
 	return cyc2ns(&clocksource_sh, cycles);
 }
 #endif
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
clocksource-pass-clocksource-to-read-callback-fix.patch

