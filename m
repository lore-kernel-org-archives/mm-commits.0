From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-deletion-of-unnecessary-checks-before-three-function-calls.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:50 -0700
Message-ID: <552eb706.IWN59xFzcXs4enlX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbbDOTHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delete unnecessary checks before three function calls
has been removed from the -mm tree.  Its filename was
     ocfs2-deletion-of-unnecessary-checks-before-three-function-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: delete unnecessary checks before three function calls

kfree(), ocfs2_free_path() and __ocfs2_free_slot_info() test whether their
argument is NULL and then return immediately.  Thus the test around their
calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c      |   17 +++++------------
 fs/ocfs2/slot_map.c   |    2 +-
 fs/ocfs2/stack_user.c |    2 +-
 3 files changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls
+++ a/fs/ocfs2/alloc.c
@@ -3453,8 +3453,7 @@ static int ocfs2_merge_rec_right(struct
 					   subtree_index);
 	}
 out:
-	if (right_path)
-		ocfs2_free_path(right_path);
+	ocfs2_free_path(right_path);
 	return ret;
 }
 
@@ -3647,8 +3646,7 @@ static int ocfs2_merge_rec_left(struct o
 						   right_path, subtree_index);
 	}
 out:
-	if (left_path)
-		ocfs2_free_path(left_path);
+	ocfs2_free_path(left_path);
 	return ret;
 }
 
@@ -4431,11 +4429,8 @@ ocfs2_figure_merge_contig_type(struct oc
 	}
 
 out:
-	if (left_path)
-		ocfs2_free_path(left_path);
-	if (right_path)
-		ocfs2_free_path(right_path);
-
+	ocfs2_free_path(left_path);
+	ocfs2_free_path(right_path);
 	return ret;
 }
 
@@ -6996,9 +6991,7 @@ out_commit:
 out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-	if (pages)
-		kfree(pages);
-
+	kfree(pages);
 	return ret;
 }
 
diff -puN fs/ocfs2/slot_map.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls
+++ a/fs/ocfs2/slot_map.c
@@ -452,7 +452,7 @@ int ocfs2_init_slot_info(struct ocfs2_su
 
 	osb->slot_info = (struct ocfs2_slot_info *)si;
 bail:
-	if (status < 0 && si)
+	if (status < 0)
 		__ocfs2_free_slot_info(si);
 
 	return status;
diff -puN fs/ocfs2/stack_user.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-deletion-of-unnecessary-checks-before-three-function-calls
+++ a/fs/ocfs2/stack_user.c
@@ -1063,7 +1063,7 @@ static int user_cluster_connect(struct o
 	}
 
 out:
-	if (rc && lc)
+	if (rc)
 		kfree(lc);
 	return rc;
 }
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch

