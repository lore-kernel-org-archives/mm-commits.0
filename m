From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-make-return-is-not-a-function-test-quieter.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:34:10 -0700
Message-ID: <533f0932.TyKxwnWD95gXynpO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaDDTeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, monamagarwal123@gmail.com, julia.lawall@lip6.fr, josh@joshtriplett.org, gregkh@linuxfoundation.org, joe@perches.com

Subject: [merged] checkpatch-make-return-is-not-a-function-test-quieter.patch removed from -mm tree
To: joe@perches.com,gregkh@linuxfoundation.org,josh@joshtriplett.org,julia.lawall@lip6.fr,monamagarwal123@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:10 -0700


The patch titled
     Subject: checkpatch: make "return is not a function" test quieter
has been removed from the -mm tree.  Its filename was
     checkpatch-make-return-is-not-a-function-test-quieter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: make "return is not a function" test quieter

This test is a bit noisy and opinions seem to agree that it should not
warn in a lot more situations.

It seems people agree that:

	return (foo || bar);
and
	return foo || bar;

are both acceptable style and checkpatch should be silent about them.

For now, it warns on parentheses around a simple constant or a single
function or a ternary.

	return (foo);
	return (foo(bar));
	return (foo ? bar : baz);

The last ternary test may be quieted in the future.

Modify the deparenthesize function to only strip balanced leading and
trailing parentheses.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Monam Agarwal <monamagarwal123@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-return-is-not-a-function-test-quieter scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-return-is-not-a-function-test-quieter
+++ a/scripts/checkpatch.pl
@@ -439,9 +439,14 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOr
 sub deparenthesize {
 	my ($string) = @_;
 	return "" if (!defined($string));
-	$string =~ s@^\s*\(\s*@@g;
-	$string =~ s@\s*\)\s*$@@g;
+
+	while ($string =~ /^\s*\(.*\)\s*$/) {
+		$string =~ s@^\s*\(\s*@@;
+		$string =~ s@\s*\)\s*$@@;
+	}
+
 	$string =~ s@\s+@ @g;
+
 	return $string;
 }
 
@@ -3374,14 +3379,17 @@ sub process {
 			}
 		}
 
-# Return is not a function.
+# return is not a function
 		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
 			my $spacing = $1;
 			if ($^V && $^V ge 5.10.0 &&
-			    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/) {
-				ERROR("RETURN_PARENTHESES",
-				      "return is not a function, parentheses are not required\n" . $herecurr);
-
+			    $stat =~ /^.\s*return\s*($balanced_parens)\s*;\s*$/) {
+				my $value = $1;
+				$value = deparenthesize($value);
+				if ($value =~ m/^\s*$FuncArg\s*(?:\?|$)/) {
+					ERROR("RETURN_PARENTHESES",
+					      "return is not a function, parentheses are not required\n" . $herecurr);
+				}
 			} elsif ($spacing !~ /\s+/) {
 				ERROR("SPACING",
 				      "space required before the open parenthesis '('\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ntfs-logging-clean-up.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

