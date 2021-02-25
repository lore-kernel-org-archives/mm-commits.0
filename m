Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F16C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABF460201
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhBYTZF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBYTW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D231364F28;
        Thu, 25 Feb 2021 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280448;
        bh=c2r9Y6jerLAWPbJi+A7BFNfrJ1MTdNssJn2H3GRH1wY=;
        h=Date:From:To:Subject:From;
        b=lQTWV5sGDcQ/K1S2M6x07OWGK5SdyMMKF5F4hKXqKS3wQUN7a1XqO1qezCrHDzK7u
         blMn7JhlA0cSqkiMTo+QFoTdc7O35qqs7plJ8pTdWzl3FrDnrH8yrLGFCLSHHllsNw
         hqty/2G3F8zdeqg4PlZIbdRuzpXQfc0wCMoDiVaQ=
Date:   Thu, 25 Feb 2021 11:14:07 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, feng.tang@intel.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        pankaj.gupta@cloud.ionos.com, rafael@kernel.org,
        rdunlap@infradead.org, samitolvanen@google.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch removed from
 -mm tree
Message-ID: <20210225191407.dmNseNh6j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: convert NR_FILE_PMDMAPPED account to pages

Currently we use struct per_cpu_nodestat to cache the vmstat counters,
which leads to inaccurate statistics especially THP vmstat counters.  In
the systems with hundreds of processors it can be GBs of memory.  For
example, for a 96 CPUs system, the threshold is the maximum number of 125.
And the per cpu counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth
of memory in one go) so skipping the batching seems like sensible. 
Although every THP stats update overflows the per-cpu counter, resorting
to atomic global updates.  But it can make the statistics more accuracy
for the THP vmstat counters.

So we convert the NR_FILE_PMDMAPPED account to pages.  This patch is
consistent with 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page
arrival").  Doing this also can make the unit of vmstat counters more
unified.  Finally, the unit of the vmstat counters are pages, kB and
bytes.  The B/KB suffix can tell us that the unit is bytes or kB.  The
rest which is without suffix are pages.

Link: https://lkml.kernel.org/r/20201228164110.2838-7-songmuchun@bytedance.com
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
 mm/rmap.c              |    6 ++++--
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages
+++ a/drivers/base/node.c
@@ -465,8 +465,7 @@ static ssize_t node_read_meminfo(struct
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
-			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED) *
-				    HPAGE_PMD_NR)
+			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED))
 #endif
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
--- a/fs/proc/meminfo.c~mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages
+++ a/fs/proc/meminfo.c
@@ -137,7 +137,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "FileHugePages:  ",
 		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
-		    global_node_page_state(NR_FILE_PMDMAPPED) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_FILE_PMDMAPPED));
 #endif
 
 #ifdef CONFIG_CMA
--- a/include/linux/mmzone.h~mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages
+++ a/include/linux/mmzone.h
@@ -222,7 +222,8 @@ static __always_inline bool vmstat_item_
 	return item == NR_ANON_THPS ||
 	       item == NR_FILE_THPS ||
 	       item == NR_SHMEM_THPS ||
-	       item == NR_SHMEM_PMDMAPPED;
+	       item == NR_SHMEM_PMDMAPPED ||
+	       item == NR_FILE_PMDMAPPED;
 }
 
 /*
--- a/mm/rmap.c~mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages
+++ a/mm/rmap.c
@@ -1223,7 +1223,8 @@ void page_add_file_rmap(struct page *pag
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						nr_pages);
 		else
-			__inc_node_page_state(page, NR_FILE_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_FILE_PMDMAPPED,
+						nr_pages);
 	} else {
 		if (PageTransCompound(page) && page_mapping(page)) {
 			VM_WARN_ON_ONCE(!PageLocked(page));
@@ -1267,7 +1268,8 @@ static void page_remove_file_rmap(struct
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						-nr_pages);
 		else
-			__dec_node_page_state(page, NR_FILE_PMDMAPPED);
+			__mod_lruvec_page_state(page, NR_FILE_PMDMAPPED,
+						-nr_pages);
 	} else {
 		if (!atomic_add_negative(-1, &page->_mapcount))
 			return;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


