From: akpm@linux-foundation.org
Subject: + remove-unused-arguments-in-zone_init_free_lists.patch added to -mm tree
Date: Wed, 12 Dec 2007 01:51:56 -0800
Message-ID: <200712120951.lBC9pu5b003823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbXLLJwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 04:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de


The patch titled
     page allcoator: remove unused arguments in zone_init_free_lists()
has been added to the -mm tree.  Its filename is
     remove-unused-arguments-in-zone_init_free_lists.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: page allcoator: remove unused arguments in zone_init_free_lists()
From: Andi Kleen <ak@suse.de>

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~remove-unused-arguments-in-zone_init_free_lists mm/page_alloc.c
--- a/mm/page_alloc.c~remove-unused-arguments-in-zone_init_free_lists
+++ a/mm/page_alloc.c
@@ -2535,8 +2535,7 @@ void __meminit memmap_init_zone(unsigned
 	}
 }
 
-static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long size)
+static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	int order, t;
 	for_each_migratetype_order(order, t) {
@@ -2809,7 +2808,7 @@ __meminit int init_currently_empty_zone(
 
 	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
 
-	zone_init_free_lists(pgdat, zone, zone->spanned_pages);
+	zone_init_free_lists(zone);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ak@suse.de are

revert-hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
acpi-add-reboot-mechanism.patch
updates-to-nfsroot-documentation-take-3.patch
serial-keep-the-dtr-setting-for-serial-console.patch
pci-disable-decoding-during-sizing-of-bars.patch
git-x86.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-calling-convention-fix.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
x86-boot-use-e820-memory-map-on-efi-32-platform.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
