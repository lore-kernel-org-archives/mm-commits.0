From: akpm@linux-foundation.org
Subject: - mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:41 -0700
Message-ID: <200804282153.m3SLrfmO017912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934913AbYD1VyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: use struct mempolicy pointer in shmem_sb_info
has been removed from the -mm tree.  Its filename was
     mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: use struct mempolicy pointer in shmem_sb_info
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch replaces the mempolicy mode, mode_flags, and nodemask in the
shmem_sb_info struct with a struct mempolicy pointer, initialized to NULL. 
This removes dependency on the details of mempolicy from shmem.c and hugetlbfs
inode.c and simplifies the interfaces.

mpol_parse_str() in mempolicy.c is changed to return, via a pointer to a
pointer arg, a struct mempolicy pointer on success.  For MPOL_DEFAULT, the
returned pointer is NULL.  Further, mpol_parse_str() now takes a 'no_context'
argument that causes the input nodemask to be stored in the w.user_nodemask of
the created mempolicy for use when the mempolicy is installed in a tmpfs inode
shared policy tree.  At that time, any cpuset contextualization is applied to
the original input nodemask.  This preserves the previous behavior where the
input nodemask was stored in the superblock.  We can think of the returned
mempolicy as "context free".

Because mpol_parse_str() is now calling mpol_new(), we can remove from
mpol_to_str() the semantic checks that mpol_new() already performs.

Add 'no_context' parameter to mpol_to_str() to specify that it should format
the nodemask in w.user_nodemask for 'bind' and 'interleave' policies.

Change mpol_shared_policy_init() to take a pointer to a "context free" struct
mempolicy and to create a new, "contextualized" mempolicy using the mode,
mode_flags and user_nodemask from the input mempolicy.

  Note: we know that the mempolicy passed to mpol_to_str() or
  mpol_shared_policy_init() from a tmpfs superblock is "context free".  This
  is currently the only instance thereof.  However, if we found more uses for
  this concept, and introduced any ambiguity as to whether a mempolicy was
  context free or not, we could add another internal mode flag to identify
  context free mempolicies.  Then, we could remove the 'no_context' argument
  from mpol_to_str().

Added shmem_get_sbmpol() to return a reference counted superblock mempolicy,
if one exists, to pass to mpol_shared_policy_init().  We must add the
reference under the sb stat_lock to prevent races with replacement of the mpol
by remount.  This reference is removed in mpol_shared_policy_init().

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: another build fix]
[akpm@linux-foundation.org: yet another build fix]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c      |    2 
 include/linux/mempolicy.h |   22 ++---
 include/linux/shmem_fs.h  |    4 -
 mm/mempolicy.c            |  140 ++++++++++++++++++++++--------------
 mm/shmem.c                |   57 ++++++++------
 5 files changed, 132 insertions(+), 93 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info
+++ a/fs/hugetlbfs/inode.c
@@ -504,7 +504,7 @@ static struct inode *hugetlbfs_get_inode
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
-		mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0, NULL);
+		mpol_shared_policy_init(&info->policy, NULL);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff -puN include/linux/mempolicy.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info
+++ a/include/linux/mempolicy.h
@@ -182,8 +182,7 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
-void mpol_shared_policy_init(struct shared_policy *info, unsigned short mode,
-				unsigned short flags, nodemask_t *nodes);
+void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
 				struct mempolicy *new);
@@ -216,10 +215,10 @@ int do_migrate_pages(struct mm_struct *m
 
 
 #ifdef CONFIG_TMPFS
-extern int mpol_parse_str(char *str, unsigned short *mode,
-			unsigned short *mode_flags, nodemask_t *policy_nodes);
+extern int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context);
 
-extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol);
+extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
+			int no_context);
 #endif
 #else
 
@@ -262,8 +261,8 @@ static inline int mpol_set_shared_policy
 	return -EINVAL;
 }
 
-static inline void mpol_shared_policy_init(struct shared_policy *info,
-		unsigned short mode, unsigned short flags, nodemask_t *nodes)
+static inline void mpol_shared_policy_init(struct shared_policy *sp,
+						struct mempolicy *mpol)
 {
 }
 
@@ -322,13 +321,14 @@ static inline void check_highest_zone(in
 }
 
 #ifdef CONFIG_TMPFS
-static inline int mpol_parse_str(char *value, unsigned short *policy,
-				unsigned short flags, nodemask_t *policy_nodes)
+static inline int mpol_parse_str(char *str, struct mempolicy **mpol,
+				int no_context)
 {
-	return 1;
+	return 1;	/* error */
 }
 
-static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
+				int no_context)
 {
 	return 0;
 }
diff -puN include/linux/shmem_fs.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info
+++ a/include/linux/shmem_fs.h
@@ -34,9 +34,7 @@ struct shmem_sb_info {
 	uid_t uid;		    /* Mount uid for root directory */
 	gid_t gid;		    /* Mount gid for root directory */
 	mode_t mode;		    /* Mount mode for root directory */
-	unsigned short policy;	    /* Default NUMA memory alloc policy */
-	unsigned short flags;	    /* Optional mempolicy flags */
-	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
+	struct mempolicy *mpol;     /* default memory policy for mappings */
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
diff -puN mm/mempolicy.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info
+++ a/mm/mempolicy.c
@@ -1828,27 +1828,35 @@ restart:
 	return 0;
 }
 
-void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
-			unsigned short flags, nodemask_t *policy_nodes)
+/**
+ * mpol_shared_policy_init - initialize shared policy for inode
+ * @sp: pointer to inode shared policy
+ * @mpol:  struct mempolicy to install
+ *
+ * Install non-NULL @mpol in inode's shared policy rb-tree.
+ * On entry, the current task has a reference on a non-NULL @mpol.
+ * This must be released on exit.
+ */
+void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 {
-	info->root = RB_ROOT;
-	spin_lock_init(&info->lock);
-
-	if (policy != MPOL_DEFAULT) {
-		struct mempolicy *newpol;
+	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
+	spin_lock_init(&sp->lock);
 
-		/* Falls back to NULL policy [MPOL_DEFAULT] on any error */
-		newpol = mpol_new(policy, flags, policy_nodes);
-		if (!IS_ERR(newpol)) {
-			/* Create pseudo-vma that contains just the policy */
-			struct vm_area_struct pvma;
-
-			memset(&pvma, 0, sizeof(struct vm_area_struct));
-			/* Policy covers entire file */
-			pvma.vm_end = TASK_SIZE;
-			mpol_set_shared_policy(info, &pvma, newpol);
-			mpol_put(newpol);
-		}
+	if (mpol) {
+		struct vm_area_struct pvma;
+		struct mempolicy *new;
+
+		/* contextualize the tmpfs mount point mempolicy */
+		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
+		mpol_put(mpol);	/* drop our ref on sb mpol */
+		if (IS_ERR(new))
+			return;		/* no valid nodemask intersection */
+
+		/* Create pseudo-vma that contains just the policy */
+		memset(&pvma, 0, sizeof(struct vm_area_struct));
+		pvma.vm_end = TASK_SIZE;	/* policy covers entire file */
+		mpol_set_shared_policy(sp, &pvma, new); /* adds ref */
+		mpol_put(new);			/* drop initial ref */
 	}
 }
 
@@ -1962,18 +1970,27 @@ static const char * const policy_types[]
 /**
  * mpol_parse_str - parse string to mempolicy
  * @str:  string containing mempolicy to parse
- * @mode:  pointer to returned policy mode
- * @mode_flags:  pointer to returned flags
- * @policy_nodes:  pointer to returned nodemask
+ * @mpol:  pointer to struct mempolicy pointer, returned on success.
+ * @no_context:  flag whether to "contextualize" the mempolicy
  *
  * Format of input:
  *	<mode>[=<flags>][:<nodelist>]
  *
- * Currently only used for tmpfs/shmem mount options
+ * if @no_context is true, save the input nodemask in w.user_nodemask in
+ * the returned mempolicy.  This will be used to "clone" the mempolicy in
+ * a specific context [cpuset] at a later time.  Used to parse tmpfs mpol
+ * mount option.  Note that if 'static' or 'relative' mode flags were
+ * specified, the input nodemask will already have been saved.  Saving
+ * it again is redundant, but safe.
+ *
+ * On success, returns 0, else 1
  */
-int mpol_parse_str(char *str, unsigned short *mode, unsigned short *mode_flags,
-			nodemask_t *policy_nodes)
+int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 {
+	struct mempolicy *new = NULL;
+	unsigned short uninitialized_var(mode);
+	unsigned short uninitialized_var(mode_flags);
+	nodemask_t nodes;
 	char *nodelist = strchr(str, ':');
 	char *flags = strchr(str, '=');
 	int i;
@@ -1982,26 +1999,30 @@ int mpol_parse_str(char *str, unsigned s
 	if (nodelist) {
 		/* NUL-terminate mode or flags string */
 		*nodelist++ = '\0';
-		if (nodelist_parse(nodelist, *policy_nodes))
+		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_HIGH_MEMORY]))
 			goto out;
-	}
+	} else
+		nodes_clear(nodes);
+
 	if (flags)
 		*flags++ = '\0';	/* terminate mode string */
 
 	for (i = 0; i <= MPOL_LOCAL; i++) {
 		if (!strcmp(str, policy_types[i])) {
-			*mode = i;
+			mode = i;
 			break;
 		}
 	}
 	if (i > MPOL_LOCAL)
 		goto out;
 
-	switch (*mode) {
+	switch (mode) {
 	case MPOL_PREFERRED:
-		/* Insist on a nodelist of one node only */
+		/*
+		 * Insist on a nodelist of one node only
+		 */
 		if (nodelist) {
 			char *rest = nodelist;
 			while (isdigit(*rest))
@@ -2010,63 +2031,73 @@ int mpol_parse_str(char *str, unsigned s
 				err = 0;
 		}
 		break;
-	case MPOL_BIND:
-		/* Insist on a nodelist */
-		if (nodelist)
-			err = 0;
-		break;
 	case MPOL_INTERLEAVE:
 		/*
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			*policy_nodes = node_states[N_HIGH_MEMORY];
+			nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
 		break;
-	default:
+	case MPOL_LOCAL:
 		/*
-		 * MPOL_DEFAULT or MPOL_LOCAL
-		 * Don't allow a nodelist nor flags
+		 * Don't allow a nodelist;  mpol_new() checks flags
 		 */
-		if (!nodelist && !flags)
-			err = 0;
-		if (*mode == MPOL_DEFAULT)
+		if (nodelist)
 			goto out;
-		/* else MPOL_LOCAL */
-		*mode = MPOL_PREFERRED;
-		nodes_clear(*policy_nodes);
+		mode = MPOL_PREFERRED;
 		break;
+
+	/*
+	 * case MPOL_BIND:    mpol_new() enforces non-empty nodemask.
+	 * case MPOL_DEFAULT: mpol_new() enforces empty nodemask, ignores flags.
+	 */
 	}
 
-	*mode_flags = 0;
+	mode_flags = 0;
 	if (flags) {
 		/*
 		 * Currently, we only support two mutually exclusive
 		 * mode flags.
 		 */
 		if (!strcmp(flags, "static"))
-			*mode_flags |= MPOL_F_STATIC_NODES;
+			mode_flags |= MPOL_F_STATIC_NODES;
 		else if (!strcmp(flags, "relative"))
-			*mode_flags |= MPOL_F_RELATIVE_NODES;
+			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
 			err = 1;
 	}
+
+	new = mpol_new(mode, mode_flags, &nodes);
+	if (IS_ERR(new))
+		err = 1;
+	else if (no_context)
+		new->w.user_nodemask = nodes;	/* save for contextualization */
+
 out:
 	/* Restore string for error message */
 	if (nodelist)
 		*--nodelist = ':';
 	if (flags)
 		*--flags = '=';
+	if (!err)
+		*mpol = new;
 	return err;
 }
 #endif /* CONFIG_TMPFS */
 
-/*
+/**
+ * mpol_to_str - format a mempolicy structure for printing
+ * @buffer:  to contain formatted mempolicy string
+ * @maxlen:  length of @buffer
+ * @pol:  pointer to mempolicy to be formatted
+ * @no_context:  "context free" mempolicy - use nodemask in w.user_nodemask
+ *
  * Convert a mempolicy into a string.
  * Returns the number of characters in buffer (if positive)
  * or an error (negative)
  */
-int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
+int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
 {
 	char *p = buffer;
 	int l;
@@ -2100,7 +2131,10 @@ int mpol_to_str(char *buffer, int maxlen
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		nodes = pol->v.nodes;
+		if (no_context)
+			nodes = pol->w.user_nodemask;
+		else
+			nodes = pol->v.nodes;
 		break;
 
 	default:
@@ -2231,7 +2265,7 @@ int show_numa_map(struct seq_file *m, vo
 		return 0;
 
 	pol = get_vma_policy(priv->task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol);
+	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
diff -puN mm/shmem.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info mm/shmem.c
--- a/mm/shmem.c~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info
+++ a/mm/shmem.c
@@ -1079,23 +1079,29 @@ redirty:
 
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
-static void shmem_show_mpol(struct seq_file *seq, unsigned short mode,
-			unsigned short flags, const nodemask_t policy_nodes)
+static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
 {
-	struct mempolicy temp;
 	char buffer[64];
 
-	if (mode == MPOL_DEFAULT)
+	if (!mpol || mpol->mode == MPOL_DEFAULT)
 		return;		/* show nothing */
 
-	temp.mode = mode;
-	temp.flags = flags;
-	temp.v.nodes = policy_nodes;
-
-	mpol_to_str(buffer, sizeof(buffer), &temp);
+	mpol_to_str(buffer, sizeof(buffer), mpol, 1);
 
 	seq_printf(seq, ",mpol=%s", buffer);
 }
+
+static struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
+{
+	struct mempolicy *mpol = NULL;
+	if (sbinfo->mpol) {
+		spin_lock(&sbinfo->stat_lock);	/* prevent replace/use races */
+		mpol = sbinfo->mpol;
+		mpol_get(mpol);
+		spin_unlock(&sbinfo->stat_lock);
+	}
+	return mpol;
+}
 #endif /* CONFIG_TMPFS */
 
 static struct page *shmem_swapin(swp_entry_t entry, gfp_t gfp,
@@ -1135,8 +1141,7 @@ static struct page *shmem_alloc_page(gfp
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-static inline void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
-			unsigned short flags, const nodemask_t policy_nodes)
+static inline void shmem_show_mpol(struct seq_file *seq, struct mempolicy *p)
 {
 }
 #endif /* CONFIG_TMPFS */
@@ -1154,6 +1159,13 @@ static inline struct page *shmem_alloc_p
 }
 #endif /* CONFIG_NUMA */
 
+#if !defined(CONFIG_NUMA) || !defined(CONFIG_TMPFS)
+static inline struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
+{
+	return NULL;
+}
+#endif
+
 /*
  * shmem_getpage - either get the page from swap or allocate a new one
  *
@@ -1508,8 +1520,8 @@ shmem_get_inode(struct super_block *sb, 
 		case S_IFREG:
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
-			mpol_shared_policy_init(&info->policy, sbinfo->policy,
-					sbinfo->flags, &sbinfo->policy_nodes);
+			mpol_shared_policy_init(&info->policy,
+						 shmem_get_sbmpol(sbinfo));
 			break;
 		case S_IFDIR:
 			inc_nlink(inode);
@@ -1523,8 +1535,7 @@ shmem_get_inode(struct super_block *sb, 
 			 * Must not load anything in the rbtree,
 			 * mpol_free_shared_policy will not be called.
 			 */
-			mpol_shared_policy_init(&info->policy, MPOL_DEFAULT, 0,
-						NULL);
+			mpol_shared_policy_init(&info->policy, NULL);
 			break;
 		}
 	} else
@@ -2139,8 +2150,7 @@ static int shmem_parse_options(char *opt
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (mpol_parse_str(value, &sbinfo->policy,
-					 &sbinfo->flags, &sbinfo->policy_nodes))
+			if (mpol_parse_str(value, &sbinfo->mpol, 1))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
@@ -2191,9 +2201,9 @@ static int shmem_remount_fs(struct super
 	sbinfo->free_blocks = config.max_blocks - blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
-	sbinfo->policy      = config.policy;
-	sbinfo->flags	    = config.flags;
-	sbinfo->policy_nodes = config.policy_nodes;
+
+	mpol_put(sbinfo->mpol);
+	sbinfo->mpol        = config.mpol;	/* transfers initial ref */
 out:
 	spin_unlock(&sbinfo->stat_lock);
 	return error;
@@ -2214,8 +2224,7 @@ static int shmem_show_options(struct seq
 		seq_printf(seq, ",uid=%u", sbinfo->uid);
 	if (sbinfo->gid != 0)
 		seq_printf(seq, ",gid=%u", sbinfo->gid);
-	shmem_show_mpol(seq, sbinfo->policy, sbinfo->flags,
-			sbinfo->policy_nodes);
+	shmem_show_mpol(seq, sbinfo->mpol);
 	return 0;
 }
 #endif /* CONFIG_TMPFS */
@@ -2245,9 +2254,7 @@ static int shmem_fill_super(struct super
 	sbinfo->mode = S_IRWXUGO | S_ISVTX;
 	sbinfo->uid = current->fsuid;
 	sbinfo->gid = current->fsgid;
-	sbinfo->policy = MPOL_DEFAULT;
-	sbinfo->flags = 0;
-	sbinfo->policy_nodes = node_states[N_HIGH_MEMORY];
+	sbinfo->mpol = NULL;
 	sb->s_fs_info = sbinfo;
 
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mm-add-nr_writeback_temp-counter-fix.patch

