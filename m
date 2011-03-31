From: akpm@linux-foundation.org
Subject: [folded] ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch removed from -mm tree
Date: Thu, 31 Mar 2011 11:16:45 -0700
Message-ID: <201103311815.p2VIFeV8019913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758903Ab1CaSPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix
has been removed from the -mm tree.  Its filename was
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch

This patch was dropped because it was folded into ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix mm/ksm.c
--- a/mm/ksm.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix
+++ a/mm/ksm.c
@@ -891,10 +891,14 @@ static int try_to_merge_one_page(struct 
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
 #ifdef CONFIG_KSM
-			if (page_mapcount(page))
-				add_zone_page_state(page_zone(page),
-						    NR_KSM_PAGES_SHARING,
-						    mapcount);
+			{
+				int mapcount = page_mapcount(page);
+
+				if (mapcount)
+					add_zone_page_state(page_zone(page),
+							NR_KSM_PAGES_SHARING,
+							mapcount);
+			}
 #endif
 			err = 0;
 		} else if (pages_identical(page, kpage))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
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

