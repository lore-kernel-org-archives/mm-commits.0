From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-test-for-long-udelay.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:33:50 -0700
Message-ID: <533f091e.e/aWtNfRC7tDnBSv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbaDDTdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sujith@msujith.org, linville@tuxdriver.com, holgerschurig@gmail.com, joe@perches.com

Subject: [merged] checkpatch-add-test-for-long-udelay.patch removed from -mm tree
To: joe@perches.com,holgerschurig@gmail.com,linville@tuxdriver.com,sujith@msujith.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:50 -0700


The patch titled
     Subject: checkpatch: add test for long udelay
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-long-udelay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

