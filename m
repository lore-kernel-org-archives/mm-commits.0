From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-checks-for-do-while-0-macro-misuses.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:48 -0700
Message-ID: <20120731185149.1481E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48958 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2GaSvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:50 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so295516lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add checks for do {} while (0) macro misuses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-checks-for-do-while-0-macro-misuses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add checks for do {} while (0) macro misuses

These types of macros should not be used for either a single statement nor
should the macro end with a semi-colon.

Add tests for these conditions.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-do-while-0-macro-misuses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-do-while-0-macro-misuses
+++ a/scripts/checkpatch.pl
@@ -2988,6 +2988,45 @@ sub process {
 			}
 		}
 
+# do {} while (0) macro tests:
+# single-statement macros do not need to be enclosed in do while (0) loop,
+# macro should not end with a semicolon
+		if ($^V && $^V ge 5.10.0 &&
+		    $realfile !~ m@/vmlinux.lds.h$@ &&
+		    $line =~ /^.\s*\#\s*define\s+$Ident(\()?/) {
+			my $ln = $linenr;
+			my $cnt = $realcnt;
+			my ($off, $dstat, $dcond, $rest);
+			my $ctx = '';
+			($dstat, $dcond, $ln, $cnt, $off) =
+				ctx_statement_block($linenr, $realcnt, 0);
+			$ctx = $dstat;
+
+			$dstat =~ s/\\\n.//g;
+
+			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*${balanced_parens}\s*do\s*{(.*)\s*}\s*while\s*\(\s*0\s*\)\s*([;\s]*)\s*$/) {
+				my $stmts = $2;
+				my $semis = $3;
+
+				$ctx =~ s/\n*$//;
+				my $cnt = statement_rawlines($ctx);
+				my $herectx = $here . "\n";
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+
+				if (($stmts =~ tr/;/;/) == 1) {
+					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
+					     "Single statement macros should not use a do {} while (0) loop\n" . "$herectx");
+				}
+				if (defined $semis && $semis ne "") {
+					WARN("DO_WHILE_MACRO_WITH_TRAILING_SEMICOLON",
+					     "do {} while (0) macros should not be semicolon terminated\n" . "$herectx");
+				}
+			}
+		}
+
 # make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
 # all assignments may have only one of the following with an assignment:
 #	.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

