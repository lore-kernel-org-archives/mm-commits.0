Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E36C04FDF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 17:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjHBROO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjHBROK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 13:14:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AADD9
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 10:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD7C61A56
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 17:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB11AC433C8;
        Wed,  2 Aug 2023 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690996448;
        bh=POv4qgOW5y9KcxI87mJMmmT2++PJon9nNOT81WeyDn8=;
        h=Date:To:From:Subject:From;
        b=qMesMUqb0dobK0GlMDrBvg++dq9xa1PeW8GzJO1HjcAfd/abfaR/63a3k0bsnTe4y
         iKH1WoFmB9JBHZxd5tgi5WVJ164eXUCPJmdh4IEHYUlIli3MtAM0ratYyCENBvpmu+
         sWcUoQ0ZRwrDgtVnFiN5zFMCDkoFnWQ0jq+xYwqk=
Date:   Wed, 02 Aug 2023 10:14:07 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rafael@kernel.org, lenb@kernel.org, aneesh.kumar@linux.ibm.com,
        lizhijian@cn.fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpimm-fix-typo-sibiling-sibling.patch added to mm-unstable branch
Message-Id: <20230802171407.EB11AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi,mm: fix typo sibiling -> sibling
has been added to the -mm mm-unstable branch.  Its filename is
     acpimm-fix-typo-sibiling-sibling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpimm-fix-typo-sibiling-sibling.patch

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
From: Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: acpi,mm: fix typo sibiling -> sibling
Date: Wed, 2 Aug 2023 17:28:56 +0800

First found this typo as reviewing memory tier code. Fix it by sed like:
$ sed -i 's/sibiling/sibling/g' $(git grep -l sibiling)

so the acpi one will be corrected as well.

Link: https://lkml.kernel.org/r/20230802092856.819328-1-lizhijian@cn.fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_pad.c      |    2 +-
 include/linux/memory-tiers.h |    2 +-
 mm/memory-tiers.c            |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/acpi/acpi_pad.c~acpimm-fix-typo-sibiling-sibling
+++ a/drivers/acpi/acpi_pad.c
@@ -100,7 +100,7 @@ static void round_robin_cpu(unsigned int
 	for_each_cpu(cpu, pad_busy_cpus)
 		cpumask_or(tmp, tmp, topology_sibling_cpumask(cpu));
 	cpumask_andnot(tmp, cpu_online_mask, tmp);
-	/* avoid HT sibilings if possible */
+	/* avoid HT siblings if possible */
 	if (cpumask_empty(tmp))
 		cpumask_andnot(tmp, cpu_online_mask, pad_busy_cpus);
 	if (cpumask_empty(tmp)) {
--- a/include/linux/memory-tiers.h~acpimm-fix-typo-sibiling-sibling
+++ a/include/linux/memory-tiers.h
@@ -23,7 +23,7 @@
 struct memory_tier;
 struct memory_dev_type {
 	/* list of memory types that are part of same tier as this type */
-	struct list_head tier_sibiling;
+	struct list_head tier_sibling;
 	/* list of memory types that are managed by one driver */
 	struct list_head list;
 	/* abstract distance for this specific memory type */
--- a/mm/memory-tiers.c~acpimm-fix-typo-sibiling-sibling
+++ a/mm/memory-tiers.c
@@ -118,7 +118,7 @@ static __always_inline nodemask_t get_me
 	nodemask_t nodes = NODE_MASK_NONE;
 	struct memory_dev_type *memtype;
 
-	list_for_each_entry(memtype, &memtier->memory_types, tier_sibiling)
+	list_for_each_entry(memtype, &memtier->memory_types, tier_sibling)
 		nodes_or(nodes, nodes, memtype->nodes);
 
 	return nodes;
@@ -177,7 +177,7 @@ static struct memory_tier *find_create_m
 	 * If the memtype is already part of a memory tier,
 	 * just return that.
 	 */
-	if (!list_empty(&memtype->tier_sibiling)) {
+	if (!list_empty(&memtype->tier_sibling)) {
 		list_for_each_entry(memtier, &memory_tiers, list) {
 			if (adistance == memtier->adistance_start)
 				return memtier;
@@ -221,7 +221,7 @@ static struct memory_tier *find_create_m
 	memtier = new_memtier;
 
 link_memtype:
-	list_add(&memtype->tier_sibiling, &memtier->memory_types);
+	list_add(&memtype->tier_sibling, &memtier->memory_types);
 	return memtier;
 }
 
@@ -530,7 +530,7 @@ static bool clear_node_memory_tier(int n
 		memtype = node_memory_types[node].memtype;
 		node_clear(node, memtype->nodes);
 		if (nodes_empty(memtype->nodes)) {
-			list_del_init(&memtype->tier_sibiling);
+			list_del_init(&memtype->tier_sibling);
 			if (list_empty(&memtier->memory_types))
 				destroy_memory_tier(memtier);
 		}
@@ -556,7 +556,7 @@ struct memory_dev_type *alloc_memory_typ
 		return ERR_PTR(-ENOMEM);
 
 	memtype->adistance = adistance;
-	INIT_LIST_HEAD(&memtype->tier_sibiling);
+	INIT_LIST_HEAD(&memtype->tier_sibling);
 	memtype->nodes  = NODE_MASK_NONE;
 	kref_init(&memtype->kref);
 	return memtype;
_

Patches currently in -mm which might be from lizhijian@cn.fujitsu.com are

acpimm-fix-typo-sibiling-sibling.patch

