From: akpm@linux-foundation.org
Subject: +
 memcg-optimize-memorynuma_stat-like-memorystat-fix.patch added to -mm tree
Date: Thu, 05 Mar 2020 20:41:42 -0800
Message-ID: <20200306044142.9OI5BdMD7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgCFEln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 23:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: memcg-optimize-memorynuma_stat-like-memorystat-fix
has been added to the -mm tree.  Its filename is
     memcg-optimize-memorynuma_stat-like-memorystat-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-optimize-memorynuma_stat-like-memorystat-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-optimize-memorynuma_stat-like-memorystat-fix

avoid forcing out-of-line code generation

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat-fix
+++ a/mm/memcontrol.c
@@ -3658,17 +3658,16 @@ static unsigned long mem_cgroup_node_nr_
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct lruvec *lruvec,
-				    enum node_stat_item idx);
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
-	page_state = tree ? lruvec_page_state : lruvec_page_state_local;
-
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(lruvec, NR_LRU_BASE + lru);
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3679,14 +3678,14 @@ static unsigned long mem_cgroup_nr_lru_p
 {
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct mem_cgroup *memcg, int idx);
-
-	page_state = tree ? memcg_page_state : memcg_page_state_local;
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(memcg, NR_LRU_BASE + lru);
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
