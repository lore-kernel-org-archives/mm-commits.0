From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch added to -mm tree
Date: Fri, 11 Mar 2016 13:24:02 -0800
Message-ID: <56e33772.tadCpNBYYMI/2v8K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcCKVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2016 16:24:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve UNSPECIFIED_INT test for bare signed/unsigned uses
has been added to the -mm tree.  Its filename is
     checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch

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
checkpatch-exclude-asm-volatile-from-complex-macro-check.patch
checkpatch-warn-on-bare-unsigned-or-signed-declarations-without-int.patch
checkpatch-improve-unspecified_int-test-for-bare-signed-unsigned-uses.patch
kernel-convert-pr_warning-to-pr_warn.patch

