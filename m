Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C19C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiAaWSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:18:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37494 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWSQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:18:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13579615A2
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DE3C340E8;
        Mon, 31 Jan 2022 22:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667495;
        bh=0uJQOLNxDWtJRxWzDyG1CBTO0tW1suh+MKFJXJf73A0=;
        h=Date:To:From:Subject:From;
        b=UjSV/dxk30/9A2uBxkVaUf7neJ/P6uJUcMlyqNnk6Ajl85RWciTrmDS/R0aThGUR5
         f9jxnbwZVVBJ/MxcSlL1ugHUQ/jgDxnH5M87eq2WN/HYi1IyUZX++kNhJADwu8tnUE
         k8c9pMQmgGG6EypdqEFCAbst0pfRM9pmafobC6U0=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:18:13 -0800
Date:   Mon, 31 Jan 2022 14:18:13 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch added to -mm tree
Message-Id: <20220131221814.08DE3C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: make arch_alloc_nodedata independent on CONFIG_MEMORY_HOTPLUG
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: make arch_alloc_nodedata independent on CONFIG_MEMORY_HOTPLUG

Patch series "mm, memory_hotplug: handle unitialized numa node gracefully".

The core of the fix is patch 2 which also links existing bug reports.  The
high level goal is to have all possible numa nodes have their pgdat
allocated and initialized so 

	for_each_possible_node(nid)
		NODE_DATA(nid)

will never return garbage.  This has proven to be problem in several
places when an offline numa node is used for an allocation just to realize
that node_data and therefore allocation fallback zonelists are not
initialized and such an allocation request blows up.

There were attempts to address that by checking node_online in several
places including the page allocator.  This patchset approaches the problem
from a different perspective and instead of special casing, which just
adds a runtime overhead, it allocates pglist_data for each possible node. 
This can add some memory overhead for platforms with high number of
possible nodes if they do not contain any memory.  This should be a rather
rare configuration though.

How to test this? David has provided and excellent howto:
http://lkml.kernel.org/r/6e5ebc19-890c-b6dd-1924-9f25c441010d@redhat.com

Patches 1 and 3-6 are mostly cleanups.  The patchset has been reviewed by
Rafael (thanks!) and the core fix tested by Rafael and Alexey (thanks to
both).  David has tested as per instructions above and hasn't found any
fallouts in the memory hotplug scenarios.


This patch (of 6):

This is a preparatory patch and it doesn't introduce any functional
change.  It merely pulls out arch_alloc_nodedata (and co) outside of
CONFIG_MEMORY_HOTPLUG because the following patch will need to call this
from the generic MM code.

Link: https://lkml.kernel.org/r/20220127085305.20890-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20220127085305.20890-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c       |    2 
 include/linux/memory_hotplug.h |  119 +++++++++++++++----------------
 2 files changed, 59 insertions(+), 62 deletions(-)

--- a/arch/ia64/mm/discontig.c~mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug
+++ a/arch/ia64/mm/discontig.c
@@ -608,7 +608,6 @@ void __init paging_init(void)
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
 pg_data_t *arch_alloc_nodedata(int nid)
 {
 	unsigned long size = compute_pernodesize(nid);
@@ -626,7 +625,6 @@ void arch_refresh_nodedata(int update_no
 	pgdat_list[update_node] = update_pgdat;
 	scatter_node_data();
 }
-#endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug
+++ a/include/linux/memory_hotplug.h
@@ -16,6 +16,65 @@ struct memory_group;
 struct resource;
 struct vmem_altmap;
 
+#ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
+/*
+ * For supporting node-hotadd, we have to allocate a new pgdat.
+ *
+ * If an arch has generic style NODE_DATA(),
+ * node_data[nid] = kzalloc() works well. But it depends on the architecture.
+ *
+ * In general, generic_alloc_nodedata() is used.
+ * Now, arch_free_nodedata() is just defined for error path of node_hot_add.
+ *
+ */
+extern pg_data_t *arch_alloc_nodedata(int nid);
+extern void arch_free_nodedata(pg_data_t *pgdat);
+extern void arch_refresh_nodedata(int nid, pg_data_t *pgdat);
+
+#else /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
+
+#define arch_alloc_nodedata(nid)	generic_alloc_nodedata(nid)
+#define arch_free_nodedata(pgdat)	generic_free_nodedata(pgdat)
+
+#ifdef CONFIG_NUMA
+/*
+ * XXX: node aware allocation can't work well to get new node's memory at this time.
+ *	Because, pgdat for the new node is not allocated/initialized yet itself.
+ *	To use new node's memory, more consideration will be necessary.
+ */
+#define generic_alloc_nodedata(nid)				\
+({								\
+	kzalloc(sizeof(pg_data_t), GFP_KERNEL);			\
+})
+/*
+ * This definition is just for error path in node hotadd.
+ * For node hotremove, we have to replace this.
+ */
+#define generic_free_nodedata(pgdat)	kfree(pgdat)
+
+extern pg_data_t *node_data[];
+static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
+{
+	node_data[nid] = pgdat;
+}
+
+#else /* !CONFIG_NUMA */
+
+/* never called */
+static inline pg_data_t *generic_alloc_nodedata(int nid)
+{
+	BUG();
+	return NULL;
+}
+static inline void generic_free_nodedata(pg_data_t *pgdat)
+{
+}
+static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
+{
+}
+#endif /* CONFIG_NUMA */
+#endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
 
@@ -154,66 +213,6 @@ int add_pages(int nid, unsigned long sta
 	      struct mhp_params *params);
 #endif /* ARCH_HAS_ADD_PAGES */
 
-#ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
-/*
- * For supporting node-hotadd, we have to allocate a new pgdat.
- *
- * If an arch has generic style NODE_DATA(),
- * node_data[nid] = kzalloc() works well. But it depends on the architecture.
- *
- * In general, generic_alloc_nodedata() is used.
- * Now, arch_free_nodedata() is just defined for error path of node_hot_add.
- *
- */
-extern pg_data_t *arch_alloc_nodedata(int nid);
-extern void arch_free_nodedata(pg_data_t *pgdat);
-extern void arch_refresh_nodedata(int nid, pg_data_t *pgdat);
-
-#else /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
-
-#define arch_alloc_nodedata(nid)	generic_alloc_nodedata(nid)
-#define arch_free_nodedata(pgdat)	generic_free_nodedata(pgdat)
-
-#ifdef CONFIG_NUMA
-/*
- * If ARCH_HAS_NODEDATA_EXTENSION=n, this func is used to allocate pgdat.
- * XXX: kmalloc_node() can't work well to get new node's memory at this time.
- *	Because, pgdat for the new node is not allocated/initialized yet itself.
- *	To use new node's memory, more consideration will be necessary.
- */
-#define generic_alloc_nodedata(nid)				\
-({								\
-	kzalloc(sizeof(pg_data_t), GFP_KERNEL);			\
-})
-/*
- * This definition is just for error path in node hotadd.
- * For node hotremove, we have to replace this.
- */
-#define generic_free_nodedata(pgdat)	kfree(pgdat)
-
-extern pg_data_t *node_data[];
-static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	node_data[nid] = pgdat;
-}
-
-#else /* !CONFIG_NUMA */
-
-/* never called */
-static inline pg_data_t *generic_alloc_nodedata(int nid)
-{
-	BUG();
-	return NULL;
-}
-static inline void generic_free_nodedata(pg_data_t *pgdat)
-{
-}
-static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-}
-#endif /* CONFIG_NUMA */
-#endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
-
 void get_online_mems(void);
 void put_online_mems(void);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
mm-handle-uninitialized-numa-nodes-gracefully.patch
mm-memory_hotplug-drop-arch_free_nodedata.patch
mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

