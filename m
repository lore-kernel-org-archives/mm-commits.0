Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1EBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiANWEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiANWEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75EFC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD136B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08155C36AE9;
        Fri, 14 Jan 2022 22:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197842;
        bh=ix0Jn+5IN+yQioaMJD/5xRuRxcjZ6mnQSrrUSRw3vPE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X4yHtB5o6EhDvsZ1FfegyvcKLGZtRKSSAuW0o16y0xl3DhnQNzpuZzSQDLRdP8TYH
         n8PDyRkZDidwT0tpvdqWgr7NE3ZKB0LDztSBcic88Zgh4BOkazoHuHNawnvJ3cQXeg
         2sOSqAhgV4gdFJxA0itbyKnnFBoTguXP+9FbuYW4=
Date:   Fri, 14 Jan 2022 14:04:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 022/146] mm: slab: make slab iterator functions
 static
Message-ID: <20220114220401.-Yi3naZJB%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
