Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E80749C
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235326; cv=none; b=ATzSuct+of4XX3arBL8vdB5gNdcJPPblNpKtHsIFg+hTaQb0T+4djjglzOlaeirzuHF9AyB1gsAORop9TFWpzES6TbBap8vlPDcuoiENTH9SR8o1PbrhftTHv5lX3fw+IJL4itrgUEyTJJ55vPmR3F1E9l/pgBkXftrdQ3ijZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235326; c=relaxed/simple;
	bh=0YiHwODQWJ77XPHe77LHV6Phkj3cUcLVaRmU0grrFyA=;
	h=Date:To:From:Subject:Message-Id; b=MpI3kazyDFACxGpf152yamNNVOMDmVLfRUdvZNng00DYgpmdm8FqRI9oiwb6ZDlhPotKdh3VOZ+c1bCfoZfP+BQT+jgskLkPcMoNuz1S8wc+wWGnd/IR+RL7dLYtU4rjdoTsryDmbm/XkqEadjKz3LSx/r3kHhF8xy3l1GAsT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ZmB4A8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ZmB4A8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A288C433C7;
	Fri, 26 Jan 2024 02:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235325;
	bh=0YiHwODQWJ77XPHe77LHV6Phkj3cUcLVaRmU0grrFyA=;
	h=Date:To:From:Subject:From;
	b=0ZmB4A8g1LsG4agfXPXE3ZFrDpRw9j2v0Gl0GsK6MtZ3nKvBRdnSxeAcD4ossqILC
	 SMLoksCZFs7OR89ywG+NsfDuQl02U4JywpX/Ftxub0/Q98HUJhRsZC4Kir2OW/C13m
	 5hrZUKFH/8OcYeb1v0pDBFIe1klM7oYQ9g+g6AiQ=
Date: Thu, 25 Jan 2024 18:15:22 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,mhocko@suse.com,mhocko@kernel.org,Jonathan.Cameron@huawei.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,gourry.memverge@gmail.com,fvdl@google.com,dan.j.williams@intel.com,corbet@lwn.net,ak@linux.intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-implement-the-sysfs-based-weighted_interleave-interface.patch added to mm-unstable branch
Message-Id: <20240126021525.3A288C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: implement the sysfs-based weighted_interleave interface
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-implement-the-sysfs-based-weighted_interleave-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-implement-the-sysfs-based-weighted_interleave-interface.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Rakie Kim <rakie.kim@sk.com>
Subject: mm/mempolicy: implement the sysfs-based weighted_interleave interface
Date: Thu, 25 Jan 2024 13:43:42 -0500

Patch series "mm/mempolicy: weighted interleave mempolicy and sysfs
extension", v3.

Weighted interleave is a new interleave policy intended to make use of
heterogeneous memory environments appearing with CXL.

The existing interleave mechanism does an even round-robin distribution of
memory across all nodes in a nodemask, while weighted interleave
distributes memory across nodes according to a provided weight.  (Weight =
# of page allocations per round)

Weighted interleave is intended to reduce average latency when bandwidth
is pressured - therefore increasing total throughput.

In other words: It allows greater use of the total available bandwidth in
a heterogeneous hardware environment (different hardware provides
different bandwidth capacity).

As bandwidth is pressured, latency increases - first linearly and then
exponentially.  By keeping bandwidth usage distributed according to
available bandwidth, we therefore can reduce the average latency of a
cacheline fetch.

A good explanation of the bandwidth vs latency response curve:
https://mahmoudhatem.wordpress.com/2017/11/07/memory-bandwidth-vs-latency-response-curve/

From the article:
```
Constant region:
    The latency response is fairly constant for the first 40%
    of the sustained bandwidth.
Linear region:
    In between 40% to 80% of the sustained bandwidth, the
    latency response increases almost linearly with the bandwidth
    demand of the system due to contention overhead by numerous
    memory requests.
Exponential region:
    Between 80% to 100% of the sustained bandwidth, the memory
    latency is dominated by the contention latency which can be
    as much as twice the idle latency or more.
Maximum sustained bandwidth :
    Is 65% to 75% of the theoretical maximum bandwidth.
```

As a general rule of thumb:
* If bandwidth usage is low, latency does not increase. It is
  optimal to place data in the nearest (lowest latency) device.
* If bandwidth usage is high, latency increases. It is optimal
  to place data such that bandwidth use is optimized per-device.

This is the top line goal: Provide a user a mechanism to target using
the "maximum sustained bandwidth" of each hardware component in a
heterogenous memory system.


For example, the stream benchmark demonstrates that 1:1 (default)
interleave is actively harmful, while weighted interleave can be
beneficial.  Default interleave distributes data such that too much
pressure is placed on devices with lower available bandwidth.

Stream Benchmark (High level results, 1 Socket + 1 CXL Device)
Default interleave : -78% (slower than DRAM)
Global weighting   : -6% to +4% (workload dependant)
Targeted weights   : +2.5% to +4% (consistently better than DRAM)

Global means the task-policy was set (set_mempolicy), while targeted means
VMA policies were set (mbind2).  We see weighted interleave is not always
beneficial when applied globally, but is always beneficial when applied to
bandwidth-driving memory regions.

We implement sysfs entries for "system global" weights which can be set by
a daemon or administrator.


There are 3 patches in this set:
1) Implement system-global interleave weights as sysfs extension
   in mm/mempolicy.c.  These weights are RCU protected, and a
   default weight set is provided (all weights are 1 by default).

   In future work, we intend to expose an interface for HMAT/CDAT
   information to be used during boot to set reasonable system
   default values based on the memory configuration of the system
   discovered at boot or during device hotplug.

2) A mild refactor of some interleave-logic for re-use in the
   new weighted interleave logic.

3) MPOL_WEIGHTED_INTERLEAVE extension for set_mempolicy/mbind


Included below are some performance and LTP test information,
and a sample numactl branch which can be used for testing.

= Performance summary =
(tests may have different configurations, see extended info below)
1) MLC (W2) : +38% over DRAM. +264% over default interleave.
   MLC (W5) : +40% over DRAM. +226% over default interleave.
2) Stream   : -6% to +4% over DRAM, +430% over default interleave.
3) XSBench  : +19% over DRAM. +47% over default interleave.

= LTP Testing Summary =
existing mempolicy & mbind tests: pass
mempolicy & mbind + weighted interleave (global weights): pass


This patch (of 4):

This patch provides a way to set interleave weight information under sysfs
at /sys/kernel/mm/mempolicy/weighted_interleave/nodeN

The sysfs structure is designed as follows.

  $ tree /sys/kernel/mm/mempolicy/
  /sys/kernel/mm/mempolicy/ [1]
  └── weighted_interleave [2]
      ├── node0 [3]
      └── node1

Each file above can be explained as follows.

[1] mm/mempolicy: configuration interface for mempolicy subsystem

[2] weighted_interleave/: config interface for weighted interleave policy

[3] weighted_interleave/nodeN: weight for nodeN

If a node value is set to `0`, the system-default value will be used.
As of this patch, the system-default for all nodes is always 1.

Link: https://lkml.kernel.org/r/20240125184345.47074-2-gregory.price@memverge.com
Suggested-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Co-developed-by: Gregory Price <gregory.price@memverge.com>
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Co-developed-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-mempolicy                     |    4 
 Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave |   25 +
 mm/mempolicy.c                                                          |  224 ++++++++++
 3 files changed, 253 insertions(+)

--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
@@ -0,0 +1,4 @@
+What:		/sys/kernel/mm/mempolicy/
+Date:		December 2023
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Interface for Mempolicy
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
@@ -0,0 +1,25 @@
+What:		/sys/kernel/mm/mempolicy/weighted_interleave/
+Date:		January 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Configuration Interface for the Weighted Interleave policy
+
+What:		/sys/kernel/mm/mempolicy/weighted_interleave/nodeN
+Date:		January 2024
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Weight configuration interface for nodeN
+
+		The interleave weight for a memory node (N). These weights are
+		utilized by taskss which have set their mempolicy to
+		MPOL_WEIGHTED_INTERLEAVE.
+
+		These weights only affect new allocations, and changes at runtime
+		will not cause migrations on already allocated pages.
+
+		The minimum weight for a node is always 1.
+
+		Minimum weight: 1
+		Maximum weight: 255
+
+		Writing an empty string or `0` will reset the weight to the
+		system default. The system default may be set by the kernel
+		or drivers at boot or during hotplug events.
--- a/mm/mempolicy.c~mm-mempolicy-implement-the-sysfs-based-weighted_interleave-interface
+++ a/mm/mempolicy.c
@@ -131,6 +131,17 @@ static struct mempolicy default_policy =
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
+/*
+ * iw_table is the sysfs-set interleave weight table, a value of 0 denotes
+ * system-default value should be used. A NULL iw_table also denotes that
+ * system-default values should be used. Until the system-default table
+ * is implemented, the system-default is always 1.
+ *
+ * iw_table is RCU protected
+ */
+static u8 __rcu *iw_table;
+static DEFINE_MUTEX(iw_table_lock);
+
 /**
  * numa_nearest_node - Find nearest node by state
  * @node: Node id to start the search
@@ -3063,3 +3074,216 @@ void mpol_to_str(char *buffer, int maxle
 		p += scnprintf(p, buffer + maxlen - p, ":%*pbl",
 			       nodemask_pr_args(&nodes));
 }
+
+#ifdef CONFIG_SYSFS
+struct iw_node_attr {
+	struct kobj_attribute kobj_attr;
+	int nid;
+};
+
+static ssize_t node_show(struct kobject *kobj, struct kobj_attribute *attr,
+			 char *buf)
+{
+	struct iw_node_attr *node_attr;
+	u8 weight;
+	u8 __rcu *table;
+
+	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
+
+	rcu_read_lock();
+	table = rcu_dereference(iw_table);
+	weight = table ? table[node_attr->nid] : 1;
+	rcu_read_unlock();
+
+	return sysfs_emit(buf, "%d\n", weight);
+}
+
+static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct iw_node_attr *node_attr;
+	u8 __rcu *new;
+	u8 __rcu *old;
+	u8 weight = 0;
+
+	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
+	if (count == 0 || sysfs_streq(buf, ""))
+		weight = 0;
+	else if (kstrtou8(buf, 0, &weight))
+		return -EINVAL;
+
+	/*
+	 * The default weight is 1, for now. When the kernel-internal
+	 * default weight array is implemented, 0 will be a directive to
+	 * the allocators to use the system-default weight instead.
+	 */
+	if (!weight)
+		weight = 1;
+
+	new = kmalloc(nr_node_ids, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	mutex_lock(&iw_table_lock);
+	old = rcu_dereference_protected(iw_table,
+					lockdep_is_held(&iw_table_lock));
+	if (old)
+		memcpy(new, old, nr_node_ids);
+	else
+		memset(new, 1, nr_node_ids);
+	new[node_attr->nid] = weight;
+	rcu_assign_pointer(iw_table, new);
+	mutex_unlock(&iw_table_lock);
+	synchronize_rcu();
+	kfree(old);
+	return count;
+}
+
+static struct iw_node_attr **node_attrs;
+
+static void sysfs_wi_node_release(struct iw_node_attr *node_attr,
+				  struct kobject *parent)
+{
+	if (!node_attr)
+		return;
+	sysfs_remove_file(parent, &node_attr->kobj_attr.attr);
+	kfree(node_attr->kobj_attr.attr.name);
+	kfree(node_attr);
+}
+
+static void sysfs_wi_release(struct kobject *wi_kobj)
+{
+	int i;
+
+	for (i = 0; i < nr_node_ids; i++)
+		sysfs_wi_node_release(node_attrs[i], wi_kobj);
+	kobject_put(wi_kobj);
+}
+
+static const struct kobj_type wi_ktype = {
+	.sysfs_ops = &kobj_sysfs_ops,
+	.release = sysfs_wi_release,
+};
+
+static int add_weight_node(int nid, struct kobject *wi_kobj)
+{
+	struct iw_node_attr *node_attr;
+	char *name;
+
+	node_attr = kzalloc(sizeof(*node_attr), GFP_KERNEL);
+	if (!node_attr)
+		return -ENOMEM;
+
+	name = kasprintf(GFP_KERNEL, "node%d", nid);
+	if (!name) {
+		kfree(node_attr);
+		return -ENOMEM;
+	}
+
+	sysfs_attr_init(&node_attr->kobj_attr.attr);
+	node_attr->kobj_attr.attr.name = name;
+	node_attr->kobj_attr.attr.mode = 0644;
+	node_attr->kobj_attr.show = node_show;
+	node_attr->kobj_attr.store = node_store;
+	node_attr->nid = nid;
+
+	if (sysfs_create_file(wi_kobj, &node_attr->kobj_attr.attr)) {
+		kfree(node_attr->kobj_attr.attr.name);
+		kfree(node_attr);
+		pr_err("failed to add attribute to weighted_interleave\n");
+		return -ENOMEM;
+	}
+
+	node_attrs[nid] = node_attr;
+	return 0;
+}
+
+static int add_weighted_interleave_group(struct kobject *root_kobj)
+{
+	struct kobject *wi_kobj;
+	int nid, err;
+
+	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (!wi_kobj)
+		return -ENOMEM;
+
+	err = kobject_init_and_add(wi_kobj, &wi_ktype, root_kobj,
+				   "weighted_interleave");
+	if (err) {
+		kfree(wi_kobj);
+		return err;
+	}
+
+	for_each_node_state(nid, N_POSSIBLE) {
+		err = add_weight_node(nid, wi_kobj);
+		if (err) {
+			pr_err("failed to add sysfs [node%d]\n", nid);
+			break;
+		}
+	}
+	if (err)
+		kobject_put(wi_kobj);
+	return 0;
+}
+
+static void mempolicy_kobj_release(struct kobject *kobj)
+{
+	u8 __rcu *old;
+
+	mutex_lock(&iw_table_lock);
+	old = rcu_dereference_protected(iw_table,
+					lockdep_is_held(&iw_table_lock));
+	rcu_assign_pointer(iw_table, NULL);
+	mutex_unlock(&iw_table_lock);
+	synchronize_rcu();
+	kfree(old);
+	kfree(node_attrs);
+	kfree(kobj);
+}
+
+static const struct kobj_type mempolicy_ktype = {
+	.release = mempolicy_kobj_release
+};
+
+static int __init mempolicy_sysfs_init(void)
+{
+	int err;
+	static struct kobject *mempolicy_kobj;
+
+	mempolicy_kobj = kzalloc(sizeof(*mempolicy_kobj), GFP_KERNEL);
+	if (!mempolicy_kobj) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
+			     GFP_KERNEL);
+	if (!node_attrs) {
+		err = -ENOMEM;
+		goto mempol_out;
+	}
+
+	err = kobject_init_and_add(mempolicy_kobj, &mempolicy_ktype, mm_kobj,
+				   "mempolicy");
+	if (err)
+		goto node_out;
+
+	err = add_weighted_interleave_group(mempolicy_kobj);
+	if (err) {
+		pr_err("mempolicy sysfs structure failed to initialize\n");
+		kobject_put(mempolicy_kobj);
+		return err;
+	}
+
+	return err;
+node_out:
+	kfree(node_attrs);
+mempol_out:
+	kfree(mempolicy_kobj);
+err_out:
+	pr_err("failed to add mempolicy kobject to the system\n");
+	return err;
+}
+
+late_initcall(mempolicy_sysfs_init);
+#endif /* CONFIG_SYSFS */
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-implement-the-sysfs-based-weighted_interleave-interface.patch

