From: akpm@linux-foundation.org
Subject: + checkpatch-add-test-for-consecutive-string-fragments.patch
 added to -mm tree
Date: Tue, 11 Nov 2014 16:22:34 -0800
Message-ID: <5462a84a.S+jLg4MMBa1uRWQ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaKLAWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 19:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for consecutive string fragments
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-consecutive-string-fragments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-consecutive-string-fragments.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-consecutive-string-fragments.patch

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
Subject: checkpatch: add test for consecutive string fragments

Emit a warning when single line string coalescing occurs.

Code that uses compiler string concatenation on a single line like:
	printk("foo" "bar");
is generally better to read concatenated like:
	printk("foobar");

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-consecutive-string-fragments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-consecutive-string-fragments
+++ a/scripts/checkpatch.pl
@@ -4464,6 +4464,12 @@ sub process {
 			    "Concatenated strings should use spaces between elements\n" . $herecurr);
 		}
 
+# uncoalesced string fragments
+		if ($line =~ /"X*"\s*"/) {
+			WARN("STRING_FRAGMENTS",
+			     "Consecutive strings are generally better as a single string\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",
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
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

