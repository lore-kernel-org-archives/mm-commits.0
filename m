From: akpm@linux-foundation.org
Subject: + checkpatch-improve-macro_arg_precedence-test.patch added to -mm tree
Date: Wed, 14 Sep 2016 15:29:33 -0700
Message-ID: <57d9cf4d.Xbc1TituRJZzNafP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42947 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756110AbcINW3f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:29:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve MACRO_ARG_PRECEDENCE test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-macro_arg_precedence-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-macro_arg_precedence-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-macro_arg_precedence-test.patch

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
Subject: checkpatch: improve MACRO_ARG_PRECEDENCE test

It is possible for a multiple line macro definition to have a false positive
report when an argument is used on a line after a continuation \.

This line might have a leading '+' as the initial character that could be
confused by checkpatch as an operator.

Avoid the leading character on multiple line macro definitions.

Link: http://lkml.kernel.org/r/60229d13399f9b6509db5a32e30d4c16951a60cd.1473836073.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-macro_arg_precedence-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-macro_arg_precedence-test
+++ a/scripts/checkpatch.pl
@@ -4833,13 +4833,31 @@ sub process {
 				}
 
 			}
+
+			# Make $define_stmt single line, comment-free, etc
+			my @stmt_array = split('\n', $define_stmt);
+			my $first = 1;
+			$define_stmt = "";
+			foreach my $l (@stmt_array) {
+				$l =~ s/\\$//;
+				if ($first) {
+					$define_stmt = $l;
+					$first = 0;
+				} elsif ($l =~ /^[\+ ]/) {
+					$define_stmt .= substr($l, 1);
+				}
+			}
+			$define_stmt =~ s/$;//g;
+			$define_stmt =~ s/\s+/ /g;
+			$define_stmt = trim($define_stmt);
+
 # check if any macro arguments are reused (ignore '...' and 'type')
 			foreach my $arg (@def_args) {
 			        next if ($arg =~ /\.\.\./);
 			        next if ($arg =~ /^type$/i);
 				my $tmp = $define_stmt;
 				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
-				$tmp =~ s/\#\s*$arg\b//g;
+				$tmp =~ s/\#+\s*$arg\b//g;
 				$tmp =~ s/\b$arg\s*\#\#//g;
 				my $use_cnt = $tmp =~ s/\b$arg\b//g;
 				if ($use_cnt > 1) {
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
checkpatch-add-strict-test-for-macro-argument-reuse.patch
checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch
checkpatch-improve-macro_arg_precedence-test.patch

