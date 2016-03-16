From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:32 -0700
Message-ID: <56e9baac.N4JIgLsc8V5W66ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve UNSPECIFIED_INT test for bare signed/unsigned uses
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve UNSPECIFIED_INT test for bare signed/unsigned uses

Improve the test to allow casts to (unsigned) or (signed) to be
found and fixed if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses
+++ a/scripts/checkpatch.pl
@@ -3240,10 +3240,11 @@ sub process {
 		next if ($line =~ /^[^\+]/);
 
 # check for declarations of signed or unsigned without int
-		while ($line =~ m{($Declare++)\s*($Ident)\s*[=,;\[\)]}g) {
+		while ($line =~ m{($Declare)\s*(?!char\b|short\b|int\b|long\b)\s*($Ident)?\s*[=,;\[\)\(]}g) {
 			my $type = $1;
 			my $var = $2;
-			if ($type =~ /^((?:un)?signed)((?:\s*\*)*)\s*$/) {
+			$var = "" if (!defined $var);
+			if ($type =~ /^(?:(?:$Storage|$Inline|$Attribute)\s+)*((?:un)?signed)((?:\s*\*)*)\s*$/) {
 				my $sign = $1;
 				my $pointer = $2;
 
@@ -3253,8 +3254,11 @@ sub process {
 					 "Prefer '" . trim($sign) . " int" . rtrim($pointer) . "' to bare use of '$sign" . rtrim($pointer) . "'\n" . $herecurr) &&
 				    $fix) {
 					my $decl = trim($sign) . " int ";
-					$decl .= trim($pointer) if (rtrim($pointer) ne "");
-					$fixed[$fixlinenr] =~ s@\b\Q$type\E\s*$var\b@$decl$var@;
+					my $comp_pointer = $pointer;
+					$comp_pointer =~ s/\s//g;
+					$decl .= $comp_pointer;
+					$decl = rtrim($decl) if ($var eq "");
+					$fixed[$fixlinenr] =~ s@\b$sign\s*\Q$pointer\E\s*$var\b@$decl$var@;
 				}
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

mm-convert-pr_warning-to-pr_warn.patch
mm-coalesce-split-strings.patch
mm-convert-printkkern_level-to-pr_level.patch
mm-percpu-use-pr_fmt-to-prefix-output.patch
kernel-convert-pr_warning-to-pr_warn.patch

