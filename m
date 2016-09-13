From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch
 added to -mm tree
Date: Tue, 13 Sep 2016 14:53:03 -0700
Message-ID: <57d8753f.JyWWIH+7+PR+ubXL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35183 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcIMVxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for precedence challenged macro arguments
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch

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
Subject: checkpatch: add --strict test for precedence challenged macro arguments

Add a test for macro arguents that have a non-comma leading or trailing
operator where the argument isn't parenthesized to avoid possible precedence
issues.

Link: http://lkml.kernel.org/r/47715508972f8d786f435e583ff881dbeee3a114.1473745855.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-precedence-challenged-macro-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-precedence-challenged-macro-arguments
+++ a/scripts/checkpatch.pl
@@ -4836,7 +4836,7 @@ sub process {
 # check if any macro arguments are reused (ignore '...' and 'type')
 			foreach my $arg (@def_args) {
 			        next if ($arg =~ /\.\.\./);
-			        next if ($arg =~ /^type$/);
+			        next if ($arg =~ /^type$/i);
 				my $tmp = $define_stmt;
 				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
 				$tmp =~ s/\#\s*$arg\b//g;
@@ -4845,6 +4845,13 @@ sub process {
 				if ($use_cnt > 1) {
 					CHK("MACRO_ARG_REUSE",
 					    "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
+				    }
+# check if any macro arguments may have other precedence issues
+				if ($define_stmt =~ m/($Operators)?\s*\b$arg\b\s*($Operators)?/m &&
+				    ((defined($1) && $1 ne ',') ||
+				     (defined($2) && $2 ne ','))) {
+					CHK("MACRO_ARG_PRECEDENCE",
+					    "Macro argument '$arg' may be better as '($arg)' to avoid precedence issues\n" . "$herectx");
 				}
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
checkpatch-add-strict-test-for-macro-argument-reuse.patch
checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch

