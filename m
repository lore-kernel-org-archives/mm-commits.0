From: akpm@linux-foundation.org
Subject: + shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch added to -mm tree
Date: Wed, 11 Jul 2012 15:35:58 -0700
Message-ID: <20120711223559.BBB015C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48136 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2GKWgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 18:36:02 -0400
Received: by fat25 with SMTP id 25so85170fat.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 15:36:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, cl@linux.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com


The patch titled
     Subject: shmem: provide vm_ops when also providing a mem policy
has been added to the -mm tree.  Its filename is
     shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch

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
@@ -930,8 +930,11 @@ static struct page *shmem_swapin(swp_ent
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = spol;
+	if (pvma.vm_policy)
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 	return swapin_readahead(swap, gfp, &pvma, 0);
 }
 
@@ -943,8 +946,11 @@ static struct page *shmem_alloc_page(gfp
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
-	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+	if (pvma.vm_policy)
+		pvma.vm_ops = &shmem_vm_ops;
+	else
+		pvma.vm_ops = NULL;
 
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
@@ -1311,8 +1317,14 @@ static int shmem_set_policy(struct vm_ar
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
Subject: Subject: shmem: provide vm_ops when also providing a mem policy

Patches currently in -mm which might be from nzimmer@sgi.com are

shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch

