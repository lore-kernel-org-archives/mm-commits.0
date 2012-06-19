From: akpm@linux-foundation.org
Subject: + mm-memblockc-memblock_double_array-cosmetic-cleanups.patch added to -mm tree
Date: Tue, 19 Jun 2012 15:18:19 -0700
Message-ID: <20120619221819.A72DEA021F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39080 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2FSWSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 18:18:21 -0400
Received: by qabg24 with SMTP id g24so292633qab.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 15:18:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, greg.pearson@hp.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm/memblock.c:memblock_double_array(): cosmetic cleanups
has been added to the -mm tree.  Its filename is
     mm-memblockc-memblock_double_array-cosmetic-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memblock.c:memblock_double_array(): cosmetic cleanups

This function is an 80-column eyesore, quite unnecessarily.  Clean that
up, and use standard comment layout style.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Pearson <greg.pearson@hp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/memblock.c~mm-memblockc-memblock_double_array-cosmetic-cleanups mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-memblock_double_array-cosmetic-cleanups
+++ a/mm/memblock.c
@@ -227,13 +227,13 @@ static int __init_memblock memblock_doub
 	/* Try to find some space for it.
 	 *
 	 * WARNING: We assume that either slab_is_available() and we use it or
-	 * we use MEMBLOCK for allocations. That means that this is unsafe to use
-	 * when bootmem is currently active (unless bootmem itself is implemented
-	 * on top of MEMBLOCK which isn't the case yet)
+	 * we use MEMBLOCK for allocations. That means that this is unsafe to
+	 * use when bootmem is currently active (unless bootmem itself is
+	 * implemented on top of MEMBLOCK which isn't the case yet)
 	 *
 	 * This should however not be an issue for now, as we currently only
-	 * call into MEMBLOCK while it's still active, or much later when slab is
-	 * active for memory hotplug operations
+	 * call into MEMBLOCK while it's still active, or much later when slab
+	 * is active for memory hotplug operations
 	 */
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
@@ -248,8 +248,8 @@ static int __init_memblock memblock_doub
 						new_size, sizeof(phys_addr_t));
 		if (!addr && new_area_size)
 			addr = memblock_find_in_range(0,
-					min(new_area_start, memblock.current_limit),
-					new_size, sizeof(phys_addr_t));
+				    min(new_area_start, memblock.current_limit),
+				    new_size, sizeof(phys_addr_t));
 
 		new_array = addr ? __va(addr) : 0;
 	}
@@ -259,12 +259,14 @@ static int __init_memblock memblock_doub
 		return -1;
 	}
 
-	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
-		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);
+	memblock_dbg("memblock: %s is doubled to %ld at [%#010llx-%#010llx]",
+			memblock_type_name(type), type->max * 2, (u64)addr,
+			(u64)addr + new_size - 1);
 
-	/* Found space, we now need to move the array over before
-	 * we add the reserved region since it may be our reserved
-	 * array itself that is full.
+	/*
+	 * Found space, we now need to move the array over before we add the
+	 * reserved region since it may be our reserved array itself that is
+	 * full.
 	 */
 	memcpy(new_array, type->regions, old_size);
 	memset(new_array + type->max, 0, old_size);
@@ -272,17 +274,16 @@ static int __init_memblock memblock_doub
 	type->regions = new_array;
 	type->max <<= 1;
 
-	/* Free old array. We needn't free it if the array is the
-	 * static one
-	 */
+	/* Free old array. We needn't free it if the array is the static one */
 	if (*in_slab)
 		kfree(old_array);
 	else if (old_array != memblock_memory_init_regions &&
 		 old_array != memblock_reserved_init_regions)
 		memblock_free(__pa(old_array), old_size);
 
-	/* Reserve the new array if that comes from the memblock.
-	 * Otherwise, we needn't do it
+	/*
+	 * Reserve the new array if that comes from the memblock.  Otherwise, we
+	 * needn't do it
 	 */
 	if (!use_slab)
 		BUG_ON(memblock_reserve(addr, new_size));
_
Subject: Subject: mm/memblock.c:memblock_double_array(): cosmetic cleanups

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-power-power_supply_corec-partially-fix.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

