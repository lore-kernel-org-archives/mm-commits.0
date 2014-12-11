From: akpm@linux-foundation.org
Subject: [merged] checkpatch-try-to-avoid-mask-and-shift-errors.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:33 -0800
Message-ID: <5489eafd.VcEXSjCsTg/xyM17%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaLKTFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: try to avoid mask and shift errors
has been removed from the -mm tree.  Its filename was
     checkpatch-try-to-avoid-mask-and-shift-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

