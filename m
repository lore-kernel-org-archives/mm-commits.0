From: akpm@linux-foundation.org
Subject: - mempolicy-support-optional-mode-flags.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:26 -0700
Message-ID: <200804282151.m3SLpQXG017577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965034AbYD1VwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, hugh@veritas.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: support optional mode flags
has been removed from the -mm tree.  Its filename was
     mempolicy-support-optional-mode-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: support optional mode flags
From: David Rientjes <rientjes@google.com>

With the evolution of mempolicies, it is necessary to support mempolicy mode
flags that specify how the policy shall behave in certain circumstances.  The
most immediate need for mode flag support is to suppress remapping the
nodemask of a policy at the time of rebind.

Both the mempolicy mode and flags are passed by the user in the 'int policy'
formal of either the set_mempolicy() or mbind() syscall.  A new constant,
MPOL_MODE_FLAGS, represents the union of legal optional flags that may be
passed as part of this int.  Mempolicies that include illegal flags as part of
their policy are rejected as invalid.

An additional member to struct mempolicy is added to support the mode flags:

	struct mempolicy {
		...
		unsigned short policy;
		unsigned short flags;
	}

The splitting of the 'int' actual passed by the user is done in
sys_set_mempolicy() and sys_mbind() for their respective syscalls.  This is
done by intersecting the actual with MPOL_MODE_FLAGS, rejecting the syscall of
there are additional flags, and storing it in the new 'flags' member of struct
mempolicy.  The intersection of the actual with ~MPOL_MODE_FLAGS is stored in
the 'policy' member of the struct and all current users of pol->policy remain
unchanged.

The union of the policy mode and optional mode flags is passed back to the
user in get_mempolicy().

This combination of mode and flags within the same actual does not break
userspace code that relies on get_mempolicy(&policy, ...) and either

	switch (policy) {
	case MPOL_BIND:
		...
	case MPOL_INTERLEAVE:
		...
	};

statements or

	if (policy == MPOL_INTERLEAVE) {
		...
	}

statements.  Such applications would need to use optional mode flags when
calling set_mempolicy() or mbind() for these previously implemented statements
to stop working.  If an application does start using optional mode flags, it
will need to mask the optional flags off the policy in switch and conditional
statements that only test mode.

An additional member is also added to struct shmem_sb_info to store the
optional mode flags.

[hugh@veritas.com: shmem mpol: fix build warning]
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c      |    2 -
 include/linux/mempolicy.h |   20 ++++++++++++--
 include/linux/shmem_fs.h  |    1 
 mm/mempolicy.c            |   51 +++++++++++++++++++++---------------
 mm/shmem.c                |   24 +++++++++++-----
 5 files changed, 66 insertions(+), 32 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mempolicy-support-optional-mode-flags fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mempolicy-support-optional-mode-flags
+++ a/fs/hugetlbfs/inode.c
@@ -504,7 +504,7 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
-		mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, NULL);
+		mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0, NULL);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff -puN include/linux/mempolicy.h~mempolicy-support-optional-mode-flags include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-support-optional-mode-flags
+++ a/include/linux/mempolicy.h
@@ -8,6 +8,12 @@
  * Copyright 2003,2004 Andi Kleen SuSE Labs
  */
 
+/*
+ * Both the MPOL_* mempolicy mode and the MPOL_F_* optional mode flags are
+ * passed by the user to either set_mempolicy() or mbind() in an 'int' actual.
+ * The MPOL_MODE_FLAGS macro determines the legal set of optional mode flags.
+ */
+
 /* Policies */
 enum {
 	MPOL_DEFAULT,
@@ -17,7 +23,14 @@ enum {
 	MPOL_MAX,	/* always last member of enum */
 };
 
-/* Flags for get_mem_policy */
+/* Flags for set_mempolicy */
+/*
+ * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
+ * either set_mempolicy() or mbind().
+ */
+#define MPOL_MODE_FLAGS	(0)
+
+/* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
 #define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
@@ -66,6 +79,7 @@ struct mm_struct;
 struct mempolicy {
 	atomic_t refcnt;
 	unsigned short policy; 	/* See MPOL_* above */
+	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	union {
 		short 		 preferred_node; /* preferred */
 		nodemask_t	 nodes;		/* interleave/bind */
@@ -136,7 +150,7 @@ struct shared_policy {
 };
 
 void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
-				nodemask_t *nodes);
+				unsigned short flags, nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
 				struct mempolicy *new);
@@ -203,7 +217,7 @@ static inline int mpol_set_shared_policy
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-				unsigned short policy, nodemask_t *nodes)
+		unsigned short policy, unsigned short flags, nodemask_t *nodes)
 {
 }
 
diff -puN include/linux/shmem_fs.h~mempolicy-support-optional-mode-flags include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mempolicy-support-optional-mode-flags
+++ a/include/linux/shmem_fs.h
@@ -35,6 +35,7 @@ struct shmem_sb_info {
 	gid_t gid;		    /* Mount gid for root directory */
 	mode_t mode;		    /* Mount mode for root directory */
 	unsigned short policy;	    /* Default NUMA memory alloc policy */
+	unsigned short flags;	    /* Optional mempolicy flags */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
 };
 
diff -puN mm/mempolicy.c~mempolicy-support-optional-mode-flags mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-support-optional-mode-flags
+++ a/mm/mempolicy.c
@@ -187,12 +187,13 @@ static int is_valid_nodemask(nodemask_t 
 }
 
 /* Create a new policy */
-static struct mempolicy *mpol_new(unsigned short mode, nodemask_t *nodes)
+static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
+				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 
-	pr_debug("setting mode %d nodes[0] %lx\n",
-		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
+	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
+		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
 	if (mode == MPOL_DEFAULT)
 		return NULL;
@@ -224,6 +225,7 @@ static struct mempolicy *mpol_new(unsign
 		BUG();
 	}
 	policy->policy = mode;
+	policy->flags = flags;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
 	return policy;
 }
@@ -466,13 +468,14 @@ static void mpol_set_task_struct_flag(vo
 }
 
 /* Set the process memory policy */
-static long do_set_mempolicy(unsigned short mode, nodemask_t *nodes)
+static long do_set_mempolicy(unsigned short mode, unsigned short flags,
+			     nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
 	if (mpol_check_policy(mode, nodes))
 		return -EINVAL;
-	new = mpol_new(mode, nodes);
+	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 	mpol_free(current->mempolicy);
@@ -573,7 +576,7 @@ static long do_get_mempolicy(int *policy
 			goto out;
 		}
 	} else
-		*policy = pol->policy;
+		*policy = pol->policy | pol->flags;
 
 	if (vma) {
 		up_read(&current->mm->mmap_sem);
@@ -763,8 +766,8 @@ static struct page *new_vma_page(struct 
 #endif
 
 static long do_mbind(unsigned long start, unsigned long len,
-		     unsigned short mode, nodemask_t *nmask,
-		     unsigned long flags)
+		     unsigned short mode, unsigned short mode_flags,
+		     nodemask_t *nmask, unsigned long flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -796,7 +799,7 @@ static long do_mbind(unsigned long start
 	if (mpol_check_policy(mode, nmask))
 		return -EINVAL;
 
-	new = mpol_new(mode, nmask);
+	new = mpol_new(mode, mode_flags, nmask);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
@@ -807,8 +810,9 @@ static long do_mbind(unsigned long start
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%d nodes:%lx\n", start, start + len,
-		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
+	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
+		 start, start + len, mode, mode_flags,
+		 nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
 	vma = check_range(mm, start, end, nmask,
@@ -907,13 +911,16 @@ asmlinkage long sys_mbind(unsigned long 
 {
 	nodemask_t nodes;
 	int err;
+	unsigned short mode_flags;
 
+	mode_flags = mode & MPOL_MODE_FLAGS;
+	mode &= ~MPOL_MODE_FLAGS;
 	if (mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_mbind(start, len, mode, &nodes, flags);
+	return do_mbind(start, len, mode, mode_flags, &nodes, flags);
 }
 
 /* Set the process memory policy */
@@ -922,13 +929,16 @@ asmlinkage long sys_set_mempolicy(int mo
 {
 	int err;
 	nodemask_t nodes;
+	unsigned short flags;
 
-	if (mode < 0 || mode >= MPOL_MAX)
+	flags = mode & MPOL_MODE_FLAGS;
+	mode &= ~MPOL_MODE_FLAGS;
+	if ((unsigned int)mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-	return do_set_mempolicy(mode, &nodes);
+	return do_set_mempolicy(mode, flags, &nodes);
 }
 
 asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
@@ -1641,7 +1651,7 @@ restart:
 }
 
 void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
-				nodemask_t *policy_nodes)
+			unsigned short flags, nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
 	spin_lock_init(&info->lock);
@@ -1650,7 +1660,7 @@ void mpol_shared_policy_init(struct shar
 		struct mempolicy *newpol;
 
 		/* Falls back to MPOL_DEFAULT on any error */
-		newpol = mpol_new(policy, policy_nodes);
+		newpol = mpol_new(policy, flags, policy_nodes);
 		if (!IS_ERR(newpol)) {
 			/* Create pseudo-vma that contains just the policy */
 			struct vm_area_struct pvma;
@@ -1671,9 +1681,10 @@ int mpol_set_shared_policy(struct shared
 	struct sp_node *new = NULL;
 	unsigned long sz = vma_pages(vma);
 
-	pr_debug("set_shared_policy %lx sz %lu %d %lx\n",
+	pr_debug("set_shared_policy %lx sz %lu %d %d %lx\n",
 		 vma->vm_pgoff,
-		 sz, npol? npol->policy : -1,
+		 sz, npol ? npol->policy : -1,
+		 npol ? npol->flags : -1,
 		 npol ? nodes_addr(npol->v.nodes)[0] : -1);
 
 	if (npol) {
@@ -1746,14 +1757,14 @@ void __init numa_policy_init(void)
 	if (unlikely(nodes_empty(interleave_nodes)))
 		node_set(prefer, interleave_nodes);
 
-	if (do_set_mempolicy(MPOL_INTERLEAVE, &interleave_nodes))
+	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
 		printk("numa_policy_init: interleaving failed\n");
 }
 
 /* Reset policy of current process to default */
 void numa_default_policy(void)
 {
-	do_set_mempolicy(MPOL_DEFAULT, NULL);
+	do_set_mempolicy(MPOL_DEFAULT, 0, NULL);
 }
 
 /* Migrate a policy to a different set of nodes */
diff -puN mm/shmem.c~mempolicy-support-optional-mode-flags mm/shmem.c
--- a/mm/shmem.c~mempolicy-support-optional-mode-flags
+++ a/mm/shmem.c
@@ -1080,9 +1080,10 @@ redirty:
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
 static int shmem_parse_mpol(char *value, unsigned short *policy,
-			    nodemask_t *policy_nodes)
+			unsigned short *mode_flags, nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
+	char *flags = strchr(value, '=');
 	int err = 1;
 
 	if (nodelist) {
@@ -1093,6 +1094,8 @@ static int shmem_parse_mpol(char *value,
 		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
 			goto out;
 	}
+	if (flags)
+		*flags++ = '\0';
 	if (!strcmp(value, "default")) {
 		*policy = MPOL_DEFAULT;
 		/* Don't allow a nodelist */
@@ -1122,6 +1125,8 @@ static int shmem_parse_mpol(char *value,
 			*policy_nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
 	}
+	if (flags) {
+	}
 out:
 	/* Restore string for error message */
 	if (nodelist)
@@ -1130,7 +1135,7 @@ out:
 }
 
 static void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			    const nodemask_t policy_nodes)
+			unsigned short flags, const nodemask_t policy_nodes)
 {
 	char *policy_string;
 
@@ -1199,13 +1204,13 @@ static struct page *shmem_alloc_page(gfp
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-						nodemask_t *policy_nodes)
+			unsigned short *mode_flags, nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
 static inline void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			    const nodemask_t policy_nodes)
+			unsigned short flags, const nodemask_t policy_nodes)
 {
 }
 #endif /* CONFIG_TMPFS */
@@ -1578,7 +1583,7 @@ shmem_get_inode(struct super_block *sb, 
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy, sbinfo->policy,
-							&sbinfo->policy_nodes);
+					sbinfo->flags, &sbinfo->policy_nodes);
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -1592,7 +1597,7 @@ shmem_get_inode(struct super_block *sb, 
 			 * Must not load anything in the rbtree,
 			 * mpol_free_shared_policy will not be called.
 			 */
-			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT,
+			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0,
 						NULL);
 			break;
 		}
@@ -2209,7 +2214,7 @@ static int shmem_parse_options(char *opt
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
 			if (shmem_parse_mpol(value, &sbinfo->policy,
-					     &sbinfo->policy_nodes))
+				&sbinfo->flags, &sbinfo->policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2261,6 +2266,7 @@ static int shmem_remount_fs(struct super
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 	sbinfo->policy      = config.policy;
+	sbinfo->flags	    = config.flags;
 	sbinfo->policy_nodes = config.policy_nodes;
 out:
 	spin_unlock(&sbinfo->stat_lock);
@@ -2282,7 +2288,8 @@ static int shmem_show_options(struct seq
 		seq_printf(seq, ",uid=%u", sbinfo->uid);
 	if (sbinfo->gid != 0)
 		seq_printf(seq, ",gid=%u", sbinfo->gid);
-	shmem_show_mpol(seq, sbinfo->policy, sbinfo->policy_nodes);
+	shmem_show_mpol(seq, sbinfo->policy, sbinfo->flags,
+			sbinfo->policy_nodes);
 	return 0;
 }
 #endif /* CONFIG_TMPFS */
@@ -2313,6 +2320,7 @@ static int shmem_fill_super(struct super
 	sbinfo->uid = current->fsuid;
 	sbinfo->gid = current->fsgid;
 	sbinfo->policy = MPOL_DEFAULT;
+	sbinfo->flags = 0;
 	sbinfo->policy_nodes = node_states[N_HIGH_MEMORY];
 	sb->s_fs_info = sbinfo;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch

