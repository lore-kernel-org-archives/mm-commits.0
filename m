From: akpm@linux-foundation.org
Subject: + checkpatch-refactor-allowed-asm-includes-and-add-memoryh.patch added to -mm tree
Date: Wed, 02 Jun 2010 11:35:26 -0700
Message-ID: <201006021835.o52IZQGn009837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab0FBSg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 14:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, apw@shadowen.org, linux@arm.linux.org.uk


The patch titled
     checkpatch: refactor 'allowed asm includes' and add memory.h
has been added to the -mm tree.  Its filename is
     checkpatch-refactor-allowed-asm-includes-and-add-memoryh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: refactor 'allowed asm includes' and add memory.h
From: Wolfram Sang <w.sang@pengutronix.de>

Change the check suggesting replacement of asm-includes with
linux-includes.  Exceptions to this rule are easier to extend now.  Add
memory.h because ARM has a custom one.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-refactor-allowed-asm-includes-and-add-memoryh scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-refactor-allowed-asm-includes-and-add-memoryh
+++ a/scripts/checkpatch.pl
@@ -224,6 +224,12 @@ our @modifierList = (
 	qr{fastcall},
 );
 
+our $allowed_asm_includes = qr{(?x:
+	irq|
+	memory
+)};
+# memory.h: ARM has a custom one
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -2308,7 +2314,7 @@ sub process {
 			my $checkfile = "include/linux/$file";
 			if (-f "$root/$checkfile" &&
 			    $realfile ne $checkfile &&
-			    $1 ne 'irq')
+			    $1 !~ /$allowed_asm_includes/)
 			{
 				if ($realfile =~ m{^arch/}) {
 					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
misc-rohm-bh1780gli-ambient-light-sensor-driver.patch
checkpatch-refactor-allowed-asm-includes-and-add-memoryh.patch

