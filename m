From: akpm@linux-foundation.org
Subject: - checkpatch-allow-parentheses-on-return-for-comparisons.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:54 -0800
Message-ID: <200901072216.n07MGsZ1016602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762009AbZAGWQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: allow parentheses on return for comparisons
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-parentheses-on-return-for-comparisons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

