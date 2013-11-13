From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:33 -0800
Message-ID: <5283e30d.in25KuVVZUuSgpxe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:33 -0800


The patch titled
     Subject: ocfs2: fix possible double free in ocfs2_write_begin_nolock
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix possible double free in ocfs2_write_begin_nolock

When ocfs2_write_cluster_by_desc() failed in ocfs2_write_begin_nolock()
because of ENOSPC, it goes to out_quota, freeing data_ac(meta_ac).  Then
it calls ocfs2_try_to_free_truncate_log() to free space.  If enough space
freed, it will try to write again.  Unfortunately, some error happenes
before ocfs2_lock_allocators(), it goes to out and free data_ac(meta_ac)
again.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-possible-double-free-in-ocfs2_write_begin_nolock
+++ a/fs/ocfs2/aops.c
@@ -1898,10 +1898,14 @@ out_commit:
 out:
 	ocfs2_free_write_ctxt(wc);
 
-	if (data_ac)
+	if (data_ac) {
 		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
+		data_ac = NULL;
+	}
+	if (meta_ac) {
 		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
 
 	if (ret == -ENOSPC && try_free) {
 		/*
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch

