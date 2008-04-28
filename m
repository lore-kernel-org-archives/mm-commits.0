From: akpm@linux-foundation.org
Subject: - mempolicy-convert-mpol-constants-to-enum.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:23 -0700
Message-ID: <200804282151.m3SLpNRJ017574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964900AbYD1Vvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: convert MPOL constants to enum
has been removed from the -mm tree.  Its filename was
     mempolicy-convert-mpol-constants-to-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -202,7 +203,7 @@ static inline int mpol_set_shared_policy
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
@@ -1635,7 +1640,7 @@ restart:
 	return 0;
 }
 
-void mpol_shared_policy_init(struct shared_policy *info, int policy,
+void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
 				nodemask_t *policy_nodes)
 {
 	info->root = RB_ROOT;
@@ -1830,7 +1835,7 @@ static inline int mpol_to_str(char *buff
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
@@ -1079,7 +1079,8 @@ redirty:
 
 #ifdef CONFIG_NUMA
 #ifdef CONFIG_TMPFS
-static int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+static int shmem_parse_mpol(char *value, unsigned short *policy,
+			    nodemask_t *policy_nodes)
 {
 	char *nodelist = strchr(value, ':');
 	int err = 1;
@@ -1128,7 +1129,7 @@ out:
 	return err;
 }
 
-static void shmem_show_mpol(struct seq_file *seq, int policy,
+static void shmem_show_mpol(struct seq_file *seq, unsigned short policy,
 			    const nodemask_t policy_nodes)
 {
 	char *policy_string;
@@ -1197,13 +1198,13 @@ static struct page *shmem_alloc_page(gfp
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

origin.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch

