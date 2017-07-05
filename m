From: akpm@linux-foundation.org
Subject: + checkpatch-improve-the-storage_class-test.patch added to -mm
 tree
Date: Wed, 05 Jul 2017 13:45:04 -0700
Message-ID: <595d4fd0.xEJT1HUIJP0KbsRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbdGEUpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the STORAGE_CLASS test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-storage_class-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-storage_class-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-storage_class-test.patch

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
Subject: checkpatch: improve the STORAGE_CLASS test

Make sure static, extern, and asmlinkage appear before a specific type.

e.g.:
	int asmlinkage foo(void)
is better written
       asmlinkage int foo(void)

Link: http://lkml.kernel.org/r/31704c96df2d5fd9df0b41165940a7a4feb16a63.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-storage_class-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-storage_class-test
+++ a/scripts/checkpatch.pl
@@ -5576,10 +5576,18 @@ sub process {
 			    "architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
+# check that the storage class is not after a type
+		if ($line =~ /\b($Type)\s+($Storage)\b/) {
+			WARN("STORAGE_CLASS",
+			     "storage class '$2' should be located before type '$1'\n" . $herecurr);
+		}
 # Check that the storage class is at the beginning of a declaration
-		if ($line =~ /\b$Storage\b/ && $line !~ /^.\s*$Storage\b/) {
+		if ($line =~ /\b$Storage\b/ &&
+		    $line !~ /^.\s*$Storage/ &&
+		    $line =~ /^.\s*(.+?)\$Storage\s/ &&
+		    $1 !~ /[\,\)]\s*$/) {
 			WARN("STORAGE_CLASS",
-			     "storage class should be at the beginning of the declaration\n" . $herecurr)
+			     "storage class should be at the beginning of the declaration\n" . $herecurr);
 		}
 
 # check the location of the inline attribute, that it is between
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
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
alsa-opl4-move-inline-before-return-type.patch

