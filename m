From: akpm@linux-foundation.org
Subject: [merged] page-typesc-support-kpf_softdirty-bit.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:48 -0800
Message-ID: <5283e358.DOWAHtrfK1kDgcYG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3KMUit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, gorcunov@openvz.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] page-typesc-support-kpf_softdirty-bit.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,gorcunov@openvz.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:48 -0800


The patch titled
     Subject: tools/vm/page-types.c: support KPF_SOFTDIRTY bit
has been removed from the -mm tree.  Its filename was
     page-typesc-support-kpf_softdirty-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: tools/vm/page-types.c: support KPF_SOFTDIRTY bit

Soft dirty bit allows us to track which pages are written since the last
clear_ref (by "echo 4 > /proc/pid/clear_refs".) This is useful for
userspace applications to know their memory footprints.

Note that the kernel exposes this flag via bit[55] of /proc/pid/pagemap,
and the semantics is not a default one (scheduled to be the default in the
near future.) However, it shifts to the new semantics at the first
clear_ref, and the users of soft dirty bit always do it before utilizing
the bit, so that's not a big deal.  Users must avoid relying on the bit in
page-types before the first clear_ref.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel-page-flags.h |    1 
 tools/vm/page-types.c             |   32 +++++++++++++++++-----------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff -puN include/linux/kernel-page-flags.h~page-typesc-support-kpf_softdirty-bit include/linux/kernel-page-flags.h
--- a/include/linux/kernel-page-flags.h~page-typesc-support-kpf_softdirty-bit
+++ a/include/linux/kernel-page-flags.h
@@ -15,5 +15,6 @@
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
+#define KPF_SOFTDIRTY		40
 
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff -puN tools/vm/page-types.c~page-typesc-support-kpf_softdirty-bit tools/vm/page-types.c
--- a/tools/vm/page-types.c~page-typesc-support-kpf_softdirty-bit
+++ a/tools/vm/page-types.c
@@ -59,12 +59,14 @@
 #define PM_PSHIFT_BITS      6
 #define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
 #define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
-#define PM_PSHIFT(x)        (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
+#define __PM_PSHIFT(x)      (((uint64_t) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
 #define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
 #define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
 
+#define __PM_SOFT_DIRTY      (1LL)
 #define PM_PRESENT          PM_STATUS(4LL)
 #define PM_SWAP             PM_STATUS(2LL)
+#define PM_SOFT_DIRTY       __PM_PSHIFT(__PM_SOFT_DIRTY)
 
 
 /*
@@ -83,6 +85,7 @@
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
+#define KPF_SOFTDIRTY		40
 
 /* [48-] take some arbitrary free slots for expanding overloaded flags
  * not part of kernel API
@@ -132,6 +135,7 @@ static const char * const page_flag_name
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
 	[KPF_ARCH]		= "h:arch",
 	[KPF_UNCACHED]		= "c:uncached",
+	[KPF_SOFTDIRTY]		= "f:softdirty",
 
 	[KPF_READAHEAD]		= "I:readahead",
 	[KPF_SLOB_FREE]		= "P:slob_free",
@@ -417,7 +421,7 @@ static int bit_mask_ok(uint64_t flags)
 	return 1;
 }
 
-static uint64_t expand_overloaded_flags(uint64_t flags)
+static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
 {
 	/* SLOB/SLUB overload several page flags */
 	if (flags & BIT(SLAB)) {
@@ -433,6 +437,9 @@ static uint64_t expand_overloaded_flags(
 	if ((flags & (BIT(RECLAIM) | BIT(WRITEBACK))) == BIT(RECLAIM))
 		flags ^= BIT(RECLAIM) | BIT(READAHEAD);
 
+	if (pme & PM_SOFT_DIRTY)
+		flags |= BIT(SOFTDIRTY);
+
 	return flags;
 }
 
@@ -448,11 +455,11 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
-static uint64_t kpageflags_flags(uint64_t flags)
+static uint64_t kpageflags_flags(uint64_t flags, uint64_t pme)
 {
-	flags = expand_overloaded_flags(flags);
-
-	if (!opt_raw)
+	if (opt_raw)
+		flags = expand_overloaded_flags(flags, pme);
+	else
 		flags = well_known_flags(flags);
 
 	return flags;
@@ -545,9 +552,9 @@ static size_t hash_slot(uint64_t flags)
 }
 
 static void add_page(unsigned long voffset,
-		     unsigned long offset, uint64_t flags)
+		     unsigned long offset, uint64_t flags, uint64_t pme)
 {
-	flags = kpageflags_flags(flags);
+	flags = kpageflags_flags(flags, pme);
 
 	if (!bit_mask_ok(flags))
 		return;
@@ -569,7 +576,8 @@ static void add_page(unsigned long voffs
 #define KPAGEFLAGS_BATCH	(64 << 10)	/* 64k pages */
 static void walk_pfn(unsigned long voffset,
 		     unsigned long index,
-		     unsigned long count)
+		     unsigned long count,
+		     uint64_t pme)
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
@@ -583,7 +591,7 @@ static void walk_pfn(unsigned long voffs
 			break;
 
 		for (i = 0; i < pages; i++)
-			add_page(voffset + i, index + i, buf[i]);
+			add_page(voffset + i, index + i, buf[i], pme);
 
 		index += pages;
 		count -= pages;
@@ -608,7 +616,7 @@ static void walk_vma(unsigned long index
 		for (i = 0; i < pages; i++) {
 			pfn = pagemap_pfn(buf[i]);
 			if (pfn)
-				walk_pfn(index + i, pfn, 1);
+				walk_pfn(index + i, pfn, 1, buf[i]);
 		}
 
 		index += pages;
@@ -659,7 +667,7 @@ static void walk_addr_ranges(void)
 
 	for (i = 0; i < nr_addr_ranges; i++)
 		if (!opt_pid)
-			walk_pfn(0, opt_offset[i], opt_size[i]);
+			walk_pfn(0, opt_offset[i], opt_size[i], 0);
 		else
 			walk_task(opt_offset[i], opt_size[i]);
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

