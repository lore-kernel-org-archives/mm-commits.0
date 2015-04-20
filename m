From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:05 -0700
Message-ID: <553550b1.V1rPNclM9sNlpkxD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbDTTKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, corbet@lwn.net, davem@davemloft.net, ipm@chirality.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch, SubmittingPatches: suggest line wrapping commit messages at 75 columns
has been removed from the -mm tree.  Its filename was
     checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch, SubmittingPatches: suggest line wrapping commit messages at 75 columns

Commit messages lines are sometimes overly long.

Suggest line wrapping at 75 columns so the default git commit log
indentation of 4 plus the commit message text still fits on an 80 column
screen.

Add a checkpatch test for long commit messages lines too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ian Morris <ipm@chirality.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    4 ++--
 scripts/checkpatch.pl           |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN Documentation/SubmittingPatches~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns
+++ a/Documentation/SubmittingPatches
@@ -614,8 +614,8 @@ The canonical patch message body contain
 
   - An empty line.
 
-  - The body of the explanation, which will be copied to the
-    permanent changelog to describe this patch.
+  - The body of the explanation, line wrapped at 75 columns, which will
+    be copied to the permanent changelog to describe this patch.
 
   - The "Signed-off-by:" lines, described above, which will
     also go in the changelog.
diff -puN scripts/checkpatch.pl~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns
+++ a/scripts/checkpatch.pl
@@ -1898,6 +1898,7 @@ sub process {
 
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+	my $commit_log_long_line = 0;
 	my $reported_maintainer_file = 0;
 	my $non_utf8_charset = 0;
 
@@ -2233,6 +2234,14 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for line lengths > 75 in commit log, warn once
+		if ($in_commit_log && !$commit_log_long_line &&
+		    length($line) > 75) {
+			WARN("COMMIT_LOG_LONG_LINE",
+			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
+			$commit_log_long_line = 1;
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && $line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i) {
 			my $init_char = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

