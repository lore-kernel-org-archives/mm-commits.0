From: akpm@linux-foundation.org
Subject: + ocfs2-free-path-in-ocfs2_remove_inode_range.patch added to -mm
 tree
Date: Thu, 08 Aug 2013 15:22:57 -0700
Message-ID: <52041a41.PQAkptyuldhRfBKY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab3HHWW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-free-path-in-ocfs2_remove_inode_range.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:22:57 -0700


The patch titled
     Subject: ocfs2: free path in ocfs2_remove_inode_range()
has been added to the -mm tree.  Its filename is
     ocfs2-free-path-in-ocfs2_remove_inode_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-path-in-ocfs2_remove_inode_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-path-in-ocfs2_remove_inode_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1815,6 +1815,7 @@ static int ocfs2_remove_inode_range(stru
 	ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
 
 out:
+	ocfs2_free_path(path);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &dealloc);
 
_

Patches currently in -mm which might be from younger.liu@huawei.com are

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-free-path-in-ocfs2_remove_inode_range.patch
linux-next.patch

