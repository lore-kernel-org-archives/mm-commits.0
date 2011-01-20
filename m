From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch removed from -mm tree
Date: Thu, 20 Jan 2011 14:40:11 -0800
Message-ID: <201101202240.p0KMeBHI006758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab1ATWkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 17:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch

This patch was dropped because it was folded into mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
From: Andrew Morton <akpm@linux-foundation.org>

add comment, per Mel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
+++ a/mm/compaction.c
@@ -453,6 +453,10 @@ unsigned long compaction_suitable(struct
 	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 		return COMPACT_SKIPPED;
 
+	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
 	if (order == -1)
 		return COMPACT_CONTINUE;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

