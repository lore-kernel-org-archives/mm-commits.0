From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-memalloc_nofs_save-instead-of-memalloc_noio_save.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:35:41 -0700
Message-ID: <20200403203541.59orC1Nwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, willy@infradead.org


The patch titled
     Subject: ocfs2: use memalloc_nofs_save instead of memalloc_noio_save
has been removed from the -mm tree.  Its filename was
     ocfs2-use-memalloc_nofs_save-instead-of-memalloc_noio_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ocfs2: use memalloc_nofs_save instead of memalloc_noio_save

OCFS2 doesn't mind if memory reclaim makes I/Os happen; it just cares that
it won't be reentered, so it can use memalloc_nofs_save() instead of
memalloc_noio_save().

Link: http://lkml.kernel.org/r/20200326200214.1102-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/fs/ocfs2/cluster/tcp.c~ocfs2-use-memalloc_nofs_save-instead-of-memalloc_noio_save
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1570,15 +1570,13 @@ static void o2net_start_connect(struct w
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
 	unsigned int timeout;
-	unsigned int noio_flag;
+	unsigned int nofs_flag;
 
 	/*
-	 * sock_create allocates the sock with GFP_KERNEL. We must set
-	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
-	 * by this process are done as if GFP_NOIO was specified. So we
-	 * are not reentering filesystem while doing memory reclaim.
+	 * sock_create allocates the sock with GFP_KERNEL. We must
+	 * prevent the filesystem from being reentered by memory reclaim.
 	 */
-	noio_flag = memalloc_noio_save();
+	nofs_flag = memalloc_nofs_save();
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
 		goto out;
@@ -1683,7 +1681,7 @@ out:
 	if (mynode)
 		o2nm_node_put(mynode);
 
-	memalloc_noio_restore(noio_flag);
+	memalloc_nofs_restore(nofs_flag);
 	return;
 }
 
@@ -1810,15 +1808,13 @@ static int o2net_accept_one(struct socke
 	struct o2nm_node *local_node = NULL;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
-	unsigned int noio_flag;
+	unsigned int nofs_flag;
 
 	/*
-	 * sock_create_lite allocates the sock with GFP_KERNEL. We must set
-	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
-	 * by this process are done as if GFP_NOIO was specified. So we
-	 * are not reentering filesystem while doing memory reclaim.
+	 * sock_create_lite allocates the sock with GFP_KERNEL. We must
+	 * prevent the filesystem from being reentered by memory reclaim.
 	 */
-	noio_flag = memalloc_noio_save();
+	nofs_flag = memalloc_nofs_save();
 
 	BUG_ON(sock == NULL);
 	*more = 0;
@@ -1934,7 +1930,7 @@ out:
 	if (sc)
 		sc_put(sc);
 
-	memalloc_noio_restore(noio_flag);
+	memalloc_nofs_restore(nofs_flag);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
