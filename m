From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-tests-for-multiple-line-function-definitions.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:27:00 -0700
Message-ID: <20170711192700.wm33hLt0z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755645AbdGKT1B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.kershner@unisys.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve tests for multiple line function definitions
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-tests-for-multiple-line-function-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve tests for multiple line function definitions

Add a block that identifies multiple line function definitions.

Save the function name into $context_function to improve the embedded
function name test.

Look for misplaced open brace on the function definition.
Emit an OPEN_BRACE error when the function definition is similar to

     void foo(int arg1,
              int arg2) {

Miscellanea:

o Remove the $realfile test in function declaration w/o named arguments test
o Comment the function declaration w/o named arguments test

Link: http://lkml.kernel.org/r/de620ed6ebab75fdfa323741ada2134a0f545892.1496835238.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: David Kershner <david.kershner@unisys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-tests-for-multiple-line-function-definitions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-tests-for-multiple-line-function-definitions
+++ a/scripts/checkpatch.pl
@@ -5899,7 +5899,8 @@ sub process {
 			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
-		if ($realfile =~ /\.[ch]$/ && defined $stat &&
+# check for function declarations that have arguments without identifier names
+		if (defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
 		    $1 ne "void") {
 			my $args = trim($1);
@@ -5912,6 +5913,29 @@ sub process {
 			}
 		}
 
+# check for function definitions
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^.\s*(?:$Storage\s+)?$Type\s*($Ident)\s*$balanced_parens\s*{/s) {
+			$context_function = $1;
+
+# check for multiline function definition with misplaced open brace
+			my $ok = 0;
+			my $cnt = statement_rawlines($stat);
+			my $herectx = $here . "\n";
+			for (my $n = 0; $n < $cnt; $n++) {
+				my $rl = raw_line($linenr, $n);
+				$herectx .=  $rl . "\n";
+				$ok = 1 if ($rl =~ /^[ \+]\{/);
+				$ok = 1 if ($rl =~ /\{/ && $n == 0);
+				last if $rl =~ /^[ \+].*\{/;
+			}
+			if (!$ok) {
+				ERROR("OPEN_BRACE",
+				      "open brace '{' following function definitions go on the next line\n" . $herectx);
+			}
+		}
+
 # checks for new __setup's
 		if ($rawline =~ /\b__setup\("([^"]*)"/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch

