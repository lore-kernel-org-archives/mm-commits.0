From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch removed from -mm tree
Date: Mon, 05 May 2014 15:09:05 -0700
Message-ID: <53680c01.1RZI6oKrehtEg4hE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaEEWJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [folded-merged] checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:09:05 -0700


The patch titled
     Subject: checkpatch: reduce false positives for "Missing blank line after declarations" test
has been removed from the -mm tree.  Its filename was
     checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch

This patch was dropped because it was folded into checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: reduce false positives for "Missing blank line after declarations" test

Reduce the false positives of this test by checking previous lines for
known macros that declare variables.

Add c90 keywords and test those too.

Comment the specific tests done a bit better.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test
+++ a/scripts/checkpatch.pl
@@ -397,6 +397,11 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= $entry->[0];
 }
 
+our $declaration_macros = qr{(?x:
+	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
+	(?:$Storage\s+)?LIST_HEAD\s*\(
+)};
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -2268,14 +2273,32 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
-		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
-		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
-		    $sline =~ /^\+\s+/ &&			#Not at char 1
+		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
+			# actual declarations
+		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+			# foo bar; where foo is some local typedef or #define
+		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		     $prevline =~ /^\+\s+$declaration_macros/) &&
+			# for "else if" which can look like "$Ident $Ident"
+		    !($prevline =~ /^\+\s+$c90_Keywords\b/ ||
+			# other possible extensions of declaration lines
+		      $prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+			# not starting a section or a macro "\" extended line
+		      $prevline =~ /(?:\{\s*|\\)$/) &&
+			# looks like a declaration
 		    !($sline =~ /^\+\s+$Declare/ ||
-		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+			# foo bar; where foo is some local typedef or #define
+		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		      $sline =~ /^\+\s+$declaration_macros/ ||
+			# start of struct or union or enum
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+			# start or end of block or continuation of declaration
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+			# bitfield continuation
+		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
+			# other possible extensions of declaration lines
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
_

Patches currently in -mm which might be from joe@perches.com are

mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
init-mainc-dont-use-pr_debug.patch
fs-isofs-logging-clean-up.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

