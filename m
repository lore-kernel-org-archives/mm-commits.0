From: akpm@linux-foundation.org
Subject: [merged]
 x86-mirror-x86-enabling-find-mirrored-memory-ranges.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:39:08 -0700
Message-ID: <5591acec.rRlbpMU3lggj19IU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbbF2UjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, guohanjun@huawei.com, hpa@zytor.com, mingo@elte.hu, nao.horiguchi@gmail.com, qiuxishi@huawei.com, tglx@linutronix.de, xiexiuqi@huawei.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mirror: x86 enabling - find mirrored memory ranges
has been removed from the -mm tree.  Its filename was
     x86-mirror-x86-enabling-find-mirrored-memory-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: x86, mirror: x86 enabling - find mirrored memory ranges

UEFI GetMemoryMap() uses a new attribute bit to mark mirrored memory
address ranges.  See UEFI 2.5 spec pages 157-158:

  http://www.uefi.org/sites/default/files/resources/UEFI%202_5.pdf

On EFI enabled systems scan the memory map and tell memblock about any
mirrored ranges.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Xiexiuqi <xiexiuqi@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c     |    3 +++
 arch/x86/platform/efi/efi.c |   21 +++++++++++++++++++++
 include/linux/efi.h         |    3 +++
 3 files changed, 27 insertions(+)

diff -puN arch/x86/kernel/setup.c~x86-mirror-x86-enabling-find-mirrored-memory-ranges arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-mirror-x86-enabling-find-mirrored-memory-ranges
+++ a/arch/x86/kernel/setup.c
@@ -1105,6 +1105,9 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_find_mirror();
+
 	/*
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
diff -puN arch/x86/platform/efi/efi.c~x86-mirror-x86-enabling-find-mirrored-memory-ranges arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-mirror-x86-enabling-find-mirrored-memory-ranges
+++ a/arch/x86/platform/efi/efi.c
@@ -117,6 +117,27 @@ void efi_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
+void __init efi_find_mirror(void)
+{
+	void *p;
+	u64 mirror_size = 0, total_size = 0;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+
+		total_size += size;
+		if (md->attribute & EFI_MEMORY_MORE_RELIABLE) {
+			memblock_mark_mirror(start, size);
+			mirror_size += size;
+		}
+	}
+	if (mirror_size)
+		pr_info("Memory: %lldM/%lldM mirrored memory\n",
+			mirror_size>>20, total_size>>20);
+}
+
 /*
  * Tell the kernel about the EFI memory map.  This might include
  * more than the max 128 entries that can fit in the e820 legacy
diff -puN include/linux/efi.h~x86-mirror-x86-enabling-find-mirrored-memory-ranges include/linux/efi.h
--- a/include/linux/efi.h~x86-mirror-x86-enabling-find-mirrored-memory-ranges
+++ a/include/linux/efi.h
@@ -96,6 +96,8 @@ typedef	struct {
 #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
 #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
 #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
+#define EFI_MEMORY_MORE_RELIABLE \
+				((u64)0x0000000000010000ULL)	/* higher reliability */
 #define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
 #define EFI_MEMORY_DESCRIPTOR_VERSION	1
 
@@ -868,6 +870,7 @@ extern void efi_enter_virtual_mode (void
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
 extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
+extern void efi_find_mirror(void);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
_

Patches currently in -mm which might be from tony.luck@intel.com are

origin.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
linux-next.patch

