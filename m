Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF162C4332E
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 02:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B86225AA
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 02:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgLWCnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgLWCXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6A1523159;
        Wed, 23 Dec 2020 02:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608690165;
        bh=6x617QMaafUIBou3uLxxF3gOxFw9rizSWwzN8jaK1bw=;
        h=Date:From:To:Subject:From;
        b=Gvne8IGSZlDTbfdPK5avqQYUYpDgy1/DxzrQ1n7W+P+BGL9IVaqusemmnk0Z2qi1P
         2rMMqI/xxQ55xnmbadbCHNSeaHjlveSsQRexdBTWJ2RpL11pdaiLsioxgj1jkj8mLM
         9+9qf1CMR3QU9x1K44ujA7lacXCsELokjzhBznoY=
Date:   Tue, 22 Dec 2020 18:22:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, samitolvanen@google.com,
        rdunlap@infradead.org, rafael@kernel.org,
        pankaj.gupta@cloud.ionos.com, neilb@suse.de, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        guro@fb.com, gregkh@linuxfoundation.org, feng.tang@intel.com,
        adobriyan@gmail.com, songmuchun@bytedance.com
Subject:  +
 mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch added to -mm
 tree
Message-ID: <20201223022244.JMKjm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages
has been added to the -mm tree.  Its filename is
     mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch

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
Subject: mm: memcontrol: convert NR_SHMEM_PMDMAPPED account to pages

Currently we use struct per_cpu_nodestat to cache the vmstat counters,
which leads to inaccurate statistics expecially THP vmstat counters.  In
the systems with hundreads of processors it can be GBs of memory.  For
example, for a 96 CPUs system, the threshold is the maximum number of 125.
And the per cpu counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth
of memory in one go) so skipping the batching seems like sensible. 
Although every THP stats update overflows the per-cpu counter, resorting
to atomic global updates.  But it can make the statistics more accuracy
for the THP vmstat counters.

So we convert the NR_SHMEM_PMDMAPPED account to pages.  This patch is
consistent with 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page
arrival").  Doing this also can make the unit of vmstat counters more
unified.  Finally, the unit of the vmstat counters are pages, kB and
bytes.  The B/KB suffix can tell us that the unit is bytes or kB.  The
rest which is without suffix are pages.

Link: https://lkml.kernel.org/r/20201217034356.4708-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Rafael. J. Wysocki <rafael@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    3 +--
 fs/proc/meminfo.c      |    2 +-
 include/linux/mmzone.h |    3 ++-
 mm/page_alloc.c        |    3 +--
 mm/rmap.c              |   14 ++++++++++----
 5 files changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages
+++ a/drivers/base/node.c
@@ -463,8 +463,7 @@ static ssize_t node_read_meminfo(struct
 			     ,
 			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS)),
-			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
 			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED) *
 				    HPAGE_PMD_NR)
--- a/fs/proc/meminfo.c~mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages
+++ a/fs/proc/meminfo.c
@@ -133,7 +133,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "ShmemHugePages: ",
 		    global_node_page_state(NR_SHMEM_THPS));
 	show_val_kb(m, "ShmemPmdMapped: ",
-		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_SHMEM_PMDMAPPED));
 	show_val_kb(m, "FileHugePages:  ",
 		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
--- a/include/linux/mmzone.h~mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages
+++ a/include/linux/mmzone.h
@@ -218,7 +218,8 @@ static __always_inline bool vmstat_item_
 {
 	return item == NR_ANON_THPS ||
 	       item == NR_FILE_THPS ||
-	       item == NR_SHMEM_THPS;
+	       item == NR_SHMEM_THPS ||
+	       item == NR_SHMEM_PMDMAPPED;
 }
 
 /*
--- a/mm/page_alloc.c~mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages
+++ a/mm/page_alloc.c
@@ -5578,8 +5578,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			K(node_page_state(pgdat, NR_SHMEM_THPS)),
-			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
-					* HPAGE_PMD_NR),
+			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			K(node_page_state(pgdat, NR_ANON_THPS)),
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
--- a/mm/rmap.c~mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages
+++ a/mm/rmap.c
@@ -1211,14 +1211,17 @@ void page_add_file_rmap(struct page *pag
 	VM_BUG_ON_PAGE(compound && !PageTransHuge(page), page);
 	lock_page_memcg(page);
 	if (compound && PageTransHuge(page)) {
-		for (i = 0, nr = 0; i < thp_nr_pages(page); i++) {
+		int nr_pages = thp_nr_pages(page);
+
+		for (i = 0, nr = 0; i < nr_pages; i++) {
 			if (atomic_inc_and_test(&page[i]._mapcount))
 				nr++;
 		}
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
 		if (PageSwapBacked(page))
-			__inc_node_page_state(page, NR_SHMEM_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
+						nr_pages);
 		else
 			__inc_node_page_state(page, NR_FILE_PMDMAPPED);
 	} else {
@@ -1252,14 +1255,17 @@ static void page_remove_file_rmap(struct
 
 	/* page still mapped by someone else? */
 	if (compound && PageTransHuge(page)) {
-		for (i = 0, nr = 0; i < thp_nr_pages(page); i++) {
+		int nr_pages = thp_nr_pages(page);
+
+		for (i = 0, nr = 0; i < nr_pages; i++) {
 			if (atomic_add_negative(-1, &page[i]._mapcount))
 				nr++;
 		}
 		if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
 			return;
 		if (PageSwapBacked(page))
-			__dec_node_page_state(page, NR_SHMEM_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
+						-nr_pages);
 		else
 			__dec_node_page_state(page, NR_FILE_PMDMAPPED);
 	} else {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch

