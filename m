From: akpm@linux-foundation.org
Subject: + checkpatch-try-to-avoid-mask-and-shift-errors.patch added to
 -mm tree
Date: Mon, 27 Oct 2014 15:50:13 -0700
Message-ID: <544ecc25.KUbtA/22zRcs3Zml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaJ0WuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 18:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: try to avoid mask and shift errors
has been added to the -mm tree.  Its filename is
     checkpatch-try-to-avoid-mask-and-shift-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-try-to-avoid-mask-and-shift-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-try-to-avoid-mask-and-shift-errors.patch

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
Subject: checkpatch: try to avoid mask and shift errors

Shift has a higher precedence that mask so warn when a mask then shift
operation is done without parentheses around the mask.

This test works well for a right shift, but the left shift is pretty
commonly done correctly so only warn on the right shift.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-try-to-avoid-mask-and-shift-errors scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-try-to-avoid-mask-and-shift-errors
+++ a/scripts/checkpatch.pl
@@ -4482,6 +4482,14 @@ sub process {
 			}
 		}
 
+# check for mask then right shift without a parentheses
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /$LvalOrFunc\s*\&\s*($LvalOrFunc)\s*>>/ &&
+		    $4 !~ /^\&/) { # $LvalOrFunc may be &foo, ignore if so
+			WARN("MASK_THEN_SHIFT",
+			     "Possible precedence defect with mask then right shift - may need parentheses\n" . $herecurr);
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

