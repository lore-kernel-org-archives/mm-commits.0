From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-multi-line-alignment-test.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:27:09 -0700
Message-ID: <20170711192709.wpY8cp4J4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdGKT1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve multi-line alignment test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-multi-line-alignment-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve multi-line alignment test

The current test fails to warn about improper alignment with code like

	foo->bar = func(arg1,
				arg2);

because foo->bar is not a single identifier.

Convert the $Ident to $Lval which allows for multiple dereferences.

Link: http://lkml.kernel.org/r/01c35b9b6a12a415e57746d45d589bfaad39952a.1498841563.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-multi-line-alignment-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-multi-line-alignment-test
+++ a/scripts/checkpatch.pl
@@ -2993,7 +2993,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|(?:\*\s*)*$Lval\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
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

