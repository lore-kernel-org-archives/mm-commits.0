From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch added to -mm tree
Date: Mon, 01 May 2017 16:40:59 -0700
Message-ID: <5907c78b.Kb2e8uHdJhNvTxm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdEAXlB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 1 May 2017 19:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the embedded function name test for patch contexts
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch

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
Subject: checkpatch: improve the embedded function name test for patch contexts

The current test works only for a single patch context as it is done in
the foreach ($rawlines) loop that precedes the loop where the actual
$context_function variable is used.

Move the set of $context_function into the foreach (@lines) loop where it
is useful for each patch context.

Link: http://lkml.kernel.org/r/6c675a31c74fbfad4fc45b9f462303d60ca2a283.1493486091.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-embedded-function-name-test-for-patch-contexts scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-embedded-function-name-test-for-patch-contexts
+++ a/scripts/checkpatch.pl
@@ -2213,8 +2213,7 @@ sub process {
 			}
 			#next;
 		}
-		if ($rawline=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@(.*)/) {
-			my $context = $4;
+		if ($rawline =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$realline=$1-1;
 			if (defined $2) {
 				$realcnt=$3+1;
@@ -2223,12 +2222,6 @@ sub process {
 			}
 			$in_comment = 0;
 
-			if ($context =~ /\b(\w+)\s*\(/) {
-				$context_function = $1;
-			} else {
-				undef $context_function;
-			}
-
 			# Guestimate if this is a continuing comment.  Run
 			# the context looking for a comment "edge".  If this
 			# edge is a close comment then we must be in a comment
@@ -2299,7 +2292,8 @@ sub process {
 
 #extract the line range in the file after the patch is applied
 		if (!$in_commit_log &&
-		    $line =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
+		    $line =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@(.*)/) {
+			my $context = $4;
 			$is_patch = 1;
 			$first_line = $linenr + 1;
 			$realline=$1-1;
@@ -2315,6 +2309,11 @@ sub process {
 			%suppress_whiletrailers = ();
 			%suppress_export = ();
 			$suppress_statement = 0;
+			if ($context =~ /\b(\w+)\s*\(/) {
+				$context_function = $1;
+			} else {
+				undef $context_function;
+			}
 			next;
 
 # track the line number as we move through the hunk, note that
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch
checkpatch-improve-multistatement_macro_use_do_while-test.patch
checkpatch-clarify-the-embedded_function_name-message.patch
checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch
checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch
treewide-correct-diffrent-and-banlance-typos.patch

