From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-macro-reuse-test.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:27:07 -0700
Message-ID: <20170711192707.djangJ5Ri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932895AbdGKT1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve macro reuse test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-macro-reuse-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4940,17 +4940,17 @@ sub process {
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

