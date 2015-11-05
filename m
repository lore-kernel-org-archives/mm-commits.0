From: akpm@linux-foundation.org
Subject: +
 ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:37:07 -0800
Message-ID: <563b3153.mbqlqTkXqnI3OFr0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084AbbKEKhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up unused variable in ocfs2_duplicate_clusters_by_page()
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: clean up unused variable in ocfs2_duplicate_clusters_by_page()

readahead_pages in ocfs2_duplicate_clusters_by_page is defined but not
used, so clean it up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2920,16 +2920,13 @@ int ocfs2_duplicate_clusters_by_page(han
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
-	unsigned int from, to, readahead_pages;
+	unsigned int from, to;
 	loff_t offset, end, map_end;
 	struct address_space *mapping = inode->i_mapping;
 
 	trace_ocfs2_duplicate_clusters_by_page(cpos, old_cluster,
 					       new_cluster, new_len);
 
-	readahead_pages =
-		(ocfs2_cow_contig_clusters(sb) <<
-		 OCFS2_SB(sb)->s_clustersize_bits) >> PAGE_CACHE_SHIFT;
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
 	/*
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-improve-performance-for-localalloc.patch
ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch
ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
ocfs2-fix-race-between-mount-and-delete-node-cluster.patch
ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis.patch
ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

