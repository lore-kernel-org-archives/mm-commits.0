From: akpm@linux-foundation.org
Subject: + checkpatch-warn-about-unexpectedly-long-msleeps.patch added to -mm tree
Date: Tue, 03 Aug 2010 15:51:09 -0700
Message-ID: <201008032251.o73Mp9s9015784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797Ab0HCWvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 18:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ppannuto@codeaurora.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     checkpatch: warn about unexpectedly long msleep's
has been added to the -mm tree.  Its filename is
     checkpatch-warn-about-unexpectedly-long-msleeps.patch

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
Subject: checkpatch: warn about unexpectedly long msleep's
From: Patrick Pannuto <ppannuto@codeaurora.org>

As explained in Documentation/timers/timers-howto.txt, msleep's of < 20ms
may sleep for as long as 20ms.  Caller's of msleep(1) or msleep(2), etc
are likely not to expect this quirky behavior - warn them.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-about-unexpectedly-long-msleeps scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-about-unexpectedly-long-msleeps
+++ a/scripts/checkpatch.pl
@@ -2602,6 +2602,13 @@ sub process {
 			}
 		}
 
+# warn about unexpectedly long msleep's
+		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
+			if ($1 < 20) {
+				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+			}
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
_

Patches currently in -mm which might be from ppannuto@codeaurora.org are

linux-next.patch
revert-old-timer-added-usleep_range-timer.patch
timer-added-usleep_range-timer.patch
documentation-add-timers-timers-howtotxt.patch
checkpatch-prefer-usleep_range-over-udelay.patch
checkpatch-warn-about-unexpectedly-long-msleeps.patch

