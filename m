From: akpm@linux-foundation.org
Subject: + tmpfs-implement-numa-node-interleaving.patch added to -mm tree
Date: Thu, 31 May 2012 12:28:44 -0700
Message-ID: <20120531192844.C9B60A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33873 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2EaT2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:28:46 -0400
Received: by vbnl22 with SMTP id l22so135821vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:28:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, cl@linux.com, hughd@google.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com


The patch titled
     Subject: tmpfs: implement NUMA node interleaving
has been added to the -mm tree.  Its filename is
     tmpfs-implement-numa-node-interleaving.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 +
 mm/shmem.c               |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
@@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
 	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
@@ -1357,6 +1357,7 @@ static struct inode *shmem_get_inode(str
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
 						 shmem_get_sbmpol(sbinfo));
+			info->node_offset = node_random(&node_online_map);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
_
Subject: Subject: tmpfs: implement NUMA node interleaving

Patches currently in -mm which might be from nzimmer@sgi.com are

tmpfs-implement-numa-node-interleaving.patch

