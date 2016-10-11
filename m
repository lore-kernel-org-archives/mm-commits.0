From: akpm@linux-foundation.org
Subject: [patch 022/102] checkpatch: improve the block comment * alignment test
Date: Tue, 11 Oct 2016 13:52:05 -0700
Message-ID: <57fd50f5.UrwoK2keu1966K35%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37885 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, charlemagnelasse@gmail.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the block comment * alignment test

An "uninitialized value" is emitted when a block comment starts on
the same line as a statement.

Fix this and make the test use a little fewer cpu cycles too.

Link: http://lkml.kernel.org/r/3c9993320c2182d37f53ac540878cfef59c3f62d.1473365956.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-block-comment-alignment-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-block-comment-alignment-test
+++ a/scripts/checkpatch.pl
@@ -3005,18 +3005,23 @@ sub process {
 
 # Block comment * alignment
 		if ($prevline =~ /$;[ \t]*$/ &&			#ends in comment
-		    (($prevrawline =~ /^\+.*?\/\*/ &&		#starting /*
+		    $line =~ /^\+[ \t]*$;/ &&			#leading comment
+		    $rawline =~ /^\+[ \t]*\*/ &&		#leading *
+		    (($prevrawline =~ /^\+.*?\/\*/ &&		#leading /*
 		      $prevrawline !~ /\*\/[ \t]*$/) ||		#no trailing */
-		     $prevrawline =~ /^\+[ \t]*\*/) &&		#starting *
-		    $rawline =~ /^\+[ \t]*\*/) {		#rawline *
+		     $prevrawline =~ /^\+[ \t]*\*/)) {		#leading *
+			my $oldindent;
 			$prevrawline =~ m@^\+([ \t]*/?)\*@;
-			my $oldindent = expand_tabs($1);
+			if (defined($1)) {
+				$oldindent = expand_tabs($1);
+			} else {
+				$prevrawline =~ m@^\+(.*/?)\*@;
+				$oldindent = expand_tabs($1);
+			}
 			$rawline =~ m@^\+([ \t]*)\*@;
 			my $newindent = $1;
-			my $test_comment = '^\\+' . "$;" x (length($newindent) + 1);
 			$newindent = expand_tabs($newindent);
-			if ($line =~ /$test_comment/ &&
-			    length($oldindent) ne length($newindent)) {
+			if (length($oldindent) ne length($newindent)) {
 				WARN("BLOCK_COMMENT_STYLE",
 				     "Block comments should align the * on each line\n" . $hereprev);
 			}
_
