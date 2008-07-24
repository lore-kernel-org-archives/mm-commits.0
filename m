From: akpm@linux-foundation.org
Subject: - hugetlb-override-default-huge-page-size.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:26 -0700
Message-ID: <200807242323.m6ONNQg0010668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYGXXXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     hugetlb: override default huge page size
has been removed from the -mm tree.  Its filename was
     hugetlb-override-default-huge-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: override default huge page size
From: Nick Piggin <npiggin@suse.de>

Allow configurations with the default huge page size which is different to
the traditional HPAGE_SIZE size.  The default huge page size is the one
represented in the legacy /proc ABIs, SHM, and which is defaulted to when
mounting hugetlbfs filesystems.

This is implemented with a new kernel option default_hugepagesz=, which
defaults to HPAGE_SIZE if not specified.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 mm/hugetlb.c                        |   25 ++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~hugetlb-override-default-huge-page-size Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~hugetlb-override-default-huge-page-size
+++ a/Documentation/kernel-parameters.txt
@@ -783,6 +783,13 @@ and is between 256 and 4096 characters. 
 			CPU supports the "pdpe1gb" cpuinfo flag)
 			Note that 1GB pages can only be allocated at boot time
 			using hugepages= and not freed afterwards.
+	default_hugepagesz=
+			[same as hugepagesz=] The size of the default
+			HugeTLB page size. This is the size represented by
+			the legacy /proc/ hugepages APIs, used for SHM, and
+			default size when mounting hugetlbfs filesystems.
+			Defaults to the default architecture's huge page size
+			if not specified.
 
 	i8042.direct	[HW] Put keyboard port into non-translated mode
 	i8042.dumbkbd	[HW] Pretend that controller can only read data from
diff -puN mm/hugetlb.c~hugetlb-override-default-huge-page-size mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-override-default-huge-page-size
+++ a/mm/hugetlb.c
@@ -34,6 +34,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
+static unsigned long __initdata default_hstate_size;
 
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
@@ -1288,11 +1289,14 @@ static int __init hugetlb_init(void)
 {
 	BUILD_BUG_ON(HPAGE_SHIFT == 0);
 
-	if (!size_to_hstate(HPAGE_SIZE)) {
-		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
-		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
-	}
-	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
+	if (!size_to_hstate(default_hstate_size)) {
+		default_hstate_size = HPAGE_SIZE;
+		if (!size_to_hstate(default_hstate_size))
+			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+	}
+	default_hstate_idx = size_to_hstate(default_hstate_size) - hstates;
+	if (default_hstate_max_huge_pages)
+		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 
 	hugetlb_init_hstates();
 
@@ -1332,7 +1336,7 @@ void __init hugetlb_add_hstate(unsigned 
 	parsed_hstate = h;
 }
 
-static int __init hugetlb_setup(char *s)
+static int __init hugetlb_nrpages_setup(char *s)
 {
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
@@ -1367,7 +1371,14 @@ static int __init hugetlb_setup(char *s)
 
 	return 1;
 }
-__setup("hugepages=", hugetlb_setup);
+__setup("hugepages=", hugetlb_nrpages_setup);
+
+static int __init hugetlb_default_setup(char *s)
+{
+	default_hstate_size = memparse(s, &s);
+	return 1;
+}
+__setup("default_hugepagesz=", hugetlb_default_setup);
 
 static unsigned int cpuset_mems_nr(unsigned int *array)
 {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

