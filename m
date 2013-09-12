From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:37 -0700
Message-ID: <523218f1.diqGKekyqOvgC/Zs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liu@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,younger.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:37 -0700


The patch titled
     Subject: ocfs2: fix a memory leak in __ocfs2_move_extents()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix a memory leak in __ocfs2_move_extents()

The ocfs2 path is not properly freed which leads to a memory leak at
__ocfs2_move_extents().

This patch stops the leaks of the ocfs2_path structure.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Younger Liu <younger.liu@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -152,6 +152,7 @@ static int __ocfs2_move_extent(handle_t
 	}
 
 out:
+	ocfs2_free_path(path);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch

