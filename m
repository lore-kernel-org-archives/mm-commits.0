From: akpm@linux-foundation.org
Subject: [merged] checkpatch-printks-always-need-a-kern_level.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:39 -0800
Message-ID: <20171120212439.wQsahloYj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdKTVYk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: printks always need a KERN_<LEVEL>
has been removed from the -mm tree.  Its filename was
     checkpatch-printks-always-need-a-kern_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: printks always need a KERN_<LEVEL>

There was code in checkpatch that allowed continuation printks to be used
without KERN_CONT.  Remove the continuation check and always require a
KERN_<LEVEL>.

Link: http://lkml.kernel.org/r/61980ef41d5b9b6543da1c49055042e0ab74d308.1507047008.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-printks-always-need-a-kern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-printks-always-need-a-kern_level
+++ a/scripts/checkpatch.pl
@@ -3829,28 +3829,10 @@ sub process {
 			     "Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
 		}
 
-# printk should use KERN_* levels.  Note that follow on printk's on the
-# same line do not need a level, so we use the current block context
-# to try and find and validate the current printk.  In summary the current
-# printk includes all preceding printk's which have no newline on the end.
-# we assume the first bad printk is the one to report.
-		if ($line =~ /\bprintk\((?!KERN_)\s*"/) {
-			my $ok = 0;
-			for (my $ln = $linenr - 1; $ln >= $first_line; $ln--) {
-				#print "CHECK<$lines[$ln - 1]\n";
-				# we have a preceding printk if it ends
-				# with "\n" ignore it, else it is to blame
-				if ($lines[$ln - 1] =~ m{\bprintk\(}) {
-					if ($rawlines[$ln - 1] !~ m{\\n"}) {
-						$ok = 1;
-					}
-					last;
-				}
-			}
-			if ($ok == 0) {
-				WARN("PRINTK_WITHOUT_KERN_LEVEL",
-				     "printk() should include KERN_ facility level\n" . $herecurr);
-			}
+# printk should use KERN_* levels
+		if ($line =~ /\bprintk\s*\(\s*(?!KERN_[A-Z]+\b)/) {
+			WARN("PRINTK_WITHOUT_KERN_LEVEL",
+			     "printk() should include KERN_<LEVEL> facility level\n" . $herecurr);
 		}
 
 		if ($line =~ /\bprintk\s*\(\s*KERN_([A-Z]+)/) {
_

Patches currently in -mm which might be from joe@perches.com are


