From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-strict-test-for-function-pointer-calling-style.patch added
 to -mm tree
Date: Wed, 05 Nov 2014 14:10:33 -0800
Message-ID: <545aa059.eaG+HbSL7fG8TUcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKEWKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 17:10:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, peter@hurleysoftware.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Add --strict test for function pointer calling style
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-function-pointer-calling-style.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-test-for-function-pointer-calling-style.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-test-for-function-pointer-calling-style.patch

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

printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
checkpatch-add-strict-test-for-function-pointer-calling-style.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

