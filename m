From: akpm@linux-foundation.org
Subject: - i386-map-enough-initial-memory-to-create-lowmem-mappings.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:16 -0700
Message-ID: <200704252040.l3PKeGXH012400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993153AbXDYUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, ebiederm@xmission.com, hpa@zytor.com, jeremy@xensource.com, torvalds@linux-foundation.org, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: map enough initial memory to create lowmem mappings
has been removed from the -mm tree.  Its filename was
     i386-map-enough-initial-memory-to-create-lowmem-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: map enough initial memory to create lowmem mappings
From: Jeremy Fitzhardinge <jeremy@goop.org>

head.S creates the very initial pagetable for the kernel.  This just maps
enough space for the kernel itself, and an allocation bitmap.  The amount
of mapped memory is rounded up to 4Mbytes, and so this typically ends up
mapping 8Mbytes of memory.

When booting, pagetable_init() needs to create mappings for all lowmem, and
the pagetables for these mappings are allocated from the free pages around
the kernel in low memory.  If the number of pagetable pages + kernel size
exceeds head.S's initial mapping, it will end up faulting on an unmapped
page.  This will only happen with specific combinations of kernel size and
memory size.

This patch makes sure that head.S also maps enough space to fit the kernel
pagetables as well as the kernel itself.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |    5 +++++
 arch/i386/kernel/head.S        |   23 +++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/asm-offsets.c~i386-map-enough-initial-memory-to-create-lowmem-mappings arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~i386-map-enough-initial-memory-to-create-lowmem-mappings
+++ a/arch/i386/kernel/asm-offsets.c
@@ -97,6 +97,11 @@ void foo(void)
 		 sizeof(struct tss_struct));
 
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
+	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
+	DEFINE(PTRS_PER_PTE, PTRS_PER_PTE);
+	DEFINE(PTRS_PER_PMD, PTRS_PER_PMD);
+	DEFINE(PTRS_PER_PGD, PTRS_PER_PGD);
+
 	DEFINE(VDSO_PRELINK_asm, VDSO_PRELINK);
 
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff -puN arch/i386/kernel/head.S~i386-map-enough-initial-memory-to-create-lowmem-mappings arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-map-enough-initial-memory-to-create-lowmem-mappings
+++ a/arch/i386/kernel/head.S
@@ -34,17 +34,32 @@
 
 /*
  * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.  We need one bit for
- * each possible page, but only in low memory, which means
- * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ * and including _end* we need mapped initially.
+ * We need:
+ *  - one bit for each possible page, but only in low memory, which means
+ *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ *  - enough space to map all low memory, which means
+ *     (2^32/4096) / 1024 pages (worst case, non PAE)
+ *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
+ *  - a few pages for allocator use before the kernel pagetable has
+ *     been set up
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
  */
-#define INIT_MAP_BEYOND_END	(128*1024)
+LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
 
+#if PTRS_PER_PMD > 1
+PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
+#else
+PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
+#endif
+BOOTBITMAP_SIZE = LOW_PAGES / 8
+ALLOCATOR_SLOP = 4
+
+INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
 
 /*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
_

Patches currently in -mm which might be from jeremy@goop.org are

add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
