From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-signoff-when-reading-stdin.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:46 -0700
Message-ID: <57a2341e.V+cuVVSsizgSp1ZT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbcHCSNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allenbh@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check signoff when reading stdin
has been removed from the -mm tree.  Its filename was
     checkpatch-check-signoff-when-reading-stdin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Allen Hubbe <allenbh@gmail.com>
Subject: checkpatch: check signoff when reading stdin

Signoff was not checked if the filename is '-', indicating reading the
patch from stdin.  Commands such as the below would not warn about a
missing signoff, because the patch filename is '-'.  This change allows
checkpatch to warn about a missing signoff, even if the input filename is
'-', but only if the patch has a commit message.

git show --pretty=email | scripts/checkpatch.pl -

A more common use of checkpatch with stdin is for piping git diff through
checkpatch.  The diff output would not contain a commit message, and
therefore it would not contain a signoff line.  For this common use case,
a warning should not be printed about the missing signoff.  With this
change we will only warn about a missing signoff if the input contains a
commit message.

git diff | scripts/checkpatch.pl -

Before this patch, a workaround for the first command was to refer to
stdin by a name other than '-'.  The workaround is not an elegant
solution, because elsewhere checkpatch uses the fact that filename equals
'-', such as in setting '$vname' to 'Your patch' for stdin.  The command
below would report "/dev/stdin has style problems" instead of "Your patch
has style problems."

git show --pretty=email | scripts/checkpatch.pl /dev/stdin

Link: http://lkml.kernel.org/r/48be31e414bddc65bccfa6b1322359be9ba032eb.1469670589.git.allenbh@gmail.com
Signed-off-by: Allen Hubbe <allenbh@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-signoff-when-reading-stdin scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-signoff-when-reading-stdin
+++ a/scripts/checkpatch.pl
@@ -2069,6 +2069,7 @@ sub process {
 	my $is_patch = 0;
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+	my $has_commit_log = 0;		#Encountered lines before patch
        my $commit_log_possible_stack_dump = 0;
 	my $commit_log_long_line = 0;
 	my $commit_log_has_diff = 0;
@@ -2566,6 +2567,7 @@ sub process {
 		      $rawline =~ /^(commit\b|from\b|[\w-]+:).*$/i)) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
+			$has_commit_log = 1;
 		}
 
 # Check if there is UTF-8 in a commit log when a mail header has explicitly
@@ -6055,7 +6057,7 @@ sub process {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
-	if ($is_patch && $filename ne '-' && $chk_signoff && $signoff == 0) {
+	if ($is_patch && $has_commit_log && $chk_signoff && $signoff == 0) {
 		ERROR("MISSING_SIGN_OFF",
 		      "Missing Signed-off-by: line(s)\n");
 	}
_

Patches currently in -mm which might be from allenbh@gmail.com are


