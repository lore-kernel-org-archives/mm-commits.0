From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-when-a-maintainers-entry-isnt-t.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:26:52 -0700
Message-ID: <20170711192652.Y22fkd_Hs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754042AbdGKT0x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when a MAINTAINERS entry isn't [A-Z]:	
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-when-a-maintainers-entry-isnt-t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when a MAINTAINERS entry isn't [A-Z]:\t

For consistency, MAINTAINERS entries should be an upper case letter, then
a colon, then a tab, then the value.

Warn when an entry doesn't have this form.  --fix it too.

Link: http://lkml.kernel.org/r/9aaaf03ec10adf3888b5e98dd2176b7fe9b5fad8.1496343345.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-a-maintainers-entry-isnt-t scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-a-maintainers-entry-isnt-t
+++ a/scripts/checkpatch.pl
@@ -2776,6 +2776,17 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
+# check for MAINTAINERS entries that don't have the right form
+		if ($realfile =~ /^MAINTAINERS$/ &&
+		    $rawline =~ /^\+[A-Z]:/ &&
+		    $rawline !~ /^\+[A-Z]:\t\S/) {
+			if (WARN("MAINTAINERS_STYLE",
+				 "MAINTAINERS entries use one tab after TYPE:\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^(\+[A-Z]):\s*/$1:\t/;
+			}
+		}
+
 # discourage the use of boolean for type definition attributes of Kconfig options
 		if ($realfile =~ /Kconfig/ &&
 		    $line =~ /^\+\s*\bboolean\b/) {
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

