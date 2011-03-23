From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:29:01 -0700
Message-ID: <201103232032.p2NKWcCK027897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933145Ab1CWUcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:32:39 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p2NKWcxe010139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2011 13:32:38 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/truncate.c~linux-next-rejects mm/truncate.c
--- a/mm/truncate.c~linux-next-rejects
+++ a/mm/truncate.c
@@ -109,6 +109,10 @@ truncate_complete_page(struct address_sp
 
 	clear_page_mlock(page);
 	ClearPageMappedToDisk(page);
+	/* this must be after the remove_from_page_cache which
+	 * calls cleancache_put_page (and note page->mapping is now NULL)
+	 */
+	cleancache_flush_page(mapping, page);
 	delete_from_page_cache(page);
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
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
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

