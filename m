From: akpm@linux-foundation.org
Subject: +
 sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch
 added to -mm tree
Date: Fri, 31 May 2013 14:36:35 -0700
Message-ID: <51a917e3.U29spI3CNbUcisry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3EaVgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liuj97@gmail.com, dave.hansen@linux.intel.com, cody@linux.vnet.ibm.com

Subject: + sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch added to -mm tree
To: cody@linux.vnet.ibm.com,dave.hansen@linux.intel.com,liuj97@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:36:35 -0700


The patch titled
     Subject: sparsemem: add BUILD_BUG_ON when sizeof mem_section is non-power-of-2
has been added to the -mm tree.  Its filename is
     sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: sparsemem: add BUILD_BUG_ON when sizeof mem_section is non-power-of-2

Instead of leaving a hidden trap for the next person who comes along and
wants to add something to mem_section, add a big fat warning about it
needing to be a power-of-2, and insert a BUILD_BUG_ON() in sparse_init()
to catch mistakes.

Right now non-power-of-2 mem_sections cause a number of WARNs at boot
(which don't clearly point to the size of mem_section as an issue), but
the system limps on (temporarily, at least).

This is based upon Dave Hansen's earlier RFC where he ran into the same
issue:
	"sparsemem: fix boot when SECTIONS_PER_ROOT is not power-of-2"
	http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/03077.html

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++++
 mm/sparse.c            |    3 +++
 2 files changed, 7 insertions(+)

diff -puN include/linux/mmzone.h~sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2
+++ a/include/linux/mmzone.h
@@ -1137,6 +1137,10 @@ struct mem_section {
 	struct page_cgroup *page_cgroup;
 	unsigned long pad;
 #endif
+	/*
+	 * WARNING: mem_section must be a power-of-2 in size for the
+	 * calculation and use of SECTION_ROOT_MASK to make sense.
+	 */
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
diff -puN mm/sparse.c~sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2 mm/sparse.c
--- a/mm/sparse.c~sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2
+++ a/mm/sparse.c
@@ -480,6 +480,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* see include/linux/mmzone.h 'struct mem_section' definition */
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
+
 	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
 	set_pageblock_order();
 
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-fix-comment-referring-to-non-existent-size_seqlock-change-to-span_seqlock.patch
mmzone-note-that-node_size_lock-should-be-manipulated-via-pgdat_resize_lock.patch
memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch

