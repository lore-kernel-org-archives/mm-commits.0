Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97F5C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbjHKXAO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjHKW7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4D93593
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FDE65772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B46C433C8;
        Fri, 11 Aug 2023 22:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794766;
        bh=UhIVZ8XctRUioF2//XJd/DLs1QFuP2GgpmLKKVgAvcQ=;
        h=Date:To:From:Subject:From;
        b=unF7DQI11qCGKo4qnZZZBR+/BSMnAZX6Jgey3qPtTf+fcbIho2YuRL2mgspzlTzLt
         HewK20VllGpgqtFkspW0fHI07FxfdgvVFrYB7XuZgU0r/rD2Fw6v7pDg3A+25j7QPK
         zPHYR0vYZpP5xWEOU/W3oY8FL8SRG5Noz0uBXH4o=
Date:   Fri, 11 Aug 2023 15:59:26 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        yangx.jy@fujitsu.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, dan.j.williams@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-rename-destroy_memory_type-to-put_memory_type.patch removed from -mm tree
Message-Id: <20230811225926.B7B46C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tier: rename destroy_memory_type() to put_memory_type()
has been removed from the -mm tree.  Its filename was
     memory-tier-rename-destroy_memory_type-to-put_memory_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: rename destroy_memory_type() to put_memory_type()
Date: Thu, 6 Jul 2023 14:39:05 +0800

It appears that destroy_memory_type() isn't a very good name because we
usually will not free the memory_type here.  So rename it to a more
appropriate name i.e.  put_memory_type().

Link: https://lkml.kernel.org/r/20230706063905.543800-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Huang, Ying <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c           |    4 ++--
 include/linux/memory-tiers.h |    4 ++--
 mm/memory-tiers.c            |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/dax/kmem.c~memory-tier-rename-destroy_memory_type-to-put_memory_type
+++ a/drivers/dax/kmem.c
@@ -264,7 +264,7 @@ static int __init dax_kmem_init(void)
 	return rc;
 
 error_dax_driver:
-	destroy_memory_type(dax_slowmem_type);
+	put_memory_type(dax_slowmem_type);
 err_dax_slowmem_type:
 	kfree_const(kmem_name);
 	return rc;
@@ -275,7 +275,7 @@ static void __exit dax_kmem_exit(void)
 	dax_driver_unregister(&device_dax_kmem_driver);
 	if (!any_hotremove_failed)
 		kfree_const(kmem_name);
-	destroy_memory_type(dax_slowmem_type);
+	put_memory_type(dax_slowmem_type);
 }
 
 MODULE_AUTHOR("Intel Corporation");
--- a/include/linux/memory-tiers.h~memory-tier-rename-destroy_memory_type-to-put_memory_type
+++ a/include/linux/memory-tiers.h
@@ -33,7 +33,7 @@ struct memory_dev_type {
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
 struct memory_dev_type *alloc_memory_type(int adistance);
-void destroy_memory_type(struct memory_dev_type *memtype);
+void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 #ifdef CONFIG_MIGRATION
@@ -68,7 +68,7 @@ static inline struct memory_dev_type *al
 	return NULL;
 }
 
-static inline void destroy_memory_type(struct memory_dev_type *memtype)
+static inline void put_memory_type(struct memory_dev_type *memtype)
 {
 
 }
--- a/mm/memory-tiers.c~memory-tier-rename-destroy_memory_type-to-put_memory_type
+++ a/mm/memory-tiers.c
@@ -560,11 +560,11 @@ struct memory_dev_type *alloc_memory_typ
 }
 EXPORT_SYMBOL_GPL(alloc_memory_type);
 
-void destroy_memory_type(struct memory_dev_type *memtype)
+void put_memory_type(struct memory_dev_type *memtype)
 {
 	kref_put(&memtype->kref, release_memtype);
 }
-EXPORT_SYMBOL_GPL(destroy_memory_type);
+EXPORT_SYMBOL_GPL(put_memory_type);
 
 void init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
@@ -586,7 +586,7 @@ void clear_node_memory_type(int node, st
 	 */
 	if (!node_memory_types[node].map_count) {
 		node_memory_types[node].memtype = NULL;
-		destroy_memory_type(memtype);
+		put_memory_type(memtype);
 	}
 	mutex_unlock(&memory_tier_lock);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

