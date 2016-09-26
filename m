From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-warning-for-unnamed-function-definition-arguments.patch
 added to -mm tree
Date: Mon, 26 Sep 2016 15:36:37 -0700
Message-ID: <57e9a2f5.uOGfsXiU8scy/ra6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45797 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753240AbcIZWgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 18:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning for unnamed function definition arguments
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-for-unnamed-function-definition-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-for-unnamed-function-definition-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-for-unnamed-function-definition-arguments.patch

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
Subject: checkpatch: add warning for unnamed function definition arguments

Function definitions without identifiers like
	 int foo(int)
are not preferred.  Emit a warning when they occur.

Link: http://lkml.kernel.org/r/94fe6378504745991b650f48fc92bb4648f25706.1474925354.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-for-unnamed-function-definition-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-unnamed-function-definition-arguments
+++ a/scripts/checkpatch.pl
@@ -5794,6 +5794,19 @@ sub process {
 			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
+		if ($realfile =~ /\.[ch]$/ && defined $stat &&
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
+		    $1 ne "void") {
+			my $args = trim($1);
+			while ($args =~ m/\s*($Type\s*(?:$Ident|\(\s*\*\s*$Ident?\s*\)\s*$balanced_parens)?)/g) {
+				my $arg = trim($1);
+				if ($arg =~ /^$Type$/ && $arg !~ /enum\s+$Ident$/) {
+					WARN("FUNCTION_ARGUMENTS",
+					     "function definition argument '$arg' should also have an identifier name\n" . $herecurr);
+				}
+			}
+		}
+
 # checks for new __setup's
 		if ($rawline =~ /\b__setup\("([^"]*)"/) {
 			my $name = $1;
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
checkpatch-add-warning-for-unnamed-function-definition-arguments.patch

