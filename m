From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-include-hugepages-in-meminfo.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:01 -0700
Message-ID: <20130430184801.7864B31C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54099 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3SsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:02 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so85041vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: include hugepages in meminfo
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-include-hugepages-in-meminfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: include hugepages in meminfo

Particularly in oom conditions, it's troublesome that hugetlb memory is
not displayed.  All other meminfo that is emitted will not add up to what
is expected, and there is no artifact left in the kernel log to show that
a potentially significant amount of memory is actually allocated as
hugepages which are not available to be reclaimed.

Booting with hugepages=8192 on the command line, this memory is now shown
in oom conditions.  For example, with echo m > /proc/sysrq-trigger:

Node 0 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 1 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 2 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 3 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++++
 mm/hugetlb.c            |   15 +++++++++++++++
 mm/page_alloc.c         |    3 +++
 3 files changed, 22 insertions(+)

diff -puN include/linux/hugetlb.h~mm-hugetlb-include-hugepages-in-meminfo include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-include-hugepages-in-meminfo
+++ a/include/linux/hugetlb.h
@@ -58,6 +58,7 @@ void __unmap_hugepage_range(struct mmu_g
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
+void hugetlb_show_meminfo(void);
 unsigned long hugetlb_total_pages(void);
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
@@ -114,6 +115,9 @@ static inline void hugetlb_report_meminf
 {
 }
 #define hugetlb_report_node_meminfo(n, buf)	0
+static inline void hugetlb_show_meminfo(void)
+{
+}
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
 #define follow_huge_pud(mm, addr, pud, write)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
diff -puN mm/hugetlb.c~mm-hugetlb-include-hugepages-in-meminfo mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-include-hugepages-in-meminfo
+++ a/mm/hugetlb.c
@@ -2121,6 +2121,21 @@ int hugetlb_report_node_meminfo(int nid,
 		nid, h->surplus_huge_pages_node[nid]);
 }
 
+void hugetlb_show_meminfo(void)
+{
+	struct hstate *h;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		for_each_hstate(h)
+			pr_info("Node %d hugepages_total=%u hugepages_free=%u hugepages_surp=%u hugepages_size=%lukB\n",
+				nid,
+				h->nr_huge_pages_node[nid],
+				h->free_huge_pages_node[nid],
+				h->surplus_huge_pages_node[nid],
+				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+}
+
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
diff -puN mm/page_alloc.c~mm-hugetlb-include-hugepages-in-meminfo mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hugetlb-include-hugepages-in-meminfo
+++ a/mm/page_alloc.c
@@ -58,6 +58,7 @@
 #include <linux/prefetch.h>
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
+#include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 
 #include <asm/tlbflush.h>
@@ -3113,6 +3114,8 @@ void show_free_areas(unsigned int filter
 		printk("= %lukB\n", K(total));
 	}
 
+	hugetlb_show_meminfo();
+
 	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch
fs-proc-truncate-proc-pid-comm-writes-to-first-task_comm_len-bytes.patch

