From: akpm@linux-foundation.org
Subject: - checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:52 -0700
Message-ID: <200810182313.m9INDqvZ028270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYJRXOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: ensure we only apply checks to the lines within hunks
has been removed from the -mm tree.  Its filename was
     checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: ensure we only apply checks to the lines within hunks
From: Andy Whitcroft <apw@shadowen.org>

We should only apply source checks to lines within hunks.  Checks which
are anchored in the context may falsly trigger in the commentory.  Ensure
they only match within valid hunk lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks
+++ a/scripts/checkpatch.pl
@@ -1128,6 +1128,7 @@ sub process {
 		$linenr++;
 
 		my $rawline = $rawlines[$linenr - 1];
+		my $hunk_line = ($realcnt != 0);
 
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
@@ -1238,8 +1239,8 @@ sub process {
 			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
-#ignore lines being removed
-		if ($line=~/^-/) {next;}
+# ignore non-hunk lines and lines being removed
+		next if (!$hunk_line || $line =~ /^-/);
 
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

