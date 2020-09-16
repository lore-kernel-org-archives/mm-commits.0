Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4C3C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677052083B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600297190;
	bh=HwVMwbYrf9cYH1tpDAiAXQ4aQm6MslpOgA8nNdJyONE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=R6j1rZVOFIh9Q5hCLJC9jHoIY+WKD2n4Fs6F1xFxGS0V7L25VuNUBHYlpcsBGZENj
	 XFwobxNZO7VBcL4JPX/5LWEl1/WEFAFv4Xz2uLfgD6/7zavJElCUeBw766FWkHLEtb
	 EWn6gTBjaLqgjiUF7PTwtxAHxYVEZju6cP/ukge0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIPW7t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPW7t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:59:49 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C731B221EE;
        Wed, 16 Sep 2020 22:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600297188;
        bh=HwVMwbYrf9cYH1tpDAiAXQ4aQm6MslpOgA8nNdJyONE=;
        h=Date:From:To:Subject:From;
        b=lQSEnfmsSqX8Oz0BeQOwZPDAZNnqJmUCd0aHGbVhcIHS9ga1pjbLpLI5zdUmkdw+V
         y+WTTTP+7hm8xcLX6DgDzNB+Ty+lLE16EBRXATwEjmehGQpsOpgN03XZHX05ZxN2bw
         mE59DIJZXqSYfVfQn7RNLl5kARo4S31Qm1KAe+PE=
Date:   Wed, 16 Sep 2020 15:59:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        chris@chrisdown.name, songmuchun@bytedance.com
Subject:  [to-be-updated]
 mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3.patch
 removed from -mm tree
Message-ID: <20200916225947.iusMy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3

 1. Fix compiler error on powerpc architecture reported by kernel test robot.
 2. Fix a typo from "anno" to "anon".

Link: https://lkml.kernel.org/r/20200913070010.44053-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   85 +++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 31 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3
+++ a/mm/memcontrol.c
@@ -6384,6 +6384,52 @@ static int memory_stat_show(struct seq_f
 }
 
 #ifdef CONFIG_NUMA
+struct numa_stat {
+	const char *name;
+	unsigned int ratio;
+	enum node_stat_item idx;
+};
+
+static struct numa_stat numa_stats[] = {
+	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
+	{ "file", PAGE_SIZE, NR_FILE_PAGES },
+	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
+	{ "shmem", PAGE_SIZE, NR_SHMEM },
+	{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
+	{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
+	{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * The ratio will be initialized in numa_stats_init(). Because
+	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
+	 * constant(e.g. powerpc).
+	 */
+	{ "anon_thp", 0, NR_ANON_THPS },
+#endif
+	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
+	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
+	{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
+	{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
+	{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
+	{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
+	{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
+};
+
+static int __init numa_stats_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (numa_stats[i].idx == NR_ANON_THPS)
+			numa_stats[i].ratio = HPAGE_PMD_SIZE;
+#endif
+	}
+
+	return 0;
+}
+pure_initcall(numa_stats_init);
+
 static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
 					   unsigned int nid,
 					   enum node_stat_item idx)
@@ -6394,33 +6440,7 @@ static unsigned long memcg_node_page_sta
 
 static const char *memory_numa_stat_format(struct mem_cgroup *memcg)
 {
-	struct numa_stat {
-		const char *name;
-		unsigned int ratio;
-		enum node_stat_item idx;
-	};
-
-	static const struct numa_stat stats[] = {
-		{ "anno", PAGE_SIZE, NR_ANON_MAPPED },
-		{ "file", PAGE_SIZE, NR_FILE_PAGES },
-		{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
-		{ "shmem", PAGE_SIZE, NR_SHMEM },
-		{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
-		{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
-		{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		{ "anon_thp", HPAGE_PMD_SIZE, NR_ANON_THPS },
-#endif
-		{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
-		{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
-		{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
-		{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
-		{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
-		{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
-		{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
-	};
-
-	int i, nid;
+	int i;
 	struct seq_buf s;
 
 	/* Reserve a byte for the trailing null */
@@ -6428,13 +6448,16 @@ static const char *memory_numa_stat_form
 	if (!s.buffer)
 		return NULL;
 
-	for (i = 0; i < ARRAY_SIZE(stats); i++) {
-		seq_buf_printf(&s, "%s", stats[i].name);
+	for (i = 0; i < ARRAY_SIZE(numa_stats); i++) {
+		int nid;
+
+		seq_buf_printf(&s, "%s", numa_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 
-			size = memcg_node_page_state(memcg, nid, stats[i].idx);
-			size *= stats[i].ratio;
+			size = memcg_node_page_state(memcg, nid,
+						     numa_stats[i].idx);
+			size *= numa_stats[i].ratio;
 			seq_buf_printf(&s, " N%d=%llu", nid, size);
 		}
 		seq_buf_putc(&s, '\n');
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

