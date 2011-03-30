From: akpm@linux-foundation.org
Subject: + fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch added to -mm tree
Date: Wed, 30 Mar 2011 12:49:28 -0700
Message-ID: <201103301949.p2UJnTR9003891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300Ab1C3TuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 15:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Warns@pre-sense.de, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, warns@pre-sense.de


The patch titled
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#29: FILE: fs/partitions/ldm.c:1303:
+		ldm_error ("Value of size is to small.");

WARNING: space prohibited between function name and open parenthesis '('
#41: FILE: fs/partitions/ldm.c:1315:
+		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, num);

total: 0 errors, 2 warnings, 34 lines checked

./patches/fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Cc: Timo Warns <Warns@pre-sense.de>
Cc: Timo Warns <warns@pre-sense.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes
+++ a/fs/partitions/ldm.c
@@ -1299,8 +1299,8 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
-	if (size < 2*VBLK_SIZE_HEAD) {
-		ldm_error ("Value of size is to small.");
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
 		return false;
 	}
 
@@ -1312,7 +1312,7 @@ static bool ldm_frag_add (const u8 *data
 		return false;
 	}
 	if (rec >= num) {
-		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, num);
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
 		return false;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

