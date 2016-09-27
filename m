From: akpm@linux-foundation.org
Subject: [withdrawn] checkpatch-improve-octal-permission-test.patch
 removed from -mm tree
Date: Tue, 27 Sep 2016 15:45:53 -0700
Message-ID: <57eaf6a1.fg++NF5uwgJUZ/SE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbcI0Wpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 18:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve octal permission test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-octal-permission-test.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve octal permission test

The function calls with octal permissions commonly span multiple lines. 
The current test is line oriented and fails to find some matches.

Make the test use the $stat variable instead of the $line variable to
span multiple lines.

Link: http://lkml.kernel.org/r/eb276b5a9de12256694ad31c806dbe8c7ee3ef8c.1474999653.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-octal-permission-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-octal-permission-test
+++ a/scripts/checkpatch.pl
@@ -6092,28 +6092,36 @@ sub process {
 # Mode permission misuses where it seems decimal should be octal
 # This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /$mode_perms_search/) {
+		    defined $stat &&
+		    $stat =~ /^.\s*$mode_perms_search/) {
 			foreach my $entry (@mode_permission_funcs) {
 				my $func = $entry->[0];
 				my $arg_pos = $entry->[1];
 
+				my $lc = $stat =~ tr@\n@@;
+				$lc = $lc + $linenr;
+				my $stat_real = raw_line($linenr, 0);
+				for (my $count = $linenr + 1; $count <= $lc; $count++) {
+					$stat_real = $stat_real . "\n" . raw_line($count, 0);
+				}
+
 				my $skip_args = "";
 				if ($arg_pos > 1) {
 					$arg_pos--;
 					$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
 				}
 				my $test = "\\b$func\\s*\\(${skip_args}($FuncArg(?:\\|\\s*$FuncArg)*)\\s*[,\\)]";
-				if ($line =~ /$test/) {
+				if ($stat =~ /$test/) {
 					my $val = $1;
 					$val = $6 if ($skip_args ne "");
 					if (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
 					    ($val =~ /^$Octal$/ && length($val) ne 4)) {
 						ERROR("NON_OCTAL_PERMISSIONS",
-						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+						      "Use 4 digit octal (0777) not decimal permissions\n" . $stat_real);
 					}
 					if ($val =~ /^$Octal$/ && (oct($val) & 02)) {
 						ERROR("EXPORTED_WORLD_WRITABLE",
-						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
+						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $stat_real);
 					}
 					if ($val =~ /\b$mode_perms_string_search\b/) {
 						my $to = 0;
@@ -6122,9 +6130,12 @@ sub process {
 						}
 						my $new = sprintf("%04o", $to);
 						if (WARN("SYMBOLIC_PERMS",
-							 "Symbolic permissions are not preferred. Consider using octal permissions $new.\n" . $herecurr) &&
+							 "Symbolic permissions are not preferred. Consider using octal permissions $new.\n" . $stat_real) &&
 						    $fix) {
-							$fixed[$fixlinenr] =~ s/\Q$val\E/$new/;
+							$lc = $stat =~ tr@\n@@;
+							for (my $count = $fixlinenr; $count <= $fixlinenr + $lc; $count++) {
+								$fixed[$count] =~ s/\Q$val\E/$new/;
+							}
 						}
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
checkpatch-improve-macro_arg_precedence-test.patch
checkpatch-add-warning-for-unnamed-function-definition-arguments.patch

