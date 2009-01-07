From: akpm@linux-foundation.org
Subject: - checkpatch-add-warning-for-p0-patches.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:52 -0800
Message-ID: <200901072216.n07MGqbd016567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315AbZAGWRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: Add warning for p0-patches
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-p0-patches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

