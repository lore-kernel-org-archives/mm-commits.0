Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8C6EB64DC
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 16:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjGFQak (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjGFQaj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 12:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F28199F
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 09:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D064260BFF
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 16:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262D6C433C8;
        Thu,  6 Jul 2023 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688661036;
        bh=IHIBMpC1w/KXxA7dwIOyfwJn/+SpQoWUYwQrJHODFVA=;
        h=Date:To:From:Subject:From;
        b=pJafSfCQhFNNyiuEYu0HcWUEMHQz8vSvCg5uTn27QG+iCUQFUbwxVKX25x4nW1k27
         n01AenFCBwEPBjBVqX1jNJkCQhasa9lcPWRejYA7UOJKXCs9AbyOAHvdXXu6v21WUl
         3z7twS/g1OGx0JmKrd6AFSNm3pAkZOyGhuXFRc9Q=
Date:   Thu, 06 Jul 2023 09:30:35 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        yangx.jy@fujitsu.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, dan.j.williams@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-rename-destroy_memory_type-to-put_memory_type.patch added to mm-unstable branch
Message-Id: <20230706163036.262D6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory tier: rename destroy_memory_type() to put_memory_type()
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-rename-destroy_memory_type-to-put_memory_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-rename-destroy_memory_type-to-put_memory_type.patch

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

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch

