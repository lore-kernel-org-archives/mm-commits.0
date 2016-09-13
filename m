From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-test-for-macro-argument-reuse.patch added to -mm tree
Date: Tue, 13 Sep 2016 14:52:41 -0700
Message-ID: <57d87529.EimjPbHWlPtkVrdx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbcIMVw4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for macro argument reuse
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-macro-argument-reuse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-test-for-macro-argument-reuse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-test-for-macro-argument-reuse.patch

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
Subject: checkpatch: add --strict test for macro argument reuse

If a macro argument is used multiple times in the macro definition, the
macro argument may have an unexpected side-effect.

Add a test (MACRO_ARG_REUSE) for that condition which is only
emitted with command-line option --strict.

Link: http://lkml.kernel.org/r/b6d67a87cafcafd15499e91780dc63b15dec0aa0.1473744906.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   43 ++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-macro-argument-reuse scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-macro-argument-reuse
+++ a/scripts/checkpatch.pl
@@ -4753,7 +4753,17 @@ sub process {
 			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
 			$has_arg_concat = 1 if ($ctx =~ /\#\#/ && $ctx !~ /\#\#\s*(?:__VA_ARGS__|args)\b/);
 
-			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
+			$dstat =~ s/^.\s*\#\s*define\s+$Ident(\([^\)]*\))?\s*//;
+			my $define_args = $1;
+			my $define_stmt = $dstat;
+			my @def_args = ();
+
+			if (defined $define_args && $define_args ne "") {
+				$define_args = substr($define_args, 1, length($define_args) - 2);
+				$define_args =~ s/\s*//g;
+				@def_args = split(",", $define_args);
+			}
+
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
 			$dstat =~ s/^\s*//s;
@@ -4789,6 +4799,15 @@ sub process {
 				^\[
 			}x;
 			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
+
+			$ctx =~ s/\n*$//;
+			my $herectx = $here . "\n";
+			my $stmt_cnt = statement_rawlines($ctx);
+
+			for (my $n = 0; $n < $stmt_cnt; $n++) {
+				$herectx .= raw_line($linenr, $n) . "\n";
+			}
+
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
@@ -4804,13 +4823,6 @@ sub process {
 			    $dstat !~ /^\(\{/ &&						# ({...
 			    $ctx !~ /^.\s*#\s*define\s+TRACE_(?:SYSTEM|INCLUDE_FILE|INCLUDE_PATH)\b/)
 			{
-				$ctx =~ s/\n*$//;
-				my $herectx = $here . "\n";
-				my $cnt = statement_rawlines($ctx);
-
-				for (my $n = 0; $n < $cnt; $n++) {
-					$herectx .= raw_line($linenr, $n) . "\n";
-				}
 
 				if ($dstat =~ /;/) {
 					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
@@ -4819,6 +4831,21 @@ sub process {
 					ERROR("COMPLEX_MACRO",
 					      "Macros with complex values should be enclosed in parentheses\n" . "$herectx");
 				}
+
+			}
+# check if any macro arguments are reused (ignore '...' and 'type')
+			foreach my $arg (@def_args) {
+			        next if ($arg =~ /\.\.\./);
+			        next if ($arg =~ /^type$/);
+				my $tmp = $define_stmt;
+				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
+				$tmp =~ s/\#\s*$arg\b//g;
+				$tmp =~ s/\b$arg\s*\#\#//g;
+				my $use_cnt = $tmp =~ s/\b$arg\b//g;
+				if ($use_cnt > 1) {
+					CHK("MACRO_ARG_REUSE",
+					    "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
+				}
 			}
 
 # check for macros with flow control, but without ## concatenation
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

