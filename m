From: akpm@linux-foundation.org
Subject: + checkpatch-improve-macro-reuse-test.patch added to -mm tree
Date: Mon, 26 Jun 2017 15:51:34 -0700
Message-ID: <59518ff6.lteFRA+KCHAfWwaq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752451AbdFZWvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 18:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve macro reuse test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-macro-reuse-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-macro-reuse-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-macro-reuse-test.patch

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
Subject: checkpatch: improve macro reuse test

checkpatch reports a false positive when using token pasting argument
multiple times in a macro.

Fix it.

Miscellanea:

o Make the $tmp variable name used in the macro argument tests
  a bit more descriptive

Link: http://lkml.kernel.org/r/cf434ae7602838388c7cb49d42bca93ab88527e7.1498483044.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-macro-reuse-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-macro-reuse-test
+++ a/scripts/checkpatch.pl
@@ -4939,17 +4939,17 @@ sub process {
 			foreach my $arg (@def_args) {
 			        next if ($arg =~ /\.\.\./);
 			        next if ($arg =~ /^type$/i);
-				my $tmp = $define_stmt;
-				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
-				$tmp =~ s/\#+\s*$arg\b//g;
-				$tmp =~ s/\b$arg\s*\#\#//g;
-				my $use_cnt = $tmp =~ s/\b$arg\b//g;
+				my $tmp_stmt = $define_stmt;
+				$tmp_stmt =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
+				$tmp_stmt =~ s/\#+\s*$arg\b//g;
+				$tmp_stmt =~ s/\b$arg\s*\#\#//g;
+				my $use_cnt = $tmp_stmt =~ s/\b$arg\b//g;
 				if ($use_cnt > 1) {
 					CHK("MACRO_ARG_REUSE",
 					    "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
 				    }
 # check if any macro arguments may have other precedence issues
-				if ($define_stmt =~ m/($Operators)?\s*\b$arg\b\s*($Operators)?/m &&
+				if ($tmp_stmt =~ m/($Operators)?\s*\b$arg\b\s*($Operators)?/m &&
 				    ((defined($1) && $1 ne ',') ||
 				     (defined($2) && $2 ne ','))) {
 					CHK("MACRO_ARG_PRECEDENCE",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch

