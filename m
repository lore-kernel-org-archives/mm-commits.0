From: akpm@linux-foundation.org
Subject: - random-fix-output-buffer-folding.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:29 -0700
Message-ID: <200706231927.l5NJRTIN022066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbXFWT1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, linux@horizon.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: fix output buffer folding
has been removed from the -mm tree.  Its filename was
     random-fix-output-buffer-folding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: random: fix output buffer folding
From: Matt Mackall <mpm@selenic.com>

(As reported by linux@horizon.com)

Folding is done to minimize the theoretical possibility of systematic
weakness in the particular bits of the SHA1 hash output.  The result of
this bug is that 16 out of 80 bits are un-folded.  Without a major new
vulnerability being found in SHA1, this is harmless, but still worth
fixing.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: <linux@horizon.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/random.c~random-fix-output-buffer-folding drivers/char/random.c
--- a/drivers/char/random.c~random-fix-output-buffer-folding
+++ a/drivers/char/random.c
@@ -794,7 +794,7 @@ static void extract_buf(struct entropy_s
 
 	buf[0] ^= buf[3];
 	buf[1] ^= buf[4];
-	buf[0] ^= rol32(buf[3], 16);
+	buf[2] ^= rol32(buf[2], 16);
 	memcpy(out, buf, EXTRACT_SIZE);
 	memset(buf, 0, sizeof(buf));
 }
_

Patches currently in -mm which might be from mpm@selenic.com are

slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
