From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-test-for-function-pointer-calling-style.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:35 -0800
Message-ID: <5489eaff.7kNYQeyFskZbSkqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaLKTFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add --strict test for function pointer calling style
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-function-pointer-calling-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Add --strict test for function pointer calling style

Peter Hurley wrote:

The use of older function ptr calling style, (*fn)(), makes static
analysis more error-prone; replace with modern fn() style.

So make checkpatch emit a --strict test for that condition.

Update the unnecessary parentheses test for dereferencing
objects at the same time and create a $fix mechanism too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-function-pointer-calling-style scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-function-pointer-calling-style
+++ a/scripts/checkpatch.pl
@@ -3844,9 +3844,27 @@ sub process {
 # ie: &(foo->bar) should be &foo->bar and *(foo->bar) should be *foo->bar
 
 		while ($line =~ /(?:[^&]&\s*|\*)\(\s*($Ident\s*(?:$Member\s*)+)\s*\)/g) {
-			CHK("UNNECESSARY_PARENTHESES",
-			    "Unnecessary parentheses around $1\n" . $herecurr);
-		    }
+			my $var = $1;
+			if (CHK("UNNECESSARY_PARENTHESES",
+				"Unnecessary parentheses around $var\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\(\s*\Q$var\E\s*\)/$var/;
+			}
+		}
+
+# check for unnecessary parentheses around function pointer uses
+# ie: (foo->bar)(); should be foo->bar();
+# but not "if (foo->bar) (" to avoid some false positives
+		if ($line =~ /(\bif\s*|)(\(\s*$Ident\s*(?:$Member\s*)+\))[ \t]*\(/ && $1 !~ /^if/) {
+			my $var = $2;
+			if (CHK("UNNECESSARY_PARENTHESES",
+				"Unnecessary parentheses around function pointer $var\n" . $herecurr) &&
+			    $fix) {
+				my $var2 = deparenthesize($var);
+				$var2 =~ s/\s//g;
+				$fixed[$fixlinenr] =~ s/\Q$var\E/$var2/;
+			}
+		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

