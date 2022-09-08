Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AD6C54EE9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIHWSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiIHWSf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 18:18:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBC5165BF
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 15:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B8D961E15
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 22:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB04EC433C1;
        Thu,  8 Sep 2022 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662675513;
        bh=O2ys2VyjCE5vA0H+MnUESCtQE2sKiZPiGGfKwVkcDms=;
        h=Date:To:From:Subject:From;
        b=XnzC9TrUlchCugYGKFe7/YQcmsme3iPGgBD/pDmHcVyanDxspqPncF6AaSZYhQEEd
         bOtyKeF/UYyw9dBUDZLmfxajT1Er4uJ/kq4vF9i9N21ihBv65HkXiyX8eVz3UWeQ0G
         hv/8/AKT7E8D/QXnWC7Fi5iXB8bKVIyUfQHzHTeM=
Date:   Thu, 08 Sep 2022 15:18:32 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rientjes@google.com, rafael@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, gregkh@linuxfoundation.org,
        david@redhat.com, aneesh.kumar@linux.ibm.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-eliminate-memory-less-nodes-handling.patch added to mm-unstable branch
Message-Id: <20220908221832.DB04EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: eliminate memoryless nodes handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-eliminate-memory-less-nodes-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-eliminate-memory-less-nodes-handling.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: eliminate memoryless nodes handling
Date: Thu, 8 Sep 2022 15:58:26 +0800

The memory-notify-based approach aims to handle meoryless nodes, however
it just adds complexity to the code as pointed out by David in [1]. 

The handling of memoryless nodes is introduced by commit 4faf8d950ec4
("hugetlb: handle memory hot-plug events").  In its commit message we
cannot find any necessity of handling this case.  So we can simply
register/unregister sysfs entries in register_node/unregister_node to
simlify the code.

BTW, the hotplug callback was added because in
hugetlb_register_all_nodes() we register sysfs nodes only for N_MEMORY
nodes - see commit 9b5e5d0fdc91, which said it was a preparation for
handling memoryless nodes via memory hotplug.  Since we want to remove
memory hotplug, make sure we only register per-node sysfs for online
(N_ONLINE) nodes in hugetlb_register_all_nodes().

https://lore.kernel.org/linux-mm/60933ffc-b850-976c-78a0-0ee6e0ea9ef0@redhat.com/ [1]
Link: https://lkml.kernel.org/r/20220908075826.37094-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c     |    8 ++-
 include/linux/hugetlb.h |   14 ++++++
 mm/hugetlb.c            |   82 +++++++++++++++++---------------------
 3 files changed, 58 insertions(+), 46 deletions(-)

--- a/drivers/base/node.c~mm-hugetlb-eliminate-memory-less-nodes-handling
+++ a/drivers/base/node.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/hugetlb.h>
 
 static struct bus_type node_subsys = {
 	.name = "node",
@@ -608,10 +609,12 @@ static int register_node(struct node *no
 	node->dev.groups = node_dev_groups;
 	error = device_register(&node->dev);
 
-	if (error)
+	if (error) {
 		put_device(&node->dev);
-	else
+	} else {
+		hugetlb_register_node(node);
 		compaction_register_node(node);
+	}
 
 	return error;
 }
@@ -625,6 +628,7 @@ static int register_node(struct node *no
  */
 void unregister_node(struct node *node)
 {
+	hugetlb_unregister_node(node);
 	compaction_unregister_node(node);
 	node_remove_accesses(node);
 	node_remove_caches(node);
--- a/include/linux/hugetlb.h~mm-hugetlb-eliminate-memory-less-nodes-handling
+++ a/include/linux/hugetlb.h
@@ -16,6 +16,7 @@
 struct ctl_table;
 struct user_struct;
 struct mmu_gather;
+struct node;
 
 #ifndef is_hugepd
 typedef struct { unsigned long pd; } hugepd_t;
@@ -935,6 +936,11 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
+#ifdef CONFIG_NUMA
+void hugetlb_register_node(struct node *node);
+void hugetlb_unregister_node(struct node *node);
+#endif
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
@@ -1109,6 +1115,14 @@ static inline void set_huge_pte_at(struc
 				   pte_t *ptep, pte_t pte)
 {
 }
+
+static inline void hugetlb_register_node(struct node *node)
+{
+}
+
+static inline void hugetlb_unregister_node(struct node *node)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-eliminate-memory-less-nodes-handling
+++ a/mm/hugetlb.c
@@ -3864,24 +3864,14 @@ static int hugetlb_sysfs_add_hstate(stru
 	return 0;
 }
 
-static void __init hugetlb_sysfs_init(void)
-{
-	struct hstate *h;
-	int err;
-
-	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
-	if (!hugepages_kobj)
-		return;
+#ifdef CONFIG_NUMA
+static bool hugetlb_sysfs_initialized __ro_after_init;
 
-	for_each_hstate(h) {
-		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
-					 hstate_kobjs, &hstate_attr_group);
-		if (err)
-			pr_err("HugeTLB: Unable to add hstate %s", h->name);
-	}
+static inline void hugetlb_mark_sysfs_initialized(void)
+{
+	hugetlb_sysfs_initialized = true;
 }
 
-#ifdef CONFIG_NUMA
 
 /*
  * node_hstate/s - associate per node hstate attributes, via their kobjects,
@@ -3937,7 +3927,7 @@ static struct hstate *kobj_to_node_hstat
  * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
-static void hugetlb_unregister_node(struct node *node)
+void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
@@ -3967,19 +3957,22 @@ static void hugetlb_unregister_node(stru
  * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
-static int hugetlb_register_node(struct node *node)
+void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
 	int err;
 
+	if (!hugetlb_sysfs_initialized)
+		return;
+
 	if (nhs->hugepages_kobj)
-		return 0;		/* already allocated */
+		return;		/* already allocated */
 
 	nhs->hugepages_kobj = kobject_create_and_add("hugepages",
 							&node->dev.kobj);
 	if (!nhs->hugepages_kobj)
-		return -ENOMEM;
+		return;
 
 	for_each_hstate(h) {
 		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
@@ -3989,28 +3982,9 @@ static int hugetlb_register_node(struct
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
 				h->name, node->dev.id);
 			hugetlb_unregister_node(node);
-			return -ENOMEM;
+			break;
 		}
 	}
-	return 0;
-}
-
-static int __meminit hugetlb_memory_callback(struct notifier_block *self,
-					     unsigned long action, void *arg)
-{
-	int ret = 0;
-	struct memory_notify *mnb = arg;
-	int nid = mnb->status_change_nid;
-
-	if (nid == NUMA_NO_NODE)
-		return NOTIFY_DONE;
-
-	if (action == MEM_GOING_ONLINE)
-		ret = hugetlb_register_node(node_devices[nid]);
-	else if (action == MEM_CANCEL_ONLINE || action == MEM_OFFLINE)
-		hugetlb_unregister_node(node_devices[nid]);
-
-	return notifier_from_errno(ret);
 }
 
 /*
@@ -4022,11 +3996,8 @@ static void __init hugetlb_register_all_
 {
 	int nid;
 
-	get_online_mems();
-	hotplug_memory_notifier(hugetlb_memory_callback, 0);
-	for_each_node_state(nid, N_MEMORY)
+	for_each_online_node(nid)
 		hugetlb_register_node(node_devices[nid]);
-	put_online_mems();
 }
 #else	/* !CONFIG_NUMA */
 
@@ -4040,8 +4011,32 @@ static struct hstate *kobj_to_node_hstat
 
 static void hugetlb_register_all_nodes(void) { }
 
+static inline void hugetlb_mark_sysfs_initialized(void)
+{
+}
+
 #endif
 
+static void __init hugetlb_sysfs_init(void)
+{
+	struct hstate *h;
+	int err;
+
+	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
+	if (!hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
+					 hstate_kobjs, &hstate_attr_group);
+		if (err)
+			pr_err("HugeTLB: Unable to add hstate %s", h->name);
+	}
+
+	hugetlb_mark_sysfs_initialized();
+	hugetlb_register_all_nodes();
+}
+
 #ifdef CONFIG_CMA
 static void __init hugetlb_cma_check(void);
 #else
@@ -4104,7 +4099,6 @@ static int __init hugetlb_init(void)
 	report_hugepages();
 
 	hugetlb_sysfs_init();
-	hugetlb_register_all_nodes();
 	hugetlb_cgroup_file_init();
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch
mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch
mm-hugetlb-eliminate-memory-less-nodes-handling.patch

