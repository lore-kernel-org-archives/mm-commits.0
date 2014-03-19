From: akpm@linux-foundation.org
Subject: + checkpatch-improve-octal-permissions-test-speed.patch added to
 -mm tree
Date: Wed, 19 Mar 2014 14:15:12 -0700
Message-ID: <532a08e0.biFoB4qblcq1E/Pj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaCSVPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 17:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-improve-octal-permissions-test-speed.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 14:15:12 -0700


The patch titled
     Subject: checkpatch: improve octal permissions test speed
has been added to the -mm tree.  Its filename is
     checkpatch-improve-octal-permissions-test-speed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-octal-permissions-test-speed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-octal-permissions-test-speed.patch

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
@@ -4538,26 +4545,30 @@ sub process {
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

errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
linux-next.patch

