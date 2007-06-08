From: akpm@linux-foundation.org
Subject: - numa-mempolicy-allow-tunable-policy-for-system-init.patch removed from -mm tree
Date: Thu, 07 Jun 2007 17:58:50 -0700
Message-ID: <200706080058.l580wodP014243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765839AbXFHA7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, ak@suse.de, clameter@sgi.com, hugh@veritas.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     numa: mempolicy: Allow tunable policy for system init
has been removed from the -mm tree.  Its filename was
     numa-mempolicy-allow-tunable-policy-for-system-init.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: numa: mempolicy: Allow tunable policy for system init
From: Paul Mundt <lethal@linux-sh.org>

The current default behaviour for system init (via numa_policy_init()) is
to use MPOL_INTERLEAVE across the online nodes in order to avoid a
preference for node 0.  This tends to be undesirable for small nodes that
really would rather prefer to keep as many allocations on node 0 as
possible.

As tmpfs already provides a parser for the policy and nodelist --
shmem_parse_mpol(), we generalize this and wrap in to it via an mpolinit=
(for lack of a better name) setup param.  Other code that wishes to do
mempolicy parsing for itself can use the new mpol_parse_options().

As an example, for small nodes, one might prefer to boot with
'mpolinit=prefer:0'.  numa_default_policy() will still overload this with
MPOL_DEFAULT later on anyways, so this is only useful for system init.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 +
 include/linux/mempolicy.h           |    8 ++
 mm/mempolicy.c                      |   83 ++++++++++++++++++++++++--
 mm/shmem.c                          |   54 ----------------
 4 files changed, 93 insertions(+), 58 deletions(-)

diff -puN Documentation/kernel-parameters.txt~numa-mempolicy-allow-tunable-policy-for-system-init Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~numa-mempolicy-allow-tunable-policy-for-system-init
+++ a/Documentation/kernel-parameters.txt
@@ -1080,6 +1080,12 @@ and is between 256 and 4096 characters. 
 	mousedev.yres=	[MOUSE] Vertical screen resolution, used for devices
 			reporting absolute coordinates, such as tablets
 
+	mpolinit=	[KNL,NUMA]
+			Format: <policy>,[:<nodelist>]
+			Sets the default memory policy to be used at system
+			init time. Defaults to MPOL_INTERLEAVE between online
+			nodes.
+
 	mpu401=		[HW,OSS]
 			Format: <io>,<irq>
 
diff -puN include/linux/mempolicy.h~numa-mempolicy-allow-tunable-policy-for-system-init include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~numa-mempolicy-allow-tunable-policy-for-system-init
+++ a/include/linux/mempolicy.h
@@ -148,6 +148,8 @@ extern void mpol_rebind_task(struct task
 					const nodemask_t *new);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
+extern int mpol_parse_options(char *value, int *policy,
+			      nodemask_t *policy_nodes);
 #define set_cpuset_being_rebound(x) (cpuset_being_rebound = (x))
 
 #ifdef CONFIG_CPUSETS
@@ -253,6 +255,12 @@ static inline void mpol_fix_fork_child_f
 {
 }
 
+static inline int mpol_parse_options(char *value, int *policy,
+				     nodemask_t *policy_nodes)
+{
+	return 1;
+}
+
 #define set_cpuset_being_rebound(x) do {} while (0)
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
diff -puN mm/mempolicy.c~numa-mempolicy-allow-tunable-policy-for-system-init mm/mempolicy.c
--- a/mm/mempolicy.c~numa-mempolicy-allow-tunable-policy-for-system-init
+++ a/mm/mempolicy.c
@@ -89,7 +89,7 @@
 #include <linux/migrate.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
-
+#include <linux/ctype.h>
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 
@@ -1594,9 +1594,74 @@ void mpol_free_shared_policy(struct shar
 	spin_unlock(&p->lock);
 }
 
+int mpol_parse_options(char *value, int *policy, nodemask_t *policy_nodes)
+{
+	char *nodelist = strchr(value, ':');
+	int err = 1;
+
+	if (nodelist) {
+		/* NUL-terminate policy string */
+		*nodelist++ = '\0';
+		if (nodelist_parse(nodelist, *policy_nodes))
+			goto out;
+		if (!nodes_subset(*policy_nodes, node_online_map))
+			goto out;
+	}
+	if (!strcmp(value, "default")) {
+		*policy = MPOL_DEFAULT;
+		/* Don't allow a nodelist */
+		if (!nodelist)
+			err = 0;
+	} else if (!strcmp(value, "prefer")) {
+		*policy = MPOL_PREFERRED;
+		/* Insist on a nodelist of one node only */
+		if (nodelist) {
+			char *rest = nodelist;
+			while (isdigit(*rest))
+				rest++;
+			if (!*rest)
+				err = 0;
+		}
+	} else if (!strcmp(value, "bind")) {
+		*policy = MPOL_BIND;
+		/* Insist on a nodelist */
+		if (nodelist)
+			err = 0;
+	} else if (!strcmp(value, "interleave")) {
+		*policy = MPOL_INTERLEAVE;
+		/* Default to nodes online if no nodelist */
+		if (!nodelist)
+			*policy_nodes = node_online_map;
+		err = 0;
+	}
+out:
+	/* Restore string for error message */
+	if (nodelist)
+		*--nodelist = ':';
+	return err;
+}
+
+/* Set interleaving policy for system init. This way not all
+   the data structures allocated at system boot end up in node zero. */
+static nodemask_t nmask_sysinit __initdata;
+static int policy_sysinit __initdata = MPOL_INTERLEAVE;
+
+static int __init setup_mpol_sysinit(char *str)
+{
+	if (mpol_parse_options(str, &policy_sysinit, &nmask_sysinit)) {
+		printk("mpolinit failed, falling back on interleave\n");
+		return 0;
+	}
+
+	return 1;
+}
+__setup("mpolinit=", setup_mpol_sysinit);
+
 /* assumes fs == KERNEL_DS */
 void __init numa_policy_init(void)
 {
+	nodemask_t *nmask;
+
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
 					 0, SLAB_PANIC, NULL, NULL);
@@ -1605,11 +1670,19 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL, NULL);
 
-	/* Set interleaving policy for system init. This way not all
-	   the data structures allocated at system boot end up in node zero. */
+	/*
+	 * Use the specified nodemask for init, or fall back to
+	 * node_online_map.
+	 */
+	if (policy_sysinit == MPOL_DEFAULT)
+		nmask = NULL;
+	else if (!nodes_empty(nmask_sysinit))
+		nmask = &nmask_sysinit;
+	else
+		nmask = &node_online_map;
 
-	if (do_set_mempolicy(MPOL_INTERLEAVE, &node_online_map))
-		printk("numa_policy_init: interleaving failed\n");
+	if (do_set_mempolicy(policy_sysinit, nmask))
+		printk("numa_policy_init: setting init policy failed\n");
 }
 
 /* Reset policy of current process to default */
diff -puN mm/shmem.c~numa-mempolicy-allow-tunable-policy-for-system-init mm/shmem.c
--- a/mm/shmem.c~numa-mempolicy-allow-tunable-policy-for-system-init
+++ a/mm/shmem.c
@@ -958,53 +958,6 @@ redirty:
 }
 
 #ifdef CONFIG_NUMA
-static inline int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
-{
-	char *nodelist = strchr(value, ':');
-	int err = 1;
-
-	if (nodelist) {
-		/* NUL-terminate policy string */
-		*nodelist++ = '\0';
-		if (nodelist_parse(nodelist, *policy_nodes))
-			goto out;
-		if (!nodes_subset(*policy_nodes, node_online_map))
-			goto out;
-	}
-	if (!strcmp(value, "default")) {
-		*policy = MPOL_DEFAULT;
-		/* Don't allow a nodelist */
-		if (!nodelist)
-			err = 0;
-	} else if (!strcmp(value, "prefer")) {
-		*policy = MPOL_PREFERRED;
-		/* Insist on a nodelist of one node only */
-		if (nodelist) {
-			char *rest = nodelist;
-			while (isdigit(*rest))
-				rest++;
-			if (!*rest)
-				err = 0;
-		}
-	} else if (!strcmp(value, "bind")) {
-		*policy = MPOL_BIND;
-		/* Insist on a nodelist */
-		if (nodelist)
-			err = 0;
-	} else if (!strcmp(value, "interleave")) {
-		*policy = MPOL_INTERLEAVE;
-		/* Default to nodes online if no nodelist */
-		if (!nodelist)
-			*policy_nodes = node_online_map;
-		err = 0;
-	}
-out:
-	/* Restore string for error message */
-	if (nodelist)
-		*--nodelist = ':';
-	return err;
-}
-
 static struct page *shmem_swapin_async(struct shared_policy *p,
 				       swp_entry_t entry, unsigned long idx)
 {
@@ -1057,11 +1010,6 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	return page;
 }
 #else
-static inline int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
-{
-	return 1;
-}
-
 static inline struct page *
 shmem_swapin(struct shmem_inode_info *info,swp_entry_t entry,unsigned long idx)
 {
@@ -2151,7 +2099,7 @@ static int shmem_parse_options(char *opt
 			if (*rest)
 				goto bad_val;
 		} else if (!strcmp(this_char,"mpol")) {
-			if (shmem_parse_mpol(value,policy,policy_nodes))
+			if (mpol_parse_options(value,policy,policy_nodes))
 				goto bad_val;
 		} else {
 			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
_

Patches currently in -mm which might be from lethal@linux-sh.org are

slab-fix-alien-cache-handling.patch
potential-parse-error-in-ifdef-part-3.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-sh.patch
numa-mempolicy-allow-tunable-policy-for-system-init.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
