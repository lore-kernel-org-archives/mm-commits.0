From: akpm@linux-foundation.org
Subject: + checkpatch-make-return-is-not-a-function-test-quieter.patch
 added to -mm tree
Date: Thu, 27 Feb 2014 14:23:01 -0800
Message-ID: <530fbac5.cY4N0WoRLPCbWEHy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB0WXC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 17:23:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, monamagarwal123@gmail.com, julia.lawall@lip6.fr, josh@joshtriplett.org, gregkh@linuxfoundation.org, joe@perches.com

Subject: + checkpatch-make-return-is-not-a-function-test-quieter.patch added to -mm tree
To: joe@perches.com,gregkh@linuxfoundation.org,josh@joshtriplett.org,julia.lawall@lip6.fr,monamagarwal123@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 14:23:01 -0800


The patch titled
     Subject: checkpatch: make "return is not a function" test quieter
has been added to the -mm tree.  Its filename is
     checkpatch-make-return-is-not-a-function-test-quieter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-return-is-not-a-function-test-quieter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-return-is-not-a-function-test-quieter.patch

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
Cc: Josh Triplett <josh@joshtriplett.org>
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
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

