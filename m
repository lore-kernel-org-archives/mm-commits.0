Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8050C433E6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE48965274
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhCHULE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhCHUKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:10:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C1F64EEA;
        Mon,  8 Mar 2021 20:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615234241;
        bh=eN0SZpVAPEpbw00W2DJttEeWp3NCpMsIpSgSgqT4x00=;
        h=Date:From:To:Subject:From;
        b=YY9eB1R8vR93EEevJ0qlY7r8rE1jfE357wdpa15liMfXHB/N6d3B8yg8sDNB/cacM
         3F0Y3MwK1acbHwpVAsjrOrAqC3RvM0J6hVX4yhU6Y2zJH1cAdS2lPjXUM0K07Q5jkh
         ZXaJ4i05umqCurVDHoFMB9HKqnjPA0lD/Msk9auc=
Date:   Mon, 08 Mar 2021 12:10:39 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        luto@kernel.org, mchehab+huawei@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
 added to -mm tree
Message-ID: <20210308201039.H5jo-GmEi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: factor out bootmem core functions to bootmem_info.c
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memory_hotplug: factor out bootmem core functions to bootmem_info.c

Patch series "Free some vmemmap pages of HugeTLB page", v18.

This patch series will free some vmemmap pages(struct page structures)
associated with each HugeTLB page when preallocated to save memory.

In order to reduce the difficulty of the first version of code review.  In
this version, we disable PMD/huge page mapping of vmemmap if this feature
was enabled.  This acutely eliminates a bunch of the complex code doing
page table manipulation.  When this patch series is solid, we cam add the
code of vmemmap page table manipulation in the future.

The struct page structures (page structs) are used to describe a physical
page frame.  By default, there is an one-to-one mapping from a page frame
to it's corresponding page struct.

The HugeTLB pages consist of multiple base page size pages and is
supported by many architectures.  See hugetlbpage.rst in the Documentation
directory for more details.  On the x86 architecture, HugeTLB pages of
size 2MB and 1GB are currently supported.  Since the base page size on x86
is 4KB, a 2MB HugeTLB page consists of 512 base pages and a 1GB HugeTLB
page consists of 4096 base pages.  For each base page, there is a
corresponding page struct.

Within the HugeTLB subsystem, only the first 4 page structs are used to
contain unique information about a HugeTLB page.  HUGETLB_CGROUP_MIN_ORDER
provides this upper limit.  The only 'useful' information in the remaining
page structs is the compound_head field, and this field is the same for
all tail pages.

By removing redundant page structs for HugeTLB pages, memory can returned
to the buddy allocator for other uses.

When the system boot up, every 2M HugeTLB has 512 struct page structs which
size is 8 pages(sizeof(struct page) * 512 / PAGE_SIZE).

    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
 +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
 |           |                     |     0     | -------------> |     0     |
 |           |                     +-----------+                +-----------+
 |           |                     |     1     | -------------> |     1     |
 |           |                     +-----------+                +-----------+
 |           |                     |     2     | -------------> |     2     |
 |           |                     +-----------+                +-----------+
 |           |                     |     3     | -------------> |     3     |
 |           |                     +-----------+                +-----------+
 |           |                     |     4     | -------------> |     4     |
 |    2MB    |                     +-----------+                +-----------+
 |           |                     |     5     | -------------> |     5     |
 |           |                     +-----------+                +-----------+
 |           |                     |     6     | -------------> |     6     |
 |           |                     +-----------+                +-----------+
 |           |                     |     7     | -------------> |     7     |
 |           |                     +-----------+                +-----------+
 |           |
 |           |
 |           |
 +-----------+

The value of page->compound_head is the same for all tail pages.  The
first page of page structs (page 0) associated with the HugeTLB page
contains the 4 page structs necessary to describe the HugeTLB.  The only
use of the remaining pages of page structs (page 1 to page 7) is to point
to page->compound_head.  Therefore, we can remap pages 2 to 7 to page 1. 
Only 2 pages of page structs will be used for each HugeTLB page.  This
will allow us to free the remaining 6 pages to the buddy allocator.

Here is how things look after remapping.

    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
 +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
 |           |                     |     0     | -------------> |     0     |
 |           |                     +-----------+                +-----------+
 |           |                     |     1     | -------------> |     1     |
 |           |                     +-----------+                +-----------+
 |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
 |           |                     +-----------+                   | | | | |
 |           |                     |     3     | ------------------+ | | | |
 |           |                     +-----------+                     | | | |
 |           |                     |     4     | --------------------+ | | |
 |    2MB    |                     +-----------+                       | | |
 |           |                     |     5     | ----------------------+ | |
 |           |                     +-----------+                         | |
 |           |                     |     6     | ------------------------+ |
 |           |                     +-----------+                           |
 |           |                     |     7     | --------------------------+
 |           |                     +-----------+
 |           |
 |           |
 |           |
 +-----------+

When a HugeTLB is freed to the buddy system, we should allocate 6 pages
for vmemmap pages and restore the previous mapping relationship.

Apart from 2MB HugeTLB page, we also have 1GB HugeTLB page.  It is similar
to the 2MB HugeTLB page.  We also can use this approach to free the
vmemmap pages.

In this case, for the 1GB HugeTLB page, we can save 4094 pages.  This is a
very substantial gain.  On our server, run some SPDK/QEMU applications
which will use 1024GB HugeTLB page.  With this feature enabled, we can
save ~16GB (1G hugepage)/~12GB (2MB hugepage) memory.

Because there are vmemmap page tables reconstruction on the
freeing/allocating path, it increases some overhead.  Here are some
overhead analysis.

1) Allocating 10240 2MB HugeTLB pages.

   a) With this patch series applied:
   # time echo 10240 > /proc/sys/vm/nr_hugepages

   real     0m0.166s
   user     0m0.000s
   sys      0m0.166s

   # bpftrace -e 'kprobe:alloc_fresh_huge_page { @start[tid] = nsecs; }
     kretprobe:alloc_fresh_huge_page /@start[tid]/ { @latency = hist(nsecs -
     @start[tid]); delete(@start[tid]); }'
   Attaching 2 probes...

   @latency:
   [8K, 16K)           5476 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
   [16K, 32K)          4760 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       |
   [32K, 64K)             4 |                                                    |

   b) Without this patch series:
   # time echo 10240 > /proc/sys/vm/nr_hugepages

   real     0m0.067s
   user     0m0.000s
   sys      0m0.067s

   # bpftrace -e 'kprobe:alloc_fresh_huge_page { @start[tid] = nsecs; }
     kretprobe:alloc_fresh_huge_page /@start[tid]/ { @latency = hist(nsecs -
     @start[tid]); delete(@start[tid]); }'
   Attaching 2 probes...

   @latency:
   [4K, 8K)           10147 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
   [8K, 16K)             93 |                                                    |

   Summarize: this feature is about ~2x slower than before.

2) Freeing 10240 2MB HugeTLB pages.

   a) With this patch series applied:
   # time echo 0 > /proc/sys/vm/nr_hugepages

   real     0m0.213s
   user     0m0.000s
   sys      0m0.213s

   # bpftrace -e 'kprobe:free_pool_huge_page { @start[tid] = nsecs; }
     kretprobe:free_pool_huge_page /@start[tid]/ { @latency = hist(nsecs -
     @start[tid]); delete(@start[tid]); }'
   Attaching 2 probes...

   @latency:
   [8K, 16K)              6 |                                                    |
   [16K, 32K)         10227 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
   [32K, 64K)             7 |                                                    |

   b) Without this patch series:
   # time echo 0 > /proc/sys/vm/nr_hugepages

   real     0m0.081s
   user     0m0.000s
   sys      0m0.081s

   # bpftrace -e 'kprobe:free_pool_huge_page { @start[tid] = nsecs; }
     kretprobe:free_pool_huge_page /@start[tid]/ { @latency = hist(nsecs -
     @start[tid]); delete(@start[tid]); }'
   Attaching 2 probes...

   @latency:
   [4K, 8K)            6805 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
   [8K, 16K)           3427 |@@@@@@@@@@@@@@@@@@@@@@@@@@                          |
   [16K, 32K)             8 |                                                    |

   Summarize: The overhead of __free_hugepage is about ~2-3x slower than before.

Although the overhead has increased, the overhead is not significant. 
Like Mike said, "However, remember that the majority of use cases create
HugeTLB pages at or shortly after boot time and add them to the pool.  So,
additional overhead is at pool creation time.  There is no change to
'normal run time' operations of getting a page from or returning a page to
the pool (think page fault/unmap)".

Despite the overhead and in addition to the memory gains from this series.
The following data is obtained by Joao Martins.  Very thanks to his
effort.

There's an additional benefit which is page (un)pinners will see an
improvement and Joao presumes because there are fewer memmap pages and
thus the tail/head pages are staying in cache more often.

Out of the box Joao saw (when comparing linux-next against linux-next +
this series) with gup_test and pinning a 16G HugeTLB file (with 1G pages):


	get_user_pages(): ~32k -> ~9k
	unpin_user_pages(): ~75k -> ~70k

Usually any tight loop fetching compound_head(), or reading tail pages
data (e.g.  compound_head) benefit a lot.  There's some unpinning
inefficiencies Joao was fixing[0], but with that in added it shows even
more:

	unpin_user_pages(): ~27k -> ~3.8k

[0] https://lore.kernel.org/linux-mm/20210204202500.26474-1-joao.m.martins@oracle.com/


This patch (of 9):

Move bootmem info registration common API to individual bootmem_info.c. 
And we will use {get,put}_page_bootmem() to initialize the page for the
vmemmap pages or free the vmemmap pages to buddy in the later patch.  So
move them out of CONFIG_MEMORY_HOTPLUG_SPARSE.  This is just code movement
without any functional change.

Link: https://lkml.kernel.org/r/20210308102807.59745-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210308102807.59745-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c          |    3 
 include/linux/bootmem_info.h   |   40 +++++++++
 include/linux/memory_hotplug.h |   27 ------
 mm/Makefile                    |    1 
 mm/bootmem_info.c              |  127 +++++++++++++++++++++++++++++++
 mm/memory_hotplug.c            |  116 ----------------------------
 mm/sparse.c                    |    1 
 7 files changed, 171 insertions(+), 144 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc
+++ a/arch/x86/mm/init_64.c
@@ -33,6 +33,7 @@
 #include <linux/nmi.h>
 #include <linux/gfp.h>
 #include <linux/kcore.h>
+#include <linux/bootmem_info.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1618,7 +1619,7 @@ int __meminit vmemmap_populate(unsigned
 	return err;
 }
 
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HAVE_BOOTMEM_INFO_NODE)
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long nr_pages)
 {
--- /dev/null
+++ a/include/linux/bootmem_info.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_BOOTMEM_INFO_H
+#define __LINUX_BOOTMEM_INFO_H
+
+#include <linux/mmzone.h>
+
+/*
+ * Types for free bootmem stored in page->lru.next. These have to be in
+ * some random range in unsigned long space for debugging purposes.
+ */
+enum {
+	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 12,
+	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
+	MIX_SECTION_INFO,
+	NODE_INFO,
+	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
+};
+
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
+void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
+
+void get_page_bootmem(unsigned long info, struct page *page,
+		      unsigned long type);
+void put_page_bootmem(struct page *page);
+#else
+static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
+{
+}
+
+static inline void put_page_bootmem(struct page *page)
+{
+}
+
+static inline void get_page_bootmem(unsigned long info, struct page *page,
+				    unsigned long type)
+{
+}
+#endif
+
+#endif /* __LINUX_BOOTMEM_INFO_H */
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc
+++ a/include/linux/memory_hotplug.h
@@ -18,18 +18,6 @@ struct vmem_altmap;
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
 
-/*
- * Types for free bootmem stored in page->lru.next. These have to be in
- * some random range in unsigned long space for debugging purposes.
- */
-enum {
-	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 12,
-	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
-	MIX_SECTION_INFO,
-	NODE_INFO,
-	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
-};
-
 /* Types for control the zone type of onlined and offlined memory */
 enum {
 	/* Offline the memory. */
@@ -210,17 +198,6 @@ static inline void arch_refresh_nodedata
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-extern void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
-#else
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-#endif
-extern void put_page_bootmem(struct page *page);
-extern void get_page_bootmem(unsigned long ingo, struct page *page,
-			     unsigned long type);
-
 void get_online_mems(void);
 void put_online_mems(void);
 
@@ -248,10 +225,6 @@ static inline void zone_span_writelock(s
 static inline void zone_span_writeunlock(struct zone *zone) {}
 static inline void zone_seqlock_init(struct zone *zone) {}
 
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-
 static inline int try_online_node(int nid)
 {
 	return 0;
--- /dev/null
+++ a/mm/bootmem_info.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Bootmem core functions.
+ *
+ * Copyright (c) 2020, Bytedance.
+ *
+ *     Author: Muchun Song <songmuchun@bytedance.com>
+ *
+ */
+#include <linux/mm.h>
+#include <linux/compiler.h>
+#include <linux/memblock.h>
+#include <linux/bootmem_info.h>
+#include <linux/memory_hotplug.h>
+
+void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
+{
+	page->freelist = (void *)type;
+	SetPagePrivate(page);
+	set_page_private(page, info);
+	page_ref_inc(page);
+}
+
+void put_page_bootmem(struct page *page)
+{
+	unsigned long type;
+
+	type = (unsigned long) page->freelist;
+	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
+	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
+
+	if (page_ref_dec_return(page) == 1) {
+		page->freelist = NULL;
+		ClearPagePrivate(page);
+		set_page_private(page, 0);
+		INIT_LIST_HEAD(&page->lru);
+		free_reserved_page(page);
+	}
+}
+
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+static void register_page_bootmem_info_section(unsigned long start_pfn)
+{
+	unsigned long mapsize, section_nr, i;
+	struct mem_section *ms;
+	struct page *page, *memmap;
+	struct mem_section_usage *usage;
+
+	section_nr = pfn_to_section_nr(start_pfn);
+	ms = __nr_to_section(section_nr);
+
+	/* Get section's memmap address */
+	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+
+	/*
+	 * Get page for the memmap's phys address
+	 * XXX: need more consideration for sparse_vmemmap...
+	 */
+	page = virt_to_page(memmap);
+	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
+	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
+
+	/* remember memmap's page */
+	for (i = 0; i < mapsize; i++, page++)
+		get_page_bootmem(section_nr, page, SECTION_INFO);
+
+	usage = ms->usage;
+	page = virt_to_page(usage);
+
+	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
+
+	for (i = 0; i < mapsize; i++, page++)
+		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
+
+}
+#else /* CONFIG_SPARSEMEM_VMEMMAP */
+static void register_page_bootmem_info_section(unsigned long start_pfn)
+{
+	unsigned long mapsize, section_nr, i;
+	struct mem_section *ms;
+	struct page *page, *memmap;
+	struct mem_section_usage *usage;
+
+	section_nr = pfn_to_section_nr(start_pfn);
+	ms = __nr_to_section(section_nr);
+
+	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+
+	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
+
+	usage = ms->usage;
+	page = virt_to_page(usage);
+
+	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
+
+	for (i = 0; i < mapsize; i++, page++)
+		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
+}
+#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
+
+void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
+{
+	unsigned long i, pfn, end_pfn, nr_pages;
+	int node = pgdat->node_id;
+	struct page *page;
+
+	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
+	page = virt_to_page(pgdat);
+
+	for (i = 0; i < nr_pages; i++, page++)
+		get_page_bootmem(node, page, NODE_INFO);
+
+	pfn = pgdat->node_start_pfn;
+	end_pfn = pgdat_end_pfn(pgdat);
+
+	/* register section info */
+	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		/*
+		 * Some platforms can assign the same pfn to multiple nodes - on
+		 * node0 as well as nodeN.  To avoid registering a pfn against
+		 * multiple nodes we check that this pfn does not already
+		 * reside in some other nodes.
+		 */
+		if (pfn_valid(pfn) && (early_pfn_to_nid(pfn) == node))
+			register_page_bootmem_info_section(pfn);
+	}
+}
--- a/mm/Makefile~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc
+++ a/mm/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_FAILSLAB) += failslab.o
+obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc
+++ a/mm/memory_hotplug.c
@@ -144,122 +144,6 @@ static void release_memory_resource(stru
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-void get_page_bootmem(unsigned long info,  struct page *page,
-		      unsigned long type)
-{
-	page->freelist = (void *)type;
-	SetPagePrivate(page);
-	set_page_private(page, info);
-	page_ref_inc(page);
-}
-
-void put_page_bootmem(struct page *page)
-{
-	unsigned long type;
-
-	type = (unsigned long) page->freelist;
-	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
-	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
-
-	if (page_ref_dec_return(page) == 1) {
-		page->freelist = NULL;
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		INIT_LIST_HEAD(&page->lru);
-		free_reserved_page(page);
-	}
-}
-
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-	struct mem_section_usage *usage;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	/* Get section's memmap address */
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	/*
-	 * Get page for the memmap's phys address
-	 * XXX: need more consideration for sparse_vmemmap...
-	 */
-	page = virt_to_page(memmap);
-	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
-	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
-
-	/* remember memmap's page */
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, SECTION_INFO);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
-
-}
-#else /* CONFIG_SPARSEMEM_VMEMMAP */
-static void register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-	struct mem_section_usage *usage;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
-}
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
-
-void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-	unsigned long i, pfn, end_pfn, nr_pages;
-	int node = pgdat->node_id;
-	struct page *page;
-
-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
-	page = virt_to_page(pgdat);
-
-	for (i = 0; i < nr_pages; i++, page++)
-		get_page_bootmem(node, page, NODE_INFO);
-
-	pfn = pgdat->node_start_pfn;
-	end_pfn = pgdat_end_pfn(pgdat);
-
-	/* register section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		/*
-		 * Some platforms can assign the same pfn to multiple nodes - on
-		 * node0 as well as nodeN.  To avoid registering a pfn against
-		 * multiple nodes we check that this pfn does not already
-		 * reside in some other nodes.
-		 */
-		if (pfn_valid(pfn) && (early_pfn_to_nid(pfn) == node))
-			register_page_bootmem_info_section(pfn);
-	}
-}
-#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
-
 static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
 		const char *reason)
 {
--- a/mm/sparse.c~mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc
+++ a/mm/sparse.c
@@ -13,6 +13,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/bootmem_info.h>
 
 #include "internal.h"
 #include <asm/dma.h>
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-optimize-the-code-with-the-help-of-the-compiler.patch

