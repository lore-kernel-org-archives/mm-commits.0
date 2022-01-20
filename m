Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33ACC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347243AbiATVXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56530 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377810AbiATVXm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B18EB81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0293C340E0;
        Thu, 20 Jan 2022 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713820;
        bh=idumjjyJdLRh+i/linT2RTz1Ar6+fV4uwod20sqpiXk=;
        h=Date:From:To:Subject:From;
        b=Wm/KoCUGrtP2YwFPNU3J2qxbnjr6Q7dy1nz+qNheGlGqHzgHrhBA7dHuTMxXt0XwI
         PzNdPUpQ4GUrZVm11qu4TfMWJpFUCHLBtnnFf1pRasiniKvG6k/0eA9GJk1APfbJ1Y
         AdJdfNIGJ9+a3DA6h8wd52NEAlnFuGlgYQDI7Ycw=
Date:   Thu, 20 Jan 2022 13:23:39 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, songmuchun@bytedance.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-slab-make-slab-iterator-functions-static.patch removed from -mm tree
Message-ID: <20220120212339.y8XUrM_Fa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: make slab iterator functions static
has been removed from the -mm tree.  Its filename was
     mm-slab-make-slab-iterator-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: slab: make slab iterator functions static

There is no external users of slab_start/next/stop(), so make them static.
And the memory.kmem.slabinfo is deprecated, which outputs nothing now, so
move memcg_slab_show() into mm/memcontrol.c and rename it to
mem_cgroup_slab_show to be consistent with other function names.

Link: https://lkml.kernel.org/r/20211109133359.32881-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   13 ++++++++++++-
 mm/slab.h        |    5 -----
 mm/slab_common.c |   17 +++--------------
 3 files changed, 15 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~mm-slab-make-slab-iterator-functions-static
+++ a/mm/memcontrol.c
@@ -4845,6 +4845,17 @@ out_kfree:
 	return ret;
 }
 
+#if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
+static int mem_cgroup_slab_show(struct seq_file *m, void *p)
+{
+	/*
+	 * Deprecated.
+	 * Please, take a look at tools/cgroup/slabinfo.py .
+	 */
+	return 0;
+}
+#endif
+
 static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -4945,7 +4956,7 @@ static struct cftype mem_cgroup_legacy_f
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 	{
 		.name = "kmem.slabinfo",
-		.seq_show = memcg_slab_show,
+		.seq_show = mem_cgroup_slab_show,
 	},
 #endif
 	{
--- a/mm/slab_common.c~mm-slab-make-slab-iterator-functions-static
+++ a/mm/slab_common.c
@@ -1039,18 +1039,18 @@ static void print_slabinfo_header(struct
 	seq_putc(m, '\n');
 }
 
-void *slab_start(struct seq_file *m, loff_t *pos)
+static void *slab_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&slab_mutex);
 	return seq_list_start(&slab_caches, *pos);
 }
 
-void *slab_next(struct seq_file *m, void *p, loff_t *pos)
+static void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
 	return seq_list_next(p, &slab_caches, pos);
 }
 
-void slab_stop(struct seq_file *m, void *p)
+static void slab_stop(struct seq_file *m, void *p)
 {
 	mutex_unlock(&slab_mutex);
 }
@@ -1118,17 +1118,6 @@ void dump_unreclaimable_slab(void)
 	mutex_unlock(&slab_mutex);
 }
 
-#if defined(CONFIG_MEMCG_KMEM)
-int memcg_slab_show(struct seq_file *m, void *p)
-{
-	/*
-	 * Deprecated.
-	 * Please, take a look at tools/cgroup/slabinfo.py .
-	 */
-	return 0;
-}
-#endif
-
 /*
  * slabinfo_op - iterator that generates /proc/slabinfo
  *
--- a/mm/slab.h~mm-slab-make-slab-iterator-functions-static
+++ a/mm/slab.h
@@ -575,11 +575,6 @@ static inline struct kmem_cache_node *ge
 
 #endif
 
-void *slab_start(struct seq_file *m, loff_t *pos);
-void *slab_next(struct seq_file *m, void *p, loff_t *pos);
-void slab_stop(struct seq_file *m, void *p);
-int memcg_slab_show(struct seq_file *m, void *p);
-
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
 void dump_unreclaimable_slab(void);
 #else
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
proc-remove-pde_data-completely.patch

