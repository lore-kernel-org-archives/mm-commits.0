From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-macro_arg_precedence-test.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:27 -0700
Message-ID: <57fe8daf.JNmInXId9ySgIqjG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755995AbcJLTYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve MACRO_ARG_PRECEDENCE test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-macro_arg_precedence-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


