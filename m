Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBA4C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiINW2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiINW2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:28:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206C1326CD
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A47A9B81CEC
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAF4C433C1;
        Wed, 14 Sep 2022 22:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663194514;
        bh=ap19U3UYqFgQWuA52gmmTzGpqKv7a7LgEw52qHDIRXE=;
        h=Date:To:From:Subject:From;
        b=A8QjhT64G5fVw6wvdL2iWl+uJadHPDneLDgvCrlg/7ydw3402CLgZ5LzktSNu0qru
         /kIKlJGNd2Nm15TPdzIsBRa+Q+zTVdOj+TdR7/AGwFL+riaF+9fXLhpwtTPC/A7vjP
         4BAFrquD5/ZK43IB/vrpLroLNLmvr/ST+bUrEv/o=
Date:   Wed, 14 Sep 2022 15:28:33 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, gregkh@linuxfoundation.org,
        david@redhat.com, andi@firstfloor.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-eliminate-memory-less-nodes-handling.patch added to mm-unstable branch
Message-Id: <20220914222834.5AAF4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: eliminate memory-less nodes handling
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
Subject: mm: hugetlb: eliminate memory-less nodes handling
Date: Wed, 14 Sep 2022 15:26:03 +0800

The memory-notify-based approach aims to handle meory-less nodes, however,
it just adds the complexity of code as pointed by David in thread [1]. 
The handling of memory-less nodes is introduced by commit 4faf8d950ec4
("hugetlb: handle memory hot-plug events").  >From its commit message, we
cannot find any necessity of handling this case.  So, we can simply
register/unregister sysfs entries in register_node/unregister_node to
simlify the code.

BTW, hotplug callback added because in hugetlb_register_all_nodes() we
register sysfs nodes only for N_MEMORY nodes, seeing commit 9b5e5d0fdc91,
which said it was a preparation for handling memory-less nodes via memory
hotplug.  Since we want to remove memory hotplug, so make sure we only
register per-node sysfs for online (N_ONLINE) nodes in
hugetlb_register_all_nodes().

https://lore.kernel.org/linux-mm/60933ffc-b850-976c-78a0-0ee6e0ea9ef0@redhat.com/ [1]
Link: https://lkml.kernel.org/r/20220914072603.60293-3-songmuchun@bytedance.com
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c     |    8 +++-
 include/linux/hugetlb.h |   14 +++++++
 mm/hugetlb.c            |   70 +++++++++++++++-----------------------
 3 files changed, 49 insertions(+), 43 deletions(-)

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
@@ -3871,24 +3871,8 @@ static int hugetlb_sysfs_add_hstate(stru
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
-
-	for_each_hstate(h) {
-		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
-					 hstate_kobjs, &hstate_attr_group);
-		if (err)
-			pr_err("HugeTLB: Unable to add hstate %s", h->name);
-	}
-}
-
 #ifdef CONFIG_NUMA
+static bool hugetlb_sysfs_initialized __ro_after_init;
 
 /*
  * node_hstate/s - associate per node hstate attributes, via their kobjects,
@@ -3944,7 +3928,7 @@ static struct hstate *kobj_to_node_hstat
  * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
-static void hugetlb_unregister_node(struct node *node)
+void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
@@ -3974,12 +3958,15 @@ static void hugetlb_unregister_node(stru
  * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
-static void hugetlb_register_node(struct node *node)
+void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
 	int err;
 
+	if (!hugetlb_sysfs_initialized)
+		return;
+
 	if (nhs->hugepages_kobj)
 		return;		/* already allocated */
 
@@ -4001,23 +3988,6 @@ static void hugetlb_register_node(struct
 	}
 }
 
-static int __meminit hugetlb_memory_callback(struct notifier_block *self,
-					     unsigned long action, void *arg)
-{
-	struct memory_notify *mnb = arg;
-	int nid = mnb->status_change_nid;
-
-	if (nid == NUMA_NO_NODE)
-		return NOTIFY_DONE;
-
-	if (action == MEM_GOING_ONLINE)
-		hugetlb_register_node(node_devices[nid]);
-	else if (action == MEM_CANCEL_ONLINE || action == MEM_OFFLINE)
-		hugetlb_unregister_node(node_devices[nid]);
-
-	return NOTIFY_OK;
-}
-
 /*
  * hugetlb init time:  register hstate attributes for all registered node
  * devices of nodes that have memory.  All on-line nodes should have
@@ -4027,11 +3997,8 @@ static void __init hugetlb_register_all_
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
 
@@ -4055,6 +4022,28 @@ static inline __init void hugetlb_cma_ch
 }
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
+#ifdef CONFIG_NUMA
+	hugetlb_sysfs_initialized = true;
+#endif
+	hugetlb_register_all_nodes();
+}
+
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -4109,7 +4098,6 @@ static int __init hugetlb_init(void)
 	report_hugepages();
 
 	hugetlb_sysfs_init();
-	hugetlb_register_all_nodes();
 	hugetlb_cgroup_file_init();
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-simplify-per-node-sysfs-creation-and-removal.patch
mm-hugetlb-eliminate-memory-less-nodes-handling.patch

