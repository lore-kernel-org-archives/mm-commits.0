From: akpm@linux-foundation.org
Subject: [merged] hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:59 -0800
Message-ID: <200912152150.nBFLoxjj014994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761161AbZLOVwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ib


The patch titled
     hugetlb: derive huge pages nodes allowed from task mempolicy
has been removed from the -mm tree.  Its filename was
     hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: derive huge pages nodes allowed from task mempolicy
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch derives a "nodes_allowed" node mask from the numa mempolicy of
the task modifying the number of persistent huge pages to control the
allocation, freeing and adjusting of surplus huge pages when the pool page
count is modified via the new sysctl or sysfs attribute
"nr_hugepages_mempolicy".  The nodes_allowed mask is derived as follows:

* For "default" [NULL] task mempolicy, a NULL nodemask_t pointer
  is produced.  This will cause the hugetlb subsystem to use
  node_online_map as the "nodes_allowed".  This preserves the
  behavior before this patch.
* For "preferred" mempolicy, including explicit local allocation,
  a nodemask with the single preferred node will be produced.
  "local" policy will NOT track any internode migrations of the
  task adjusting nr_hugepages.
* For "bind" and "interleave" policy, the mempolicy's nodemask
  will be used.
* Other than to inform the construction of the nodes_allowed node
  mask, the actual mempolicy mode is ignored.  That is, all modes
  behave like interleave over the resulting nodes_allowed mask
  with no "fallback".

See the updated documentation [next patch] for more information
about the implications of this patch.

Examples:

Starting with:

	Node 0 HugePages_Total:     0
	Node 1 HugePages_Total:     0
	Node 2 HugePages_Total:     0
	Node 3 HugePages_Total:     0

Default behavior [with or without this patch] balances persistent
hugepage allocation across nodes [with sufficient contiguous memory]:

	sysctl vm.nr_hugepages[_mempolicy]=32

yields:

	Node 0 HugePages_Total:     8
	Node 1 HugePages_Total:     8
	Node 2 HugePages_Total:     8
	Node 3 HugePages_Total:     8

Of course, we only have nr_hugepages_mempolicy with the patch,
but with default mempolicy, nr_hugepages_mempolicy behaves the
same as nr_hugepages.

Applying mempolicy--e.g., with numactl [using '-m' a.k.a.
'--membind' because it allows multiple nodes to be specified
and it's easy to type]--we can allocate huge pages on
individual nodes or sets of nodes.  So, starting from the
condition above, with 8 huge pages per node, add 8 more to
node 2 using:

	numactl -m 2 sysctl vm.nr_hugepages_mempolicy=40

This yields:

	Node 0 HugePages_Total:     8
	Node 1 HugePages_Total:     8
	Node 2 HugePages_Total:    16
	Node 3 HugePages_Total:     8

The incremental 8 huge pages were restricted to node 2 by the
specified mempolicy.

Similarly, we can use mempolicy to free persistent huge pages
from specified nodes:

	numactl -m 0,1 sysctl vm.nr_hugepages_mempolicy=32

yields:

	Node 0 HugePages_Total:     4
	Node 1 HugePages_Total:     4
	Node 2 HugePages_Total:    16
	Node 3 HugePages_Total:     8

The 8 huge pages freed were balanced over nodes 0 and 1.

[rientjes@google.com: accomodate reworked NODEMASK_ALLOC]
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h   |    6 ++
 include/linux/mempolicy.h |    3 +
 kernel/sysctl.c           |   15 ++++-
 mm/hugetlb.c              |   97 +++++++++++++++++++++++++++++++-----
 mm/mempolicy.c            |   47 +++++++++++++++++
 5 files changed, 153 insertions(+), 15 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/include/linux/hugetlb.h
@@ -23,6 +23,12 @@ void reset_vma_resv_huge_pages(struct vm
 int hugetlb_sysctl_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, void __user *, size_t *, loff_t *);
+
+#ifdef CONFIG_NUMA
+int hugetlb_mempolicy_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
+#endif
+
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			struct page **, struct vm_area_struct **,
diff -puN include/linux/mempolicy.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/include/linux/mempolicy.h
@@ -201,6 +201,7 @@ extern void mpol_fix_fork_child_flag(str
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
+extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern unsigned slab_node(struct mempolicy *policy);
 
 extern enum zone_type policy_zone;
@@ -328,6 +329,8 @@ static inline struct zonelist *huge_zone
 	return node_zonelist(0, gfp_flags);
 }
 
+static inline bool init_nodemask_of_mempolicy(nodemask_t *m) { return false; }
+
 static inline int do_migrate_pages(struct mm_struct *mm,
 			const nodemask_t *from_nodes,
 			const nodemask_t *to_nodes, int flags)
diff -puN kernel/sysctl.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/kernel/sysctl.c
@@ -1051,7 +1051,7 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 #ifdef CONFIG_HUGETLB_PAGE
-	 {
+	{
 		.procname	= "nr_hugepages",
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
@@ -1059,7 +1059,18 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= hugetlb_sysctl_handler,
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
-	 },
+	},
+#ifdef CONFIG_NUMA
+	{
+		.procname       = "nr_hugepages_mempolicy",
+		.data           = NULL,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
+		.extra1		= (void *)&hugetlb_zero,
+		.extra2		= (void *)&hugetlb_infinity,
+	},
+#endif
 	 {
 		.procname	= "hugetlb_shm_group",
 		.data		= &sysctl_hugetlb_shm_group,
diff -puN mm/hugetlb.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/mm/hugetlb.c
@@ -1330,29 +1330,71 @@ static struct hstate *kobj_to_hstate(str
 	return NULL;
 }
 
-static ssize_t nr_hugepages_show(struct kobject *kobj,
+static ssize_t nr_hugepages_show_common(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
 	struct hstate *h = kobj_to_hstate(kobj);
 	return sprintf(buf, "%lu\n", h->nr_huge_pages);
 }
-static ssize_t nr_hugepages_store(struct kobject *kobj,
-		struct kobj_attribute *attr, const char *buf, size_t count)
+static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
+			struct kobject *kobj, struct kobj_attribute *attr,
+			const char *buf, size_t len)
 {
 	int err;
-	unsigned long input;
+	unsigned long count;
 	struct hstate *h = kobj_to_hstate(kobj);
+	NODEMASK_ALLOC(nodemask_t, nodes_allowed);
 
-	err = strict_strtoul(buf, 10, &input);
+	err = strict_strtoul(buf, 10, &count);
 	if (err)
 		return 0;
 
-	h->max_huge_pages = set_max_huge_pages(h, input, &node_online_map);
+	if (!(obey_mempolicy && init_nodemask_of_mempolicy(nodes_allowed))) {
+		NODEMASK_FREE(nodes_allowed);
+		nodes_allowed = &node_online_map;
+	}
+	h->max_huge_pages = set_max_huge_pages(h, count, nodes_allowed);
 
-	return count;
+	if (nodes_allowed != &node_online_map)
+		NODEMASK_FREE(nodes_allowed);
+
+	return len;
+}
+
+static ssize_t nr_hugepages_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return nr_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_hugepages_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return nr_hugepages_store_common(false, kobj, attr, buf, len);
 }
 HSTATE_ATTR(nr_hugepages);
 
+#ifdef CONFIG_NUMA
+
+/*
+ * hstate attribute for optionally mempolicy-based constraint on persistent
+ * huge page alloc/free.
+ */
+static ssize_t nr_hugepages_mempolicy_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return nr_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return nr_hugepages_store_common(true, kobj, attr, buf, len);
+}
+HSTATE_ATTR(nr_hugepages_mempolicy);
+#endif
+
+
 static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
 					struct kobj_attribute *attr, char *buf)
 {
@@ -1408,6 +1450,9 @@ static struct attribute *hstate_attrs[] 
 	&free_hugepages_attr.attr,
 	&resv_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+#ifdef CONFIG_NUMA
+	&nr_hugepages_mempolicy_attr.attr,
+#endif
 	NULL,
 };
 
@@ -1574,9 +1619,9 @@ static unsigned int cpuset_mems_nr(unsig
 }
 
 #ifdef CONFIG_SYSCTL
-int hugetlb_sysctl_handler(struct ctl_table *table, int write,
-			   void __user *buffer,
-			   size_t *length, loff_t *ppos)
+static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
+			 struct ctl_table *table, int write,
+			 void __user *buffer, size_t *length, loff_t *ppos)
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
@@ -1588,13 +1633,39 @@ int hugetlb_sysctl_handler(struct ctl_ta
 	table->maxlen = sizeof(unsigned long);
 	proc_doulongvec_minmax(table, write, buffer, length, ppos);
 
-	if (write)
-		h->max_huge_pages = set_max_huge_pages(h, tmp,
-							&node_online_map);
+	if (write) {
+		NODEMASK_ALLOC(nodemask_t, nodes_allowed);
+		if (!(obey_mempolicy &&
+			       init_nodemask_of_mempolicy(nodes_allowed))) {
+			NODEMASK_FREE(nodes_allowed);
+			nodes_allowed = &node_states[N_HIGH_MEMORY];
+		}
+		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
+
+		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
+			NODEMASK_FREE(nodes_allowed);
+	}
 
 	return 0;
 }
 
+int hugetlb_sysctl_handler(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *length, loff_t *ppos)
+{
+
+	return hugetlb_sysctl_handler_common(false, table, write,
+							buffer, length, ppos);
+}
+
+#ifdef CONFIG_NUMA
+int hugetlb_mempolicy_sysctl_handler(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *length, loff_t *ppos)
+{
+	return hugetlb_sysctl_handler_common(true, table, write,
+							buffer, length, ppos);
+}
+#endif /* CONFIG_NUMA */
+
 int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
 			void __user *buffer,
 			size_t *length, loff_t *ppos)
diff -puN mm/mempolicy.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy
+++ a/mm/mempolicy.c
@@ -1568,6 +1568,53 @@ struct zonelist *huge_zonelist(struct vm
 	}
 	return zl;
 }
+
+/*
+ * init_nodemask_of_mempolicy
+ *
+ * If the current task's mempolicy is "default" [NULL], return 'false'
+ * to indicate default policy.  Otherwise, extract the policy nodemask
+ * for 'bind' or 'interleave' policy into the argument nodemask, or
+ * initialize the argument nodemask to contain the single node for
+ * 'preferred' or 'local' policy and return 'true' to indicate presence
+ * of non-default mempolicy.
+ *
+ * We don't bother with reference counting the mempolicy [mpol_get/put]
+ * because the current task is examining it's own mempolicy and a task's
+ * mempolicy is only ever changed by the task itself.
+ *
+ * N.B., it is the caller's responsibility to free a returned nodemask.
+ */
+bool init_nodemask_of_mempolicy(nodemask_t *mask)
+{
+	struct mempolicy *mempolicy;
+	int nid;
+
+	if (!(mask && current->mempolicy))
+		return false;
+
+	mempolicy = current->mempolicy;
+	switch (mempolicy->mode) {
+	case MPOL_PREFERRED:
+		if (mempolicy->flags & MPOL_F_LOCAL)
+			nid = numa_node_id();
+		else
+			nid = mempolicy->v.preferred_node;
+		init_nodemask_of_node(mask, nid);
+		break;
+
+	case MPOL_BIND:
+		/* Fall through */
+	case MPOL_INTERLEAVE:
+		*mask =  mempolicy->v.nodes;
+		break;
+
+	default:
+		BUG();
+	}
+
+	return true;
+}
 #endif
 
 /* Allocate a page in interleaved policy.
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

