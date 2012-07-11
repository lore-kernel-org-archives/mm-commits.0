From: akpm@linux-foundation.org
Subject: [to-be-updated] tmpfs-implement-numa-node-interleaving.patch removed from -mm tree
Date: Wed, 11 Jul 2012 15:33:33 -0700
Message-ID: <20120711223333.CDFFA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47870 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2GKWdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 18:33:38 -0400
Received: by qcqs25 with SMTP id s25so178090qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 15:33:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, cl@linux.com, hughd@google.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: implement NUMA node interleaving
has been removed from the -mm tree.  Its filename was
     tmpfs-implement-numa-node-interleaving.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: tmpfs: implement NUMA node interleaving

When tmpfs has the memory policy interleaved it always starts allocating
at each file at node 0.  When there are many small files the lower nodes
fill up disproportionately.

This patch attempts to spread out node usage by starting files at nodes
other then 0.  I disturbed the addr parameter since alloc_pages_vma will
only use it when the policy is MPOL_INTERLEAVE.  Random was picked over
using another variable which would require some sort of contention
management.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 +
 mm/shmem.c               |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-implement-numa-node-interleaving include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-implement-numa-node-interleaving
+++ a/include/linux/shmem_fs.h
@@ -17,6 +17,7 @@ struct shmem_inode_info {
 		char		*symlink;	/* unswappable short symlink */
 	};
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
+	unsigned long           node_offset;	/* bias for interleaved nodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
diff -puN mm/shmem.c~tmpfs-implement-numa-node-interleaving mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-numa-node-interleaving
+++ a/mm/shmem.c
@@ -947,9 +947,12 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
 	/*
-	 * alloc_page_vma() will drop the shared policy reference
+	 * alloc_page_vma() will drop the shared policy reference.
+	 *
+	 * To avoid allocating all tmpfs pages on node 0, we fake up a virtual
+	 * address based on this file's predetermined preferred node.
 	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
@@ -1389,6 +1392,7 @@ static struct inode *shmem_get_inode(str
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
 						 shmem_get_sbmpol(sbinfo));
+			info->node_offset = node_random(&node_online_map);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
_

Patches currently in -mm which might be from nzimmer@sgi.com are


