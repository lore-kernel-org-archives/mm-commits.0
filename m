Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127CEC64E7B
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 22:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84BA220709
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 22:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u513dZr2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgK3WJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgK3WJl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 17:09:41 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172F32073C;
        Mon, 30 Nov 2020 22:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606774140;
        bh=PA7nOglQxCMz8BaUYR8DV6lWQG55T2fz+wBmotXqpmk=;
        h=Date:From:To:Subject:From;
        b=u513dZr2cV4n+CotUvi/RAqF9rBanNclFpEkjvcQdHd9JJCc2HcARIpADi5pjxS18
         3PQhqSoQiDSsiNj5ZVDKMWJGXVAGUI8+21+j/V8zsVEHOJSS2TzdCkUCNH9Jys8h59
         +4l+4A5mO85x0P67XyQoSmq9zmXXQnDeHn6LmKSs=
Date:   Mon, 30 Nov 2020 14:08:59 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-memcontrol-account-pagetables-per-node.patch added
 to -mm tree
Message-ID: <20201130220859.Xbp6R7vRS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: account pagetables per node
has been added to the -mm tree.  Its filename is
     mm-memcontrol-account-pagetables-per-node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-account-pagetables-per-node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-account-pagetables-per-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcontrol: account pagetables per node

For many workloads, pagetable consumption is significant and it makes
sense to expose it in the memory.stat for the memory cgroups.  However at
the moment, the pagetables are accounted per-zone.  Converting them to
per-node and using the right interface will correctly account for the
memory cgroups as well.

Link: https://lkml.kernel.org/r/20201130212541.2781790-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +++
 arch/nds32/mm/mm-nds32.c                |    6 +++---
 drivers/base/node.c                     |    2 +-
 fs/proc/meminfo.c                       |    2 +-
 include/linux/mm.h                      |    8 ++++----
 include/linux/mmzone.h                  |    2 +-
 mm/memcontrol.c                         |    1 +
 mm/page_alloc.c                         |    6 +++---
 mm/vmstat.c                             |    2 +-
 9 files changed, 18 insertions(+), 14 deletions(-)

--- a/arch/nds32/mm/mm-nds32.c~mm-memcontrol-account-pagetables-per-node
+++ a/arch/nds32/mm/mm-nds32.c
@@ -34,8 +34,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	cpu_dcache_wb_range((unsigned long)new_pgd,
 			    (unsigned long)new_pgd +
 			    PTRS_PER_PGD * sizeof(pgd_t));
-	inc_zone_page_state(virt_to_page((unsigned long *)new_pgd),
-			    NR_PAGETABLE);
+	inc_lruvec_page_state(virt_to_page((unsigned long *)new_pgd),
+			      NR_PAGETABLE);
 
 	return new_pgd;
 }
@@ -59,7 +59,7 @@ void pgd_free(struct mm_struct *mm, pgd_
 
 	pte = pmd_page(*pmd);
 	pmd_clear(pmd);
-	dec_zone_page_state(virt_to_page((unsigned long *)pgd), NR_PAGETABLE);
+	dec_lruvec_page_state(virt_to_page((unsigned long *)pgd), NR_PAGETABLE);
 	pte_free(mm, pte);
 	mm_dec_nr_ptes(mm);
 	pmd_free(mm, pmd);
--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-account-pagetables-per-node
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1274,6 +1274,9 @@ PAGE_SIZE multiple when read back.
 	  kernel_stack
 		Amount of memory allocated to kernel stacks.
 
+	  pagetables
+                Amount of memory allocated for page tables.
+
 	  percpu(npn)
 		Amount of memory used for storing per-cpu kernel
 		data structures.
--- a/drivers/base/node.c~mm-memcontrol-account-pagetables-per-node
+++ a/drivers/base/node.c
@@ -450,7 +450,7 @@ static ssize_t node_read_meminfo(struct
 #ifdef CONFIG_SHADOW_CALL_STACK
 			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
-			     nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
+			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
 			     nid, 0UL,
 			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
--- a/fs/proc/meminfo.c~mm-memcontrol-account-pagetables-per-node
+++ a/fs/proc/meminfo.c
@@ -107,7 +107,7 @@ static int meminfo_proc_show(struct seq_
 		   global_node_page_state(NR_KERNEL_SCS_KB));
 #endif
 	show_val_kb(m, "PageTables:     ",
-		    global_zone_page_state(NR_PAGETABLE));
+		    global_node_page_state(NR_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ",
--- a/include/linux/mm.h~mm-memcontrol-account-pagetables-per-node
+++ a/include/linux/mm.h
@@ -2203,7 +2203,7 @@ static inline bool pgtable_pte_page_ctor
 	if (!ptlock_init(page))
 		return false;
 	__SetPageTable(page);
-	inc_zone_page_state(page, NR_PAGETABLE);
+	inc_lruvec_page_state(page, NR_PAGETABLE);
 	return true;
 }
 
@@ -2211,7 +2211,7 @@ static inline void pgtable_pte_page_dtor
 {
 	ptlock_free(page);
 	__ClearPageTable(page);
-	dec_zone_page_state(page, NR_PAGETABLE);
+	dec_lruvec_page_state(page, NR_PAGETABLE);
 }
 
 #define pte_offset_map_lock(mm, pmd, address, ptlp)	\
@@ -2298,7 +2298,7 @@ static inline bool pgtable_pmd_page_ctor
 	if (!pmd_ptlock_init(page))
 		return false;
 	__SetPageTable(page);
-	inc_zone_page_state(page, NR_PAGETABLE);
+	inc_lruvec_page_state(page, NR_PAGETABLE);
 	return true;
 }
 
@@ -2306,7 +2306,7 @@ static inline void pgtable_pmd_page_dtor
 {
 	pmd_ptlock_free(page);
 	__ClearPageTable(page);
-	dec_zone_page_state(page, NR_PAGETABLE);
+	dec_lruvec_page_state(page, NR_PAGETABLE);
 }
 
 /*
--- a/include/linux/mmzone.h~mm-memcontrol-account-pagetables-per-node
+++ a/include/linux/mmzone.h
@@ -151,7 +151,6 @@ enum zone_stat_item {
 	NR_ZONE_UNEVICTABLE,
 	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	NR_PAGETABLE,		/* used for pagetables */
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
@@ -206,6 +205,7 @@ enum node_stat_item {
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
+	NR_PAGETABLE,		/* used for pagetables */
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/memcontrol.c~mm-memcontrol-account-pagetables-per-node
+++ a/mm/memcontrol.c
@@ -1567,6 +1567,7 @@ static struct memory_stat memory_stats[]
 	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
 	{ "file", PAGE_SIZE, NR_FILE_PAGES },
 	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
+	{ "pagetables", PAGE_SIZE, NR_PAGETABLE },
 	{ "percpu", 1, MEMCG_PERCPU_B },
 	{ "sock", PAGE_SIZE, MEMCG_SOCK },
 	{ "shmem", PAGE_SIZE, NR_SHMEM },
--- a/mm/page_alloc.c~mm-memcontrol-account-pagetables-per-node
+++ a/mm/page_alloc.c
@@ -5465,7 +5465,7 @@ void show_free_areas(unsigned int filter
 		global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B),
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
-		global_zone_page_state(NR_PAGETABLE),
+		global_node_page_state(NR_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
@@ -5497,6 +5497,7 @@ void show_free_areas(unsigned int filter
 #ifdef CONFIG_SHADOW_CALL_STACK
 			" shadow_call_stack:%lukB"
 #endif
+			" pagetables:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -5522,6 +5523,7 @@ void show_free_areas(unsigned int filter
 #ifdef CONFIG_SHADOW_CALL_STACK
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
+			K(node_page_state(pgdat, NR_PAGETABLE)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
@@ -5553,7 +5555,6 @@ void show_free_areas(unsigned int filter
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
-			" pagetables:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
 			" local_pcp:%ukB"
@@ -5574,7 +5575,6 @@ void show_free_areas(unsigned int filter
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
-			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
 			K(this_cpu_read(zone->pageset->pcp.count)),
--- a/mm/vmstat.c~mm-memcontrol-account-pagetables-per-node
+++ a/mm/vmstat.c
@@ -1157,7 +1157,6 @@ const char * const vmstat_text[] = {
 	"nr_zone_unevictable",
 	"nr_zone_write_pending",
 	"nr_mlock",
-	"nr_page_table_pages",
 	"nr_bounce",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
@@ -1215,6 +1214,7 @@ const char * const vmstat_text[] = {
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	"nr_shadow_call_stack",
 #endif
+	"nr_page_table_pages",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-rmap-always-do-ttu_ignore_access.patch
mm-move-lruvec-stats-update-functions-to-vmstath.patch
mm-memcontrol-account-pagetables-per-node.patch
mm-kvm-account-kvm_vcpu_mmap-to-kmemcg.patch

