From: akpm@linux-foundation.org
Subject: + checkpatch-prefer-usleep_range-over-udelay.patch added to -mm tree
Date: Tue, 03 Aug 2010 15:51:07 -0700
Message-ID: <201008032251.o73Mp74q015781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797Ab0HCWwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 18:52:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ppannuto@codeaurora.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     checkpatch: prefer usleep_range over udelay
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-usleep_range-over-udelay.patch

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
Subject: checkpatch: prefer usleep_range over udelay
From: Patrick Pannuto <ppannuto@codeaurora.org>

When possible, sleeping is (usually) better than delaying; however, don't
bother callers of udelay < 10us, as those cases are generally not worth
the switch to usleep

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-usleep_range-over-udelay scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-usleep_range-over-udelay
+++ a/scripts/checkpatch.pl
@@ -2594,6 +2594,14 @@ sub process {
 			}
 		}
 
+# prefer usleep_range over udelay
+		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
+			# ignore udelay's < 10, however
+			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
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

