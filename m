From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 23 Mar 2011 13:30:17 -0700
Message-ID: <201103232033.p2NKXrUj028029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932961Ab1CWUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:34:26 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p2NKXrXV010246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2011 13:33:53 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    3 ---
 drivers/platform/x86/sony-laptop.c |    5 -----
 mm/truncate.c                      |    6 +-----
 3 files changed, 1 insertion(+), 13 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -5642,8 +5642,6 @@ M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
-<<<<<<< HEAD
-=======
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
@@ -5661,7 +5659,6 @@ S:	Maintained
 F:	include/linux/shm_signal.h
 F:	lib/shm_signal.c
 
->>>>>>> FETCH_HEAD
 SIMPLE FIRMWARE INTERFACE (SFI)
 M:	Len Brown <lenb@kernel.org>
 L:	sfi-devel@simplefirmware.org
diff -puN drivers/platform/x86/sony-laptop.c~linux-next-git-rejects drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/sony-laptop.c
@@ -1621,7 +1621,6 @@ static int sony_nc_add(struct acpi_devic
 	if (acpi_video_backlight_support()) {
 		pr_info(DRV_PFX "brightness ignored, must be "
 		       "controlled by ACPI video driver\n");
-<<<<<<< HEAD
 	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",
 						&handle))) {
 		struct backlight_properties props;
@@ -1647,10 +1646,6 @@ static int sony_nc_add(struct acpi_devic
 	result = sony_pf_add();
 	if (result)
 		goto outbacklight;
-=======
-	} else
-		sony_nc_backlight_setup();
->>>>>>> FETCH_HEAD
 
 	/* create sony_pf sysfs attributes related to the SNC device */
 	for (item = sony_nc_values; item->name; ++item) {
diff -puN mm/truncate.c~linux-next-git-rejects mm/truncate.c
--- a/mm/truncate.c~linux-next-git-rejects
+++ a/mm/truncate.c
@@ -109,15 +109,11 @@ truncate_complete_page(struct address_sp
 
 	clear_page_mlock(page);
 	ClearPageMappedToDisk(page);
-<<<<<<< HEAD
-	delete_from_page_cache(page);
-=======
 	/* this must be after the remove_from_page_cache which
 	 * calls cleancache_put_page (and note page->mapping is now NULL)
 	 */
 	cleancache_flush_page(mapping, page);
-	page_cache_release(page);	/* pagecache ref */
->>>>>>> FETCH_HEAD
+	delete_from_page_cache(page);
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
linux-next-git-rejects.patch

