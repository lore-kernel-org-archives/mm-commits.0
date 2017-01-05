From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-embedded-function-names.patch added to -mm
 tree
Date: Thu, 05 Jan 2017 15:56:23 -0800
Message-ID: <586edd27.rdX4vK3vSLaC8KaL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965089AbdAEXzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on embedded function names
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-embedded-function-names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-embedded-function-names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-embedded-function-names.patch

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
Subject: checkpatch: warn on embedded function names

Embedded function names are less appropriate to use when refactoring can
cause function renaming.  Prefer the use of "%s", __func__ to embedded
function names.

Link: http://lkml.kernel.org/r/ac9631fdbac5af3507c5bfe88ad9064f0ed764ec.1483510416.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-embedded-function-names scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-embedded-function-names
+++ a/scripts/checkpatch.pl
@@ -2134,7 +2134,7 @@ sub process {
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 	my $has_commit_log = 0;		#Encountered lines before patch
-       my $commit_log_possible_stack_dump = 0;
+	my $commit_log_possible_stack_dump = 0;
 	my $commit_log_long_line = 0;
 	my $commit_log_has_diff = 0;
 	my $reported_maintainer_file = 0;
@@ -2154,6 +2154,7 @@ sub process {
 	my $realline = 0;
 	my $realcnt = 0;
 	my $here = '';
+	my $context_function;		#undef'd unless there's a known function
 	my $in_comment = 0;
 	my $comment_edge = 0;
 	my $first_line = 0;
@@ -2192,7 +2193,8 @@ sub process {
 			}
 			#next;
 		}
-		if ($rawline=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
+		if ($rawline=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@(.*)/) {
+			my $context = $4;
 			$realline=$1-1;
 			if (defined $2) {
 				$realcnt=$3+1;
@@ -2201,6 +2203,12 @@ sub process {
 			}
 			$in_comment = 0;
 
+			if ($context =~ /\b(\w+)\s*\(/) {
+				$context_function = $1;
+			} else {
+				undef $context_function;
+			}
+
 			# Guestimate if this is a continuing comment.  Run
 			# the context looking for a comment "edge".  If this
 			# edge is a close comment then we must be in a comment
@@ -5157,6 +5165,16 @@ sub process {
 			     "break quoted strings at a space character\n" . $hereprev);
 		}
 
+#check for an embedded function name in a string when the function is known
+# as part of a diff.  This does not work for -f --file checking as it
+#depends on patch context providing the function name
+		if ($line =~ /^\+.*$String/ &&
+		    defined($context_function) &&
+		    get_quoted_string($line, $rawline) =~ /\b$context_function\b/) {
+			WARN("EMBEDDED_FUNCTION_NAME",
+			     "Prefer using \"%s\", __func__ to embedded function names\n" . $herecurr);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-warn-on-embedded-function-names.patch

