From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?checkpatch-fix-stepping-through-statements-with-stat-and-c?=
 =?US-ASCII?Q?tx=5Fstatement=5Fblock.patch?= removed from -mm tree
Date: Tue, 11 Jul 2017 12:26:56 -0700
Message-ID: <20170711192656.QGHwtrEIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755645AbdGKT05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix stepping through statements with $stat and ctx_statement_block
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix stepping through statements with $stat and ctx_statement_block

Fix the off-by-one in the suppression of lines in a statement block.

This means that for multiple line statements like

	foo(bar,
	    baz,
	    qux);

$stat has been inspected first correctly for the entire statement,
and subsequently incorrectly just for

	    qux);

This fix will help make tracking appropriate indentation a little easier.

Link: http://lkml.kernel.org/r/71b25979c90412133c717084036c9851cd2b7bcb.1496862585.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block
+++ a/scripts/checkpatch.pl
@@ -3219,7 +3219,7 @@ sub process {
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
 #print "LINE<$line>\n";
-		if ($linenr >= $suppress_statement &&
+		if ($linenr > $suppress_statement &&
 		    $realcnt && $sline =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
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

