From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-octal-permissions-test-speed.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:14 -0700
Message-ID: <533f0936.PqOvTy70kYP8t8dF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaDDTeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-improve-octal-permissions-test-speed.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:14 -0700


The patch titled
     Subject: checkpatch: improve octal permissions test speed
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-octal-permissions-test-speed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve octal permissions test speed

The current octal permissions test is very slow.

When 3fc9249967 ("checkpatch: add checks for constant non-octal
permissions") was added, processing time approximately tripled.

Regain almost all of the performance by not looping through all the
possible functions unless the line contains one of the functions.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   51 ++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-octal-permissions-test-speed scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-octal-permissions-test-speed
+++ a/scripts/checkpatch.pl
@@ -388,6 +388,13 @@ our @mode_permission_funcs = (
 	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
 );
 
+#Create a search pattern for all these functions to speed up a loop below
+our $mode_perms_search = "";
+foreach my $entry (@mode_permission_funcs) {
+	$mode_perms_search .= '|' if ($mode_perms_search ne "");
+	$mode_perms_search .= $entry->[0];
+}
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -4524,26 +4531,30 @@ sub process {
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
 
-		foreach my $entry (@mode_permission_funcs) {
-			my $func = $entry->[0];
-			my $arg_pos = $entry->[1];
-
-			my $skip_args = "";
-			if ($arg_pos > 1) {
-				$arg_pos--;
-				$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
-			}
-			my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
-			if ($^V && $^V ge 5.10.0 &&
-			    $line =~ /$test/) {
-				my $val = $1;
-				$val = $6 if ($skip_args ne "");
-
-				if ($val !~ /^0$/ &&
-				    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
-				     length($val) ne 4)) {
-					ERROR("NON_OCTAL_PERMISSIONS",
-					      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+# Mode permission misuses where it seems decimal should be octal
+# This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /$mode_perms_search/) {
+			foreach my $entry (@mode_permission_funcs) {
+				my $func = $entry->[0];
+				my $arg_pos = $entry->[1];
+
+				my $skip_args = "";
+				if ($arg_pos > 1) {
+					$arg_pos--;
+					$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
+				}
+				my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
+				if ($line =~ /$test/) {
+					my $val = $1;
+					$val = $6 if ($skip_args ne "");
+
+					if ($val !~ /^0$/ &&
+					    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+					     length($val) ne 4)) {
+						ERROR("NON_OCTAL_PERMISSIONS",
+						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

