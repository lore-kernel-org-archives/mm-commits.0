From: akpm@linux-foundation.org
Subject: + mempolicy-convert-mpol-constants-to-enum.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:26:22 -0800
Message-ID: <200803060126.m261QNZX002028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230AbYCFB1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com


The patch titled
     mempolicy: convert MPOL constants to enum
has been added to the -mm tree.  Its filename is
     mempolicy-convert-mpol-constants-to-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: convert MPOL constants to enum
From: David Rientjes <rientjes@google.com>

The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND, and
MPOL_INTERLEAVE, are better declared as part of an enum since they are
sequentially numbered and cannot be combined.

The policy member of struct mempolicy is also converted from type short to
type unsigned short.  A negative policy does not have any legitimate meaning,
so it is possible to change its type in preparation for adding optional mode
flags later.

The equivalent member of struct shmem_sb_info is also changed from int to
unsigned short.

For compatibility, the policy formal to get_mempolicy() remains as a pointer
to an int:

	int get_mempolicy(int *policy, unsigned long *nmask,
			  unsigned long maxnode, unsigned long addr,
			  unsigned long flags);

although the only possible values is the range of type unsigned short.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   19 ++++++++++---------
 include/linux/shmem_fs.h  |    2 +-
 mm/mempolicy.c            |   29 +++++++++++++++++------------
 mm/shmem.c                |    9 +++++----
 4 files changed, 33 insertions(+), 26 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-convert-mpol-constants-to-enum include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-convert-mpol-constants-to-enum
+++ a/include/linux/mempolicy.h
@@ -9,12 +9,13 @@
  */
 
 /* Policies */
-#define MPOL_DEFAULT	0
-#define MPOL_PREFERRED	1
-#define MPOL_BIND	2
-#define MPOL_INTERLEAVE	3
-
-#define MPOL_MAX MPOL_INTERLEAVE
+enum {
+	MPOL_DEFAULT,
+	MPOL_PREFERRED,
+	MPOL_BIND,
+	MPOL_INTERLEAVE,
+	MPOL_MAX,	/* always last member of enum */
+};
 
 /* Flags for get_mem_policy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
@@ -64,7 +65,7 @@ struct mm_struct;
  */
 struct mempolicy {
 	atomic_t refcnt;
-	short policy; 	/* See MPOL_* above */
+	unsigned short policy; 	/* See MPOL_* above */
 	union {
 		short 		 preferred_node; /* preferred */
 		nodemask_t	 nodes;		/* interleave/bind */
@@ -134,7 +135,7 @@ struct shared_policy {
 	spinlock_t lock;
 };
 
-void mpol_shared_policy_init(struct shared_policy *info, int policy,
+void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
 				nodemask_t *nodes);
 int mpol_set_shared_policy(struct shared_policy *info,
 				struct vm_area_struct *vma,
@@ -209,7 +210,7 @@ static inline int mpol_set_shared_policy
 }
 
 static inline void mpol_shared_policy_init(struct shared_policy *info,
-					int policy, nodemask_t *nodes)
+				unsigned short policy, nodemask_t *nodes)
 {
 }
 
diff -puN include/linux/shmem_fs.h~mempolicy-convert-mpol-constants-to-enum include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mempolicy-convert-mpol-constants-to-enum
+++ a/include/linux/shmem_fs.h
@@ -34,7 +34,7 @@ struct shmem_sb_info {
 	uid_t uid;		    /* Mount uid for root directory */
 	gid_t gid;		    /* Mount gid for root directory */
 	mode_t mode;		    /* Mount mode for root directory */
-	int policy;		    /* Default NUMA memory alloc policy */
+	unsigned short policy;	    /* Default NUMA memory alloc policy */
 	nodemask_t policy_nodes;    /* nodemask for preferred and bind */
 };
 
diff -puN mm/mempolicy.c~mempolicy-convert-mpol-constants-to-enum mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-convert-mpol-constants-to-enum
+++ a/mm/mempolicy.c
@@ -114,7 +114,7 @@ static void mpol_rebind_policy(struct me
                                const nodemask_t *newmask);
 
 /* Do sanity checking on a policy */
-static int mpol_check_policy(int mode, nodemask_t *nodes)
+static int mpol_check_policy(unsigned short mode, nodemask_t *nodes)
 {
 	int was_empty, is_empty;
 
@@ -159,6 +159,8 @@ static int mpol_check_policy(int mode, n
 		if (!was_empty && is_empty)
 			return -EINVAL;
 		break;
+	default:
+		BUG();
 	}
 	return 0;
 }
@@ -185,7 +187,7 @@ static int is_valid_nodemask(nodemask_t 
 }
 
 /* Create a new policy */
-static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
+static struct mempolicy *mpol_new(unsigned short mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 
@@ -218,6 +220,8 @@ static struct mempolicy *mpol_new(int mo
 		}
 		policy->v.nodes = *nodes;
 		break;
+	default:
+		BUG();
 	}
 	policy->policy = mode;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
@@ -462,7 +466,7 @@ static void mpol_set_task_struct_flag(vo
 }
 
 /* Set the process memory policy */
-static long do_set_mempolicy(int mode, nodemask_t *nodes)
+static long do_set_mempolicy(unsigned short mode, nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
@@ -759,7 +763,7 @@ static struct page *new_vma_page(struct 
 #endif
 
 static long do_mbind(unsigned long start, unsigned long len,
-		     unsigned long mode, nodemask_t *nmask,
+		     unsigned short mode, nodemask_t *nmask,
 		     unsigned long flags)
 {
 	struct vm_area_struct *vma;
@@ -769,9 +773,8 @@ static long do_mbind(unsigned long start
 	int err;
 	LIST_HEAD(pagelist);
 
-	if ((flags & ~(unsigned long)(MPOL_MF_STRICT |
-				      MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-	    || mode > MPOL_MAX)
+	if (flags & ~(unsigned long)(MPOL_MF_STRICT |
+				     MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 		return -EINVAL;
 	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
 		return -EPERM;
@@ -804,7 +807,7 @@ static long do_mbind(unsigned long start
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%ld nodes:%lx\n",start,start+len,
+	pr_debug("mbind %lx-%lx mode:%d nodes:%lx\n", start, start + len,
 		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
@@ -905,6 +908,8 @@ asmlinkage long sys_mbind(unsigned long 
 	nodemask_t nodes;
 	int err;
 
+	if (mode >= MPOL_MAX)
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -918,7 +923,7 @@ asmlinkage long sys_set_mempolicy(int mo
 	int err;
 	nodemask_t nodes;
 
-	if (mode < 0 || mode > MPOL_MAX)
+	if (mode < 0 || mode >= MPOL_MAX)
 		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
@@ -1201,7 +1206,7 @@ static unsigned interleave_nodes(struct 
  */
 unsigned slab_node(struct mempolicy *policy)
 {
-	int pol = policy ? policy->policy : MPOL_DEFAULT;
+	unsigned short pol = policy ? policy->policy : MPOL_DEFAULT;
 
 	switch (pol) {
 	case MPOL_INTERLEAVE:
@@ -1628,7 +1633,7 @@ restart:
 	return 0;
 }
 
-void mpol_shared_policy_init(struct shared_policy *info, int policy,
+void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
 				nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
@@ -1823,7 +1828,7 @@ static inline int mpol_to_str(char *buff
 	char *p = buffer;
 	int l;
 	nodemask_t nodes;
-	int mode = pol ? pol->policy : MPOL_DEFAULT;
+	unsigned short mode = pol ? pol->policy : MPOL_DEFAULT;
 
 	switch (mode) {
 	case MPOL_DEFAULT:
diff -puN mm/shmem.c~mempolicy-convert-mpol-constants-to-enum mm/shmem.c
--- a/mm/shmem.c~mempolicy-convert-mpol-constants-to-enum
+++ a/mm/shmem.c
@@ -1082,7 +1082,8 @@ redirty:
 
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
-static int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_mpol(char *value, unsigned short *policy,
+			    nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
 	int err = 1;
@@ -1131,7 +1132,7 @@ out:
 	return err;
 }
 
-static void shmem_show_mpol(struct seq_file *seq, int policy,
+static void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
 			    const nodemask_t policy_nodes)
 {
 	char *policy_string;
@@ -1200,13 +1201,13 @@ static struct page *shmem_alloc_page(gfp
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-static inline int shmem_parse_mpol(char *value, int *policy,
+static inline int shmem_parse_mpol(char *value, unsigned short *policy,
 						nodemask_t *policy_nodes)
 {
 	return 1;
 }
 
-static inline void shmem_show_mpol(struct seq_file *seq, int policy,
+static inline void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
 			    const nodemask_t policy_nodes)
 {
 }
_

Patches currently in -mm which might be from rientjes@google.com are

fix-mempolicy-reference-counting-bugs.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
make-cgroup_enable_task_cg_lists-static.patch

