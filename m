From: akpm@linux-foundation.org
Subject: + checkpatch-test-multiple-line-block-comment-alignment.patch
 added to -mm tree
Date: Mon, 29 Aug 2016 15:06:55 -0700
Message-ID: <57c4b1ff.yICkUL51ZgdBgZHG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753429AbcH2WHC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 18:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: test multiple line block comment alignment
has been added to the -mm tree.  Its filename is
     checkpatch-test-multiple-line-block-comment-alignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-test-multiple-line-block-comment-alignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-test-multiple-line-block-comment-alignment.patch

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
Subject: checkpatch: test multiple line block comment alignment

Warn when block comments are not aligned on the *

/*
 * block comment, no warning
 */

/*
  * block comment, emit warning
  */

Link: http://lkml.kernel.org/r/edb57bd330adfe024b95ec2a807d4aa7f0c8b112.1472261299.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-test-multiple-line-block-comment-alignment scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-test-multiple-line-block-comment-alignment
+++ a/scripts/checkpatch.pl
@@ -2979,6 +2979,25 @@ sub process {
 			     "Block comments use a trailing */ on a separate line\n" . $herecurr);
 		}
 
+# Block comment * alignment
+		if ($prevline =~ /$;[ \t]*$/ &&			#ends in comment
+		    (($prevrawline =~ /^\+.*?\/\*/ &&		#starting /*
+		      $prevrawline !~ /\*\/[ \t]*$/) ||		#no trailing */
+		     $prevrawline =~ /^\+[ \t]*\*/) &&		#starting *
+		    $rawline =~ /^\+[ \t]*\*/) {		#rawline *
+			$prevrawline =~ m@^\+([ \t]*/?)\*@;
+			my $oldindent = expand_tabs($1);
+			$rawline =~ m@^\+([ \t]*)\*@;
+			my $newindent = $1;
+			my $test_comment = '^\\+' . "$;" x (length($newindent) + 1);
+			$newindent = expand_tabs($newindent);
+			if ($line =~ /$test_comment/ &&
+			    length($oldindent) ne length($newindent)) {
+				WARN("BLOCK_COMMENT_STYLE",
+				     "Block comments should align the * on each line\n" . $hereprev);
+			}
+		}
+
 # check for missing blank lines after struct/union declarations
 # with exceptions for various attributes and macros
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
_

Patches currently in -mm which might be from joe@perches.com are

seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch

