From: akpm@linux-foundation.org
Subject: + checkpatch-add-test-for-long-udelay.patch added to -mm tree
Date: Tue, 04 Feb 2014 16:09:58 -0800
Message-ID: <52f18156.VDfERMtKgY+dbpeI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaBEAJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 19:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sujith@msujith.org, linville@tuxdriver.com, holgerschurig@gmail.com, joe@perches.com

Subject: + checkpatch-add-test-for-long-udelay.patch added to -mm tree
To: joe@perches.com,holgerschurig@gmail.com,linville@tuxdriver.com,sujith@msujith.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 16:09:58 -0800


The patch titled
     Subject: checkpatch: add test for long udelay
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-long-udelay.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-long-udelay.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-long-udelay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for long udelay

Holger reported:

: The macro udelay cannot handle large values because of loss-of-precision.
:
: IMHO udelay on ARM is broken, because it also cannot work with fast
: ARM processors (where bogomips >= 3355, which is in sight now). It's
: just not broken enough that someone did something against it ...   so
: the current kludge is good enough.

Until then, warn on long udelay uses.

Also fix uses of $line that should have been $herecurr.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Holger Schurig <holgerschurig@gmail.com>
Cc: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-long-udelay scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-long-udelay
+++ a/scripts/checkpatch.pl
@@ -3912,10 +3912,15 @@ sub process {
 
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
+			my $delay = $1;
 			# ignore udelay's < 10, however
-			if (! ($1 < 10) ) {
+			if (! ($delay < 10) ) {
 				CHK("USLEEP_RANGE",
-				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
+				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $herecurr);
+			}
+			if ($delay > 2000) {
+				WARN("LONG_UDELAY",
+				     "long udelay - prefer mdelay; see arch/arm/include/asm/delay.h\n" . $herecurr);
 			}
 		}
 
@@ -3923,7 +3928,7 @@ sub process {
 		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
 			if ($1 < 20) {
 				WARN("MSLEEP",
-				     "msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+				     "msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch

