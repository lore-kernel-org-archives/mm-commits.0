From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-pointer-comparison-to-null-test.patch
 added to -mm tree
Date: Thu, 13 Nov 2014 11:01:43 -0800
Message-ID: <54650017.lZ/Ezk5YYLuaNkyh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaKMTBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 14:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict "pointer comparison to NULL" test
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-pointer-comparison-to-null-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-pointer-comparison-to-null-test.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-pointer-comparison-to-null-test.patch

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
Subject: checkpatch: add --strict "pointer comparison to NULL" test

It seems there are more and more uses of "if (!ptr)" in preference to "if
(ptr == NULL)" so add a --strict test to emit a message when using the
latter form.

This also finds (ptr != NULL).

Fix it too if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-pointer-comparison-to-null-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-pointer-comparison-to-null-test
+++ a/scripts/checkpatch.pl
@@ -4522,6 +4522,20 @@ sub process {
 			     "Possible precedence defect with mask then right shift - may need parentheses\n" . $herecurr);
 		}
 
+# check for pointer comparisons to NULL
+		if ($^V && $^V ge 5.10.0) {
+			while ($line =~ /\b$LvalOrFunc\s*(==|\!=)\s*NULL\b/g) {
+				my $val = $1;
+				my $equal = "!";
+				$equal = "" if ($4 eq "!=");
+				if (CHK("COMPARISON_TO_NULL",
+					"Comparison to NULL could be written \"${equal}${val}\"\n" . $herecurr) &&
+					    $fix) {
+					$fixed[$fixlinenr] =~ s/\b\Q$val\E\s*(?:==|\!=)\s*NULL\b/$equal$val/;
+				}
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
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
checkpatch-allow-certain-si-units-with-three-characters.patch
checkpatch-add-strict-preference-for-defines-using-bitfoo.patch
checkpatch-add-test-for-consecutive-string-fragments.patch
checkpatch-add-strict-pointer-comparison-to-null-test.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

