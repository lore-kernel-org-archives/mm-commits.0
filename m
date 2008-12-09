From: akpm@linux-foundation.org
Subject: + checkpatch-allow-parentheses-on-return-for-comparisons.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:32 -0800
Message-ID: <200812090004.mB904WlE031126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYLIAFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, kay.sievers@vrfy.org


The patch titled
     checkpatch: allow parentheses on return for comparisons
has been added to the -mm tree.  Its filename is
     checkpatch-allow-parentheses-on-return-for-comparisons.patch

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
Subject: checkpatch: allow parentheses on return for comparisons
From: Andy Whitcroft <apw@canonical.com>

It seems to be a common idiom to include braces on conditionals in all
contexts including return.  Allow this exception to the return is not a
function checks.  Reported by Kay Sievers.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-parentheses-on-return-for-comparisons scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-parentheses-on-return-for-comparisons
+++ a/scripts/checkpatch.pl
@@ -127,6 +127,7 @@ our $Lval	= qr{$Ident(?:$Member)*};
 
 our $Constant	= qr{(?:[0-9]+|0x[0-9a-fA-F]+)[UL]*};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
 			<=|>=|==|!=|
 			=>|->|<<|>>|<|>|!|~|
@@ -1983,9 +1984,9 @@ sub process {
 			my $spacing = $1;
 			my $value = $2;
 
-			# Flatten any parentheses and braces
+			# Flatten any parentheses
 			$value =~ s/\)\(/\) \(/g;
-			while ($value =~ s/\([^\(\)]*\)/1/) {
+			while ($value !~ /(?:$Ident|-?$Constant)\s*$Compare\s*(?:$Ident|-?$Constant)/ && $value =~ s/\([^\(\)]*\)/1/) {
 			}
 
 			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
checkpatch-update-copyrights.patch
checkpatch-add-warning-for-p0-patches.patch
checkpatch-allow-parentheses-on-return-for-comparisons.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch
checkpatch-loosen-spacing-on-typedef-function-checks.patch
checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch
checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch
checkpatch-do-not-report-nr_static-as-a-static-declaration.patch
checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
checkpatch-fix-the-perlcritic-errors.patch
checkpatch-version-026.patch

