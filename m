Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E218C3526F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D47422D02
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgLPAAU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbgLOX1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:21 -0500
Date:   Tue, 15 Dec 2020 15:18:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074282;
        bh=M3u75+KASdxi84AGUs3VhFJ6OOrhDTHAs4/YB+A2bbs=;
        h=From:To:Subject:From;
        b=YhqwufA7TzR9mBwPLAUPcSGQXo3pfswIHUS5zN4rXIbbrGkmKduHxYZTItzxaazyh
         IzlsrfIwRMJQoBMvep0AowtS9vSSu8ilcpba+wAki3gDoK19+Al7nKsmF6v40WfTgK
         D7ZCwQ/tCpn+Efrm556UA+81VNNrgveidiWMDKtg=
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        riel@surriel.com, rientjes@google.com, shakeelb@google.com,
        songliubraving@fb.com
Subject:  [merged]
 mm-memcontrol-add-file_thp-shmem_thp-to-memorystat.patch removed from -mm
 tree
Message-ID: <20201215231802.3y7WXc6Vc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add file_thp, shmem_thp to memory.stat
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-file_thp-shmem_thp-to-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: add file_thp, shmem_thp to memory.stat

As huge page usage in the page cache and for shmem files proliferates in
our production environment, the performance monitoring team has asked for
per-cgroup stats on those pages.

We already track and export anon_thp per cgroup.  We already track file
THP and shmem THP per node, so making them per-cgroup is only a matter of
switching from node to lruvec counters.  All callsites are in places where
the pages are charged and locked, so page->memcg is stable.

[hannes@cmpxchg.org: add documentation]
  Link: https://lkml.kernel.org/r/20201026174029.GC548555@cmpxchg.org
Link: https://lkml.kernel.org/r/20201022151844.489337-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    8 ++++++++
 mm/filemap.c                            |    4 ++--
 mm/huge_memory.c                        |    4 ++--
 mm/khugepaged.c                         |    4 ++--
 mm/memcontrol.c                         |    6 +++++-
 mm/shmem.c                              |    2 +-
 6 files changed, 20 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1300,6 +1300,14 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
 
+	  file_thp
+		Amount of cached filesystem data backed by transparent
+		hugepages
+
+	  shmem_thp
+		Amount of shm, tmpfs, shared anonymous mmap()s backed by
+		transparent hugepages
+
 	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
--- a/mm/filemap.c~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/mm/filemap.c
@@ -204,9 +204,9 @@ static void unaccount_page_cache_page(st
 	if (PageSwapBacked(page)) {
 		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
 		if (PageTransHuge(page))
-			__dec_node_page_state(page, NR_SHMEM_THPS);
+			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
 	} else if (PageTransHuge(page)) {
-		__dec_node_page_state(page, NR_FILE_THPS);
+		__dec_lruvec_page_state(page, NR_FILE_THPS);
 		filemap_nr_thps_dec(mapping);
 	}
 
--- a/mm/huge_memory.c~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/mm/huge_memory.c
@@ -2710,9 +2710,9 @@ int split_huge_page_to_list(struct page
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
 			if (PageSwapBacked(head))
-				__dec_node_page_state(head, NR_SHMEM_THPS);
+				__dec_lruvec_page_state(head, NR_SHMEM_THPS);
 			else
-				__dec_node_page_state(head, NR_FILE_THPS);
+				__dec_lruvec_page_state(head, NR_FILE_THPS);
 		}
 
 		__split_huge_page(page, list, end, flags);
--- a/mm/khugepaged.c~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/mm/khugepaged.c
@@ -1845,9 +1845,9 @@ out_unlock:
 	}
 
 	if (is_shmem)
-		__inc_node_page_state(new_page, NR_SHMEM_THPS);
+		__inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
 	else {
-		__inc_node_page_state(new_page, NR_FILE_THPS);
+		__inc_lruvec_page_state(new_page, NR_FILE_THPS);
 		filemap_nr_thps_inc(mapping);
 	}
 
--- a/mm/memcontrol.c~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/mm/memcontrol.c
@@ -1512,6 +1512,8 @@ static struct memory_stat memory_stats[]
 	 * constant(e.g. powerpc).
 	 */
 	{ "anon_thp", 0, NR_ANON_THPS },
+	{ "file_thp", 0, NR_FILE_THPS },
+	{ "shmem_thp", 0, NR_SHMEM_THPS },
 #endif
 	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
 	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
@@ -1542,7 +1544,9 @@ static int __init memory_stats_init(void
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_ANON_THPS)
+		if (memory_stats[i].idx == NR_ANON_THPS ||
+		    memory_stats[i].idx == NR_FILE_THPS ||
+		    memory_stats[i].idx == NR_SHMEM_THPS)
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
 #endif
 		VM_BUG_ON(!memory_stats[i].ratio);
--- a/mm/shmem.c~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat
+++ a/mm/shmem.c
@@ -713,7 +713,7 @@ next:
 		}
 		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_ALLOC);
-			__inc_node_page_state(page, NR_SHMEM_THPS);
+			__inc_lruvec_page_state(page, NR_SHMEM_THPS);
 		}
 		mapping->nrpages += nr;
 		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


