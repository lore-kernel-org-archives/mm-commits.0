From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:57 -0800
Message-ID: <563d0825.ejMLMSHtikFbb/Zw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033483AbbKFUF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up unused variable in ocfs2_duplicate_clusters_by_page()
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-unused-variable-in-ocfs2_duplicate_clusters_by_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

