From: akpm@linux-foundation.org
Subject: + tmpfs-interleave-the-starting-node-of-dev-shmem.patch added to -mm tree
Date: Wed, 11 Jul 2012 15:36:03 -0700
Message-ID: <20120711223604.BE1E1200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44164 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030355Ab2GKWgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 18:36:10 -0400
Received: by lbbgp10 with SMTP id gp10so103976lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 15:36:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, cl@linux.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@gmail.com, riel@redhat.com


The patch titled
     Subject: tmpfs: interleave the starting node of /dev/shmem
has been added to the -mm tree.  Its filename is
     tmpfs-interleave-the-starting-node-of-dev-shmem.patch

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
Subject: tmpfs: interleave the starting node of /dev/shmem

The tmpfs superblock grants an offset for each inode as they are created. 
Each inode then uses that offset to provide a preferred first node for its
interleave in the newly provided shmem_interleave.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    7 +++++++
 include/linux/shmem_fs.h |    3 +++
 mm/mempolicy.c           |    4 ++++
 mm/shmem.c               |   17 +++++++++++++++++
 4 files changed, 31 insertions(+)

diff -puN include/linux/mm.h~tmpfs-interleave-the-starting-node-of-dev-shmem include/linux/mm.h
--- a/include/linux/mm.h~tmpfs-interleave-the-starting-node-of-dev-shmem
+++ a/include/linux/mm.h
@@ -238,6 +238,13 @@ struct vm_operations_struct {
 	 */
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr);
+
+	/*
+	 * If the policy is interleave allow the vma to suggest a node.
+	 */
+	unsigned long (*interleave)(struct vm_area_struct *vma,
+					unsigned long addr);
+
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
diff -puN include/linux/shmem_fs.h~tmpfs-interleave-the-starting-node-of-dev-shmem include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-interleave-the-starting-node-of-dev-shmem
+++ a/include/linux/shmem_fs.h
@@ -17,6 +17,7 @@ struct shmem_inode_info {
 		char		*symlink;	/* unswappable short symlink */
 	};
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
+	unsigned long           node_offset;	/* bias for interleaved nodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
@@ -32,6 +33,8 @@ struct shmem_sb_info {
 	kgid_t gid;		    /* Mount gid for root directory */
 	umode_t mode;		    /* Mount mode for root directory */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
+	unsigned long next_pref_node;
+			 /* next interleave bias to suggest for inodes */
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
diff -puN mm/mempolicy.c~tmpfs-interleave-the-starting-node-of-dev-shmem mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-interleave-the-starting-node-of-dev-shmem
+++ a/mm/mempolicy.c
@@ -1769,6 +1769,10 @@ static inline unsigned interleave_nid(st
 {
 	if (vma) {
 		unsigned long off;
+		if (vma->vm_ops && vma->vm_ops->interleave) {
+			off = vma->vm_ops->interleave(vma, addr);
+			return offset_il_node(pol, vma, off);
+		}
 
 		/*
 		 * for small pages, there is no difference between
diff -puN mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem mm/shmem.c
--- a/mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem
+++ a/mm/shmem.c
@@ -931,6 +931,7 @@ static struct page *shmem_swapin(swp_ent
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
 	pvma.vm_policy = spol;
+	pvma.vm_private_data = (void *) info->node_offset;
 	if (pvma.vm_policy)
 		pvma.vm_ops = &shmem_vm_ops;
 	else
@@ -947,6 +948,7 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+	pvma.vm_private_data = (void *) info->node_offset;
 	if (pvma.vm_policy)
 		pvma.vm_ops = &shmem_vm_ops;
 	else
@@ -1329,6 +1331,19 @@ static struct mempolicy *shmem_get_polic
 	index = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	return mpol_shared_policy_lookup(&SHMEM_I(inode)->policy, index);
 }
+
+static unsigned long shmem_interleave(struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	unsigned long offset;
+
+	/* Use the vm_files prefered node as the initial offset. */
+	offset = (unsigned long *) vma->vm_private_data;
+
+	offset += ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+
+	return offset;
+}
 #endif
 
 int shmem_lock(struct file *file, int lock, struct user_struct *user)
@@ -1401,6 +1416,7 @@ static struct inode *shmem_get_inode(str
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
 						 shmem_get_sbmpol(sbinfo));
+			info->node_offset = ++(sbinfo->next_pref_node);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -2795,6 +2811,7 @@ static const struct super_operations shm
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
 #ifdef CONFIG_NUMA
+	.interleave	= shmem_interleave,
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
_
Subject: Subject: tmpfs: interleave the starting node of /dev/shmem

Patches currently in -mm which might be from nzimmer@sgi.com are

shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch

