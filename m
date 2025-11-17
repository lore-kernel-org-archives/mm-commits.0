Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030420FAAB
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343131; cv=none; b=EMVNaN8h+jAsO6+Qi2kZmalBMQaowfrYSxx1DzdazRKK1vq4KqyqP4ND81wy2+Bpxn8PDFZGkXRl5njycBywZ0focaveJ30X1HQYxB2Ximp+s56wXB9Tm+N0qPCYR/xMj2z0rTwgVyT6WutcecpvxQX2e9V3h8j6xbaVIHqR/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343131; c=relaxed/simple;
	bh=tWAdO/+kzwUVrLqpmRRY5/jwXmx6bMIXjqemz1E4fZ0=;
	h=Date:To:From:Subject:Message-Id; b=H3HdpFEWe/z0h39nOjn4rxF/SJqzBsGpJ1iRdHIWc1Rg5sUVj8e0sNxCxYWjrIOOhcBQbaenTnF8t6sddQIqQ3F6Jztw8E4Aw8CL2mzqIvDjebMttL1/+4H4XmtntsVEletU1OgAGs7re9TMNZYOwbIhzZx/Sk2d2hDl4uk/a9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B27wWRD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B27wWRD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138E4C19422;
	Mon, 17 Nov 2025 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343131;
	bh=tWAdO/+kzwUVrLqpmRRY5/jwXmx6bMIXjqemz1E4fZ0=;
	h=Date:To:From:Subject:From;
	b=B27wWRD15MLeSoXMaBapnyUSXY8WfD4LYpstg0rfxbW89Xd5kNVCbHgeU9CndwV4h
	 D8OOxUQNiJdXGNf5z50E0nmVROiN/x6agSzjtL4SNO/KbxYEDi/fEIV1slRZY4deQZ
	 2F9ox6mKSjuMJvsPfZBudu5N0M65KLpvPE4sUNpA=
Date: Sun, 16 Nov 2025 17:32:10 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,maddy@linux.ibm.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,christophe.leroy@csgroup.eu,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-fold-register_node-into-register_one_node.patch removed from -mm tree
Message-Id: <20251117013211.138E4C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: fold register_node() into register_one_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-fold-register_node-into-register_one_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: fold register_node() into register_one_node()
Date: Tue, 14 Oct 2025 21:09:16 +0530

Patch series "drivers/base/node: fold node register and unregister
functions", v2.

The first patch merges register_one_node() and register_node(), leaving a
single register_node() function.

The second patch merges unregister_one_node() and unregister_node(),
leaving a single unregister_node() function.

There are no functional changes in these patches.


This patch (of 2):

register_node() is only called from register_one_node().  This patch folds
register_node() into its only caller and renames register_one_node() to
register_node().

This reduces unnecessary indirection and simplifies the code structure. 
No functional changes are introduced.

[akpm@linux-foundation.org: fix kerneldoc, per David]
Link: https://lkml.kernel.org/r/cover.1760097207.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 
 arch/x86/mm/numa.c                         |    4 -
 drivers/base/node.c                        |   52 +++++++------------
 include/linux/node.h                       |    4 -
 mm/memory_hotplug.c                        |    4 -
 mm/mm_init.c                               |    2 
 6 files changed, 28 insertions(+), 40 deletions(-)

--- a/arch/powerpc/platforms/pseries/pci_dlpar.c~drivers-base-node-fold-register_node-into-register_one_node
+++ a/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -29,7 +29,7 @@ struct pci_controller *init_phb_dynamic(
 	nid = of_node_to_nid(dn);
 	if (likely((nid) >= 0)) {
 		if (!node_online(nid)) {
-			if (register_one_node(nid)) {
+			if (register_node(nid)) {
 				pr_err("PCI: Failed to register node %d\n", nid);
 			} else {
 				update_numa_distance(dn);
--- a/arch/x86/mm/numa.c~drivers-base-node-fold-register_node-into-register_one_node
+++ a/arch/x86/mm/numa.c
@@ -262,7 +262,7 @@ void __init init_gi_nodes(void)
 	 * bringup_nonboot_cpus
 	 *  cpu_up
 	 *   __try_online_node
-	 *    register_one_node
+	 *    register_node
 	 * because node_subsys is not initialized yet.
 	 * TODO remove dependency on node_online
 	 */
@@ -303,7 +303,7 @@ void __init init_cpu_to_node(void)
 		 * bringup_nonboot_cpus
 		 *  cpu_up
 		 *   __try_online_node
-		 *    register_one_node
+		 *    register_node
 		 * because node_subsys is not initialized yet.
 		 * TODO remove dependency on node_online
 		 */
--- a/drivers/base/node.c~drivers-base-node-fold-register_node-into-register_one_node
+++ a/drivers/base/node.c
@@ -676,33 +676,6 @@ static void node_device_release(struct d
 	kfree(to_node(dev));
 }
 
-/*
- * register_node - Setup a sysfs device for a node.
- * @num - Node number to use when creating the device.
- *
- * Initialize and register the node device.
- */
-static int register_node(struct node *node, int num)
-{
-	int error;
-
-	node->dev.id = num;
-	node->dev.bus = &node_subsys;
-	node->dev.release = node_device_release;
-	node->dev.groups = node_dev_groups;
-	error = device_register(&node->dev);
-
-	if (error) {
-		put_device(&node->dev);
-	} else {
-		hugetlb_register_node(node);
-		compaction_register_node(node);
-		reclaim_register_node(node);
-	}
-
-	return error;
-}
-
 /**
  * unregister_node - unregister a node device
  * @node: node going away
@@ -907,7 +880,13 @@ void register_memory_blocks_under_node_h
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-int register_one_node(int nid)
+/**
+ * register_node - Initialize and register the node device.
+ * @nid: Node number to use when creating the device.
+ *
+ * Return: 0 on success, -errno otherwise
+ */
+int register_node(int nid)
 {
 	int error;
 	int cpu;
@@ -918,14 +897,23 @@ int register_one_node(int nid)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&node->access_list);
-	node_devices[nid] = node;
 
-	error = register_node(node_devices[nid], nid);
+	node->dev.id = nid;
+	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
+	node->dev.groups = node_dev_groups;
+
+	error = device_register(&node->dev);
 	if (error) {
-		node_devices[nid] = NULL;
+		put_device(&node->dev);
 		return error;
 	}
 
+	node_devices[nid] = node;
+	hugetlb_register_node(node);
+	compaction_register_node(node);
+	reclaim_register_node(node);
+
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
 		if (cpu_to_node(cpu) == nid)
@@ -1018,7 +1006,7 @@ void __init node_dev_init(void)
 	 * to already created cpu devices.
 	 */
 	for_each_online_node(i) {
-		ret =  register_one_node(i);
+		ret =  register_node(i);
 		if (ret)
 			panic("%s() failed to add node: %d\n", __func__, ret);
 	}
--- a/include/linux/node.h~drivers-base-node-fold-register_node-into-register_one_node
+++ a/include/linux/node.h
@@ -176,7 +176,7 @@ static inline int hotplug_node_notifier(
 #ifdef CONFIG_NUMA
 extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
-extern int register_one_node(int nid);
+int register_node(int nid);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
@@ -189,7 +189,7 @@ extern int register_memory_node_under_co
 static inline void node_dev_init(void)
 {
 }
-static inline int register_one_node(int nid)
+static inline int register_node(int nid)
 {
 	return 0;
 }
--- a/mm/memory_hotplug.c~drivers-base-node-fold-register_node-into-register_one_node
+++ a/mm/memory_hotplug.c
@@ -1311,7 +1311,7 @@ static int __try_online_node(int nid, bo
 
 	if (set_node_online) {
 		node_set_online(nid);
-		ret = register_one_node(nid);
+		ret = register_node(nid);
 		BUG_ON(ret);
 	}
 out:
@@ -1542,7 +1542,7 @@ int add_memory_resource(int nid, struct
 		goto error_memblock_remove;
 	if (ret) {
 		node_set_online(nid);
-		ret = register_one_node(nid);
+		ret = register_node(nid);
 		if (WARN_ON(ret)) {
 			node_set_offline(nid);
 			goto error_memblock_remove;
--- a/mm/mm_init.c~drivers-base-node-fold-register_node-into-register_one_node
+++ a/mm/mm_init.c
@@ -1909,7 +1909,7 @@ void __init free_area_init(unsigned long
 		free_area_init_node(nid);
 
 		/*
-		 * No sysfs hierarchy will be created via register_one_node()
+		 * No sysfs hierarchy will be created via register_node()
 		 *for memory-less node because here it's not marked as N_MEMORY
 		 *and won't be set online later. The benefit is userspace
 		 *program won't be confused by sysfs files/directories of
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


