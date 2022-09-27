Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEF2C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiI0Cu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiI0Csp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4784B9F767
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5DC4B81903
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90517C433C1;
        Tue, 27 Sep 2022 02:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246896;
        bh=qJrmIucfSbxIXR6cIZl4gsiO64Vz4IbT4H3bFKRoNkw=;
        h=Date:To:From:Subject:From;
        b=oxnkQ6zL3VrNH2Au67PBIKR4Ezvx9EheFvj0hEUimWzi0R86IlR9Hs1MutjJA25zp
         1LXXuZu+VdDyl2TmqKs2cYR3X5jPHN2V5LtU9A1rEZrQgZvabtBgo52ZcTrgZhxtUi
         DwEMpvLkqv4r1oOUMtIfMsKlnSSOXRXd1BkpBkQQ=
Date:   Mon, 26 Sep 2022 19:48:15 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch removed from -mm tree
Message-Id: <20220927024816.90517C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: add hotplug callbacks to handle new numa node onlined
has been removed from the -mm tree.  Its filename was
     mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: add hotplug callbacks to handle new numa node onlined
Date: Thu, 18 Aug 2022 18:40:35 +0530

If the new NUMA node onlined doesn't have a abstract distance assigned,
the kernel adds the NUMA node to default memory tier.

[aneesh.kumar@linux.ibm.com: fix kernel error with memory hotplug]
  Link: https://lkml.kernel.org/r/20220825092019.379069-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20220818131042.113280-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    1 
 mm/memory-tiers.c            |   68 +++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

--- a/include/linux/memory-tiers.h~mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined
+++ a/include/linux/memory-tiers.h
@@ -14,6 +14,7 @@
  * the same memory tier.
  */
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
+#define MEMTIER_HOTPLUG_PRIO	100
 
 #ifdef CONFIG_NUMA
 #include <linux/types.h>
--- a/mm/memory-tiers.c~mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined
+++ a/mm/memory-tiers.c
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
+#include <linux/memory.h>
 #include <linux/memory-tiers.h>
 
 struct memory_tier {
@@ -105,6 +106,72 @@ static struct memory_tier *set_node_memo
 	return memtier;
 }
 
+static struct memory_tier *__node_get_memory_tier(int node)
+{
+	struct memory_dev_type *memtype;
+
+	memtype = node_memory_types[node];
+	if (memtype && node_isset(node, memtype->nodes))
+		return memtype->memtier;
+	return NULL;
+}
+
+static void destroy_memory_tier(struct memory_tier *memtier)
+{
+	list_del(&memtier->list);
+	kfree(memtier);
+}
+
+static bool clear_node_memory_tier(int node)
+{
+	bool cleared = false;
+	struct memory_tier *memtier;
+
+	memtier = __node_get_memory_tier(node);
+	if (memtier) {
+		struct memory_dev_type *memtype;
+
+		memtype = node_memory_types[node];
+		node_clear(node, memtype->nodes);
+		if (nodes_empty(memtype->nodes)) {
+			list_del_init(&memtype->tier_sibiling);
+			memtype->memtier = NULL;
+			if (list_empty(&memtier->memory_types))
+				destroy_memory_tier(memtier);
+		}
+		cleared = true;
+	}
+	return cleared;
+}
+
+static int __meminit memtier_hotplug_callback(struct notifier_block *self,
+					      unsigned long action, void *_arg)
+{
+	struct memory_notify *arg = _arg;
+
+	/*
+	 * Only update the node migration order when a node is
+	 * changing status, like online->offline.
+	 */
+	if (arg->status_change_nid < 0)
+		return notifier_from_errno(0);
+
+	switch (action) {
+	case MEM_OFFLINE:
+		mutex_lock(&memory_tier_lock);
+		clear_node_memory_tier(arg->status_change_nid);
+		mutex_unlock(&memory_tier_lock);
+		break;
+	case MEM_ONLINE:
+		mutex_lock(&memory_tier_lock);
+		set_node_memory_tier(arg->status_change_nid);
+		mutex_unlock(&memory_tier_lock);
+		break;
+	}
+
+	return notifier_from_errno(0);
+}
+
 static int __init memory_tier_init(void)
 {
 	int node;
@@ -126,6 +193,7 @@ static int __init memory_tier_init(void)
 	}
 	mutex_unlock(&memory_tier_lock);
 
+	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRIO);
 	return 0;
 }
 subsys_initcall(memory_tier_init);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


