From: akpm@linux-foundation.org
Subject: + mm-hugetlb-include-hugepages-in-meminfo.patch added to -mm tree
Date: Wed, 20 Mar 2013 16:03:48 -0700
Message-ID: <20130320230348.74EB131C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:43466 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3CTXDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:03:49 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so209503ves.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:03:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, mhocko@suse.cz


The patch titled
     Subject: mm, hugetlb: include hugepages in meminfo
has been added to the -mm tree.  Its filename is
     mm-hugetlb-include-hugepages-in-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+		        	nid,
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
@@ -3112,6 +3113,8 @@ void show_free_areas(unsigned int filter
 		printk("= %lukB\n", K(total));
 	}
 
+	hugetlb_show_meminfo();
+
 	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

