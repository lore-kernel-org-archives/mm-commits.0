From: akpm@linux-foundation.org
Subject: [obsolete] shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch removed from -mm tree
Date: Wed, 25 Jul 2012 12:58:38 -0700
Message-ID: <20120725195839.8070920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65038 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2GYT6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 15:58:42 -0400
Received: by eaao12 with SMTP id o12so4190eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 12:58:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, cl@linux.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: provide vm_ops when also providing a mem policy
has been removed from the -mm tree.  Its filename was
     shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: shmem: provide vm_ops when also providing a mem policy

When tmpfs has the memory policy interleaved it always starts allocating
for each file at node 0.  When there are many small files the lower nodes
fill up disproportionately.

This patchset spreads out node usage by starting files at nodes other then
0.  The tmpfs superblock grants an offset for each inode as they are
created.  Each then uses that offset to proved a prefered first node for
its interleave in the shmem_interleave.


This patch:

Update shmem_get_policy() to use the vma_policy if provided.  This is to
allows us to safely provide shmem_vm_ops to the vma when the vm_file has
not been setup which is the case on the pseudo vmas.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/shmem.c~shmem-provide-vm_ops-when-also-providing-a-mem-policy mm/shmem.c
--- a/mm/shmem.c~shmem-provide-vm_ops-when-also-providing-a-mem-policy
+++ a/mm/shmem.c
@@ -931,8 +931,11 @@ static struct page *shmem_swapin(swp_ent
 	pvma.vm_start = 0;
 	/* Bias interleave by inode number to distribute better across nodes */
 	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = spol;
+	if (pvma.vm_policy)
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 	return swapin_readahead(swap, gfp, &pvma, 0);
 }
 
@@ -945,8 +948,11 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_start = 0;
 	/* Bias interleave by inode number to distribute better across nodes */
 	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+	if (pvma.vm_policy)
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
@@ -1313,8 +1319,14 @@ static int shmem_set_policy(struct vm_ar
 static struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
 					  unsigned long addr)
 {
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	pgoff_t index;
+	struct inode *inode;
+
+	/* If the vma knows what policy it wants use that one. */
+	if (vma->vm_policy)
+		return vma->vm_policy;
+
+	inode = vma->vm_file->f_path.dentry->d_inode;
 
 	index = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	return mpol_shared_policy_lookup(&SHMEM_I(inode)->policy, index);
_

Patches currently in -mm which might be from nzimmer@sgi.com are

tmpfs-distribute-interleave-better-across-nodes.patch

