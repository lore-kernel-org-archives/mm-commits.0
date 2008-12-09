From: akpm@linux-foundation.org
Subject: + checkpatch-add-warning-for-p0-patches.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:30 -0800
Message-ID: <200812090004.mB904UWe031066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbYLIAFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, apw@canonical.com


The patch titled
     checkpatch: Add warning for p0-patches
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-for-p0-patches.patch

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
Subject: checkpatch: Add warning for p0-patches
From: Wolfram Sang <w.sang@pengutronix.de>

Some people work internally with -p0-patches which has the danger that one
forgets to convert them to -p1 before mainlining.  Bitten myself and seen
p0-patches in mailing lists occasionally, this patch adds a warning to
checkpatch.pl in case a patch is -p0.  If you really want, you can fool
this check to generate false positives, this is why it just spits a
warning.  Making the check 100% proof is trickier than it looks, so let's
start with a version which catches the cases of real use.

[apw@canonical.com: update message language, handle null prefix, add tests]
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-for-p0-patches scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-p0-patches
+++ a/scripts/checkpatch.pl
@@ -1057,6 +1057,7 @@ sub process {
 	my $in_comment = 0;
 	my $comment_edge = 0;
 	my $first_line = 0;
+	my $p1_prefix = '';
 
 	my $prev_values = 'E';
 
@@ -1205,7 +1206,12 @@ sub process {
 		# extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^[^/]*/@@;
+			$realfile =~ s@^([^/]*)/@@;
+
+			$p1_prefix = $1;
+			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
+				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+			}
 
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
checkpatch-add-warning-for-p0-patches.patch

