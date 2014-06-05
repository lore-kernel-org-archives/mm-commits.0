From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:41 -0700
Message-ID: <5390cd95.KiOBge4y+wb5tYhV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFEUFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:41 -0700


The patch titled
     Subject: checkpatch: always warn on missing blank line after variable declaration block
has been removed from the -mm tree.  Its filename was
     checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: always warn on missing blank line after variable declaration block

Make the test system wide, modify the message too.

Signed-off-by: Joe Perches <joe@perches.com>	
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   44 ++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block
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
@@ -2268,18 +2273,37 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
-		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
-		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
-		    $sline =~ /^\+\s+/ &&			#Not at char 1
-		    !($sline =~ /^\+\s+$Declare/ ||
-		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
+			# actual declarations
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
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
+		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			# foo bar; where foo is some local typedef or #define
+		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		      $sline =~ /^\+\s+$declaration_macros/ ||
+			# start of struct or union or enum
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
-		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+			# start or end of block or continuation of declaration
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+			# bitfield continuation
+		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
+			# other possible extensions of declaration lines
+		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
+			# indentation of previous and current line are the same
+		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
 			WARN("SPACING",
-			     "networking uses a blank line after declarations\n" . $hereprev);
+			     "Missing a blank line after declarations\n" . $hereprev);
 		}
 
 # check for spaces at the beginning of a line.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
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
maintainers-add-linux-api-for-review-of-api-abi-changes.patch

