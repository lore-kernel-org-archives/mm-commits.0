Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD9EC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA6D225AB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgLODHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgLODHD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:03 -0500
Date:   Mon, 14 Dec 2020 19:06:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001582;
        bh=UT5n9Bu8N2O2zWPjs+I59OADqa2ESrQSGWxQiZpR/iI=;
        h=From:To:Subject:In-Reply-To:From;
        b=CcJWIVQjcO67/EwAUnDZWW9j3+mhrI3wEP+D7mJ4/z2k6D3sf6hmRJ65rLlCdS3xv
         GtcnOH0I2lG0C1dV0K3kcX6MkQgU+Ee1gZ/1fOXSCEPj0ZOpu+SuqZ0/YBxrPhaKz3
         peONQaS0kBuPFppbHTwOOZit+3PF4BcOaSzgxwbA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        rientjes@google.com, shakeelb@google.com, songliubraving@fb.com,
        torvalds@linux-foundation.org
Subject:  [patch 055/200] mm: memcontrol: add file_thp, shmem_thp
 to memory.stat
Message-ID: <20201215030620.kwmNIBasi%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
