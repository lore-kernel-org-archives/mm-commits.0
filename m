From: akpm@linux-foundation.org
Subject: [merged] ocfs2-free-path-in-ocfs2_remove_inode_range.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:45 -0700
Message-ID: <523218f9.EVOmL4OxowOgfM3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [merged] ocfs2-free-path-in-ocfs2_remove_inode_range.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:45 -0700


The patch titled
     Subject: ocfs2: free path in ocfs2_remove_inode_range()
has been removed from the -mm tree.  Its filename was
     ocfs2-free-path-in-ocfs2_remove_inode_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: free path in ocfs2_remove_inode_range()

In ocfs2_remove_inode_range(), there is a memory leak.  The variable path
has allocated memory with ocfs2_new_path_from_et(), but it is not free.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/file.c~ocfs2-free-path-in-ocfs2_remove_inode_range fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-free-path-in-ocfs2_remove_inode_range
+++ a/fs/ocfs2/file.c
@@ -1796,6 +1796,7 @@ static int ocfs2_remove_inode_range(stru
 	ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
 
 out:
+	ocfs2_free_path(path);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &dealloc);
 
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

