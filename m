From: akpm@linux-foundation.org
Subject: + checkpatch-improve-the-block-comment-alignment-test.patch added to -mm tree
Date: Thu, 08 Sep 2016 15:04:11 -0700
Message-ID: <57d1e05b.M7UTjg4gwYiP3gHZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45609 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932233AbcIHWEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, charlemagnelasse@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the block comment * alignment test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-block-comment-alignment-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-block-comment-alignment-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-block-comment-alignment-test.patch

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

Patches currently in -mm which might be from joe@perches.com are

seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch
checkpatch-dont-test-for-prefer-ether_addr_foo.patch
checkpatch-externalize-the-structs-that-should-be-const.patch
const_structscheckpatch-add-frequently-used-from-julia-lawalls-list.patch
checkpatch-speed-up-checking-for-filenames-in-sections-marked-obsolete.patch
checkpatch-improve-the-block-comment-alignment-test.patch

