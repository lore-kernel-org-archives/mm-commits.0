From: akpm@linux-foundation.org
Subject: +
 pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 11:57:59 -0700
Message-ID: <55a55bb7.EnIcVHsPWwrcTXEe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbGNS6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 14:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: add mmap-exclusive bit for marking pages mapped only here
has been added to the -mm tree.  Its filename is
     pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: add mmap-exclusive bit for marking pages mapped only here

This patch sets bit 56 in pagemap if this page is mapped only once.  It
allows to detect exclusively used pages without exposing PFN:

present file exclusive state
0       0    0         non-present
1       1    0         file page mapped somewhere else
1       1    1         file page mapped only here
1       0    0         anon non-CoWed page (shared with parent/child)
1       0    1         anon CoWed page (or never forked)

CoWed pages in (MAP_FILE | MAP_PRIVATE) areas are anon in this context.

MMap-exclusive bit doesn't reflect potential page-sharing via swapcache:
page could be mapped once but has several swap-ptes which point to it. 
Application could detect that by swap bit in pagemap entry and touch that
pte via /proc/pid/mem to get real information.

See http://lkml.kernel.org/r/CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com

Requested by Mark Williamson.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    3 ++-
 fs/proc/task_mmu.c           |   14 +++++++++++++-
 tools/vm/page-types.c        |   10 ++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here
+++ a/Documentation/vm/pagemap.txt
@@ -16,7 +16,8 @@ There are three components to pagemap:
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
-    * Bits 56-60 zero
+    * Bit  56    page exlusively mapped
+    * Bits 57-60 zero
     * Bit  61    page is file-page or shared-anon
     * Bit  62    page swapped
     * Bit  63    page present
diff -puN fs/proc/task_mmu.c~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here
+++ a/fs/proc/task_mmu.c
@@ -950,6 +950,7 @@ struct pagemapread {
 #define PM_PFRAME_BITS		55
 #define PM_PFRAME_MASK		GENMASK_ULL(PM_PFRAME_BITS - 1, 0)
 #define PM_SOFT_DIRTY		BIT_ULL(55)
+#define PM_MMAP_EXCLUSIVE	BIT_ULL(56)
 #define PM_FILE			BIT_ULL(61)
 #define PM_SWAP			BIT_ULL(62)
 #define PM_PRESENT		BIT_ULL(63)
@@ -1037,6 +1038,8 @@ static pagemap_entry_t pte_to_pagemap_en
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
+	if (page && page_mapcount(page) == 1)
+		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
@@ -1067,6 +1070,11 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		 * This if-check is just to prepare for future implementation.
 		 */
 		if (pmd_present(pmd)) {
+			struct page *page = pmd_page(pmd);
+
+			if (page_mapcount(page) == 1)
+				flags |= PM_MMAP_EXCLUSIVE;
+
 			flags |= PM_PRESENT;
 			if (pm->show_pfn)
 				frame = pmd_pfn(pmd) +
@@ -1132,6 +1140,9 @@ static int pagemap_hugetlb_range(pte_t *
 		if (!PageAnon(page))
 			flags |= PM_FILE;
 
+		if (page_mapcount(page) == 1)
+			flags |= PM_MMAP_EXCLUSIVE;
+
 		flags |= PM_PRESENT;
 		if (pm->show_pfn)
 			frame = pte_pfn(pte) +
@@ -1164,7 +1175,8 @@ static int pagemap_hugetlb_range(pte_t *
  * Bits 0-4   swap type if swapped
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
- * Bits 56-60 zero
+ * Bit  56    page exclusively mapped
+ * Bits 57-60 zero
  * Bit  61    page is file-page or shared-anon
  * Bit  62    page swapped
  * Bit  63    page present
diff -puN tools/vm/page-types.c~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here tools/vm/page-types.c
--- a/tools/vm/page-types.c~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here
+++ a/tools/vm/page-types.c
@@ -62,6 +62,7 @@
 #define PM_PFRAME_MASK		((1LL << PM_PFRAME_BITS) - 1)
 #define PM_PFRAME(x)		((x) & PM_PFRAME_MASK)
 #define PM_SOFT_DIRTY		(1ULL << 55)
+#define PM_MMAP_EXCLUSIVE	(1ULL << 56)
 #define PM_FILE			(1ULL << 61)
 #define PM_SWAP			(1ULL << 62)
 #define PM_PRESENT		(1ULL << 63)
@@ -91,6 +92,8 @@
 #define KPF_SLOB_FREE		49
 #define KPF_SLUB_FROZEN		50
 #define KPF_SLUB_DEBUG		51
+#define KPF_FILE		62
+#define KPF_MMAP_EXCLUSIVE	63
 
 #define KPF_ALL_BITS		((uint64_t)~0ULL)
 #define KPF_HACKERS_BITS	(0xffffULL << 32)
@@ -140,6 +143,9 @@ static const char * const page_flag_name
 	[KPF_SLOB_FREE]		= "P:slob_free",
 	[KPF_SLUB_FROZEN]	= "A:slub_frozen",
 	[KPF_SLUB_DEBUG]	= "E:slub_debug",
+
+	[KPF_FILE]		= "F:file",
+	[KPF_MMAP_EXCLUSIVE]	= "1:mmap_exclusive",
 };
 
 
@@ -443,6 +449,10 @@ static uint64_t expand_overloaded_flags(
 
 	if (pme & PM_SOFT_DIRTY)
 		flags |= BIT(SOFTDIRTY);
+	if (pme & PM_FILE)
+		flags |= BIT(FILE);
+	if (pme & PM_MMAP_EXCLUSIVE)
+		flags |= BIT(MMAP_EXCLUSIVE);
 
 	return flags;
 }
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch

