Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94483C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFB1221F1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600297186;
	bh=nh5GpOE2K7zDwAz85kQmBF7B/jtWfuqSu7fCirSxkGk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LPsMG98cTwUhphizZbKGf8xvj6tUWGdEn7qu066LK6yq8RYieVcvDOGi/B/AenkkJ
	 Kgn7ekEZ6Lp4uYwNywRmp6iq98pgVClIEDMTxwj0pK4ojmhu4KbvlNvpCPyjUJIz4M
	 bGXUhZfIdNHzz2jb2A/rIOfQTlpAy5qmXmKR5Rwo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIPW7p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPW7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:59:45 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68422083B;
        Wed, 16 Sep 2020 22:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600297185;
        bh=nh5GpOE2K7zDwAz85kQmBF7B/jtWfuqSu7fCirSxkGk=;
        h=Date:From:To:Subject:From;
        b=yk8e9J157331ucMnlePc3NXFZC3Y46VT4P8GzBzuNTORx674uahL5jBY2BuvVFvtA
         RIOWuyQ2ZjDxQB/TvAA+Lntt0gArsFGH5TfNEpMI9ZjHWXssQNWa0otsSBo+GC+zEn
         kMdsT/Tzn9jdTnbhU2otxpr8xzr8KZvr8FG9FODU=
Date:   Wed, 16 Sep 2020 15:59:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        chris@chrisdown.name, songmuchun@bytedance.com
Subject:  [to-be-updated]
 mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch removed
 from -mm tree
Message-ID: <20200916225943.mw2V7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add the missing numa_stat interface for cgroup v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: add the missing numa_stat interface for cgroup v2

In the cgroup v1, we have a numa_stat interface.  This is useful for
providing visibility into the numa locality information within an memcg
since the pages are allowed to be allocated from any physical node.  One
of the use cases is evaluating application performance by combining this
information with the application's CPU allocation.  But the cgroup v2 does
not.  So this patch adds the missing information.

Link: https://lkml.kernel.org/r/20200912154018.24910-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   72 ++++++++++++++++++
 mm/memcontrol.c                         |   84 ++++++++++++++++++++++
 2 files changed, 156 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1377,6 +1377,78 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+  memory.numa_stat
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	This breaks down the cgroup's memory footprint into different
+	types of memory, type-specific details, and other information
+	per node on the state of the memory management system.
+
+	This is useful for providing visibility into the numa locality
+	information within an memcg since the pages are allowed to be
+	allocated from any physical node. One of the use cases is evaluating
+	application performance by combining this information with the
+	application's CPU allocation.
+
+	All memory amounts are in bytes.
+
+	The output format of memory.numa_stat is::
+
+	  type N0=<node 0 pages> N1=<node 1 pages> ...
+
+	The entries are ordered to be human readable, and new entries
+	can show up in the middle. Don't rely on items remaining in a
+	fixed position; use the keys to look up specific values!
+
+	  anon
+		Amount of memory per node used in anonymous mappings such
+		as brk(), sbrk(), and mmap(MAP_ANONYMOUS)
+
+	  file
+		Amount of memory per node used to cache filesystem data,
+		including tmpfs and shared memory.
+
+	  kernel_stack
+		Amount of memory per node allocated to kernel stacks.
+
+	  shmem
+		Amount of cached filesystem data per node that is swap-backed,
+		such as tmpfs, shm segments, shared anonymous mmap()s
+
+	  file_mapped
+		Amount of cached filesystem data per node mapped with mmap()
+
+	  file_dirty
+		Amount of cached filesystem data per node that was modified but
+		not yet written back to disk
+
+	  file_writeback
+		Amount of cached filesystem data per node that was modified and
+		is currently being written back to disk
+
+	  anon_thp
+		Amount of memory per node used in anonymous mappings backed by
+		transparent hugepages
+
+	  inactive_anon, active_anon, inactive_file, active_file, unevictable
+		Amount of memory, swap-backed and filesystem-backed,
+		per node on the internal memory management lists used
+		by the page reclaim algorithm.
+
+		As these represent internal list state (eg. shmem pages are on anon
+		memory management lists), inactive_foo + active_foo may not be equal to
+		the value for the foo counter, since the foo counter is type-based, not
+		list-based.
+
+	  slab_reclaimable
+		Amount of memory per node used for storing in-kernel data
+		structures which might be reclaimed, such as dentries and
+		inodes.
+
+	  slab_unreclaimable
+		Amount of memory per node used for storing in-kernel data
+		structures which cannot be reclaimed on memory pressure.
+
   memory.swap.current
 	A read-only single value file which exists on non-root
 	cgroups.
--- a/mm/memcontrol.c~mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2
+++ a/mm/memcontrol.c
@@ -6383,6 +6383,84 @@ static int memory_stat_show(struct seq_f
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
+static unsigned long memcg_node_page_state(struct mem_cgroup *memcg,
+					   unsigned int nid,
+					   enum node_stat_item idx)
+{
+	VM_BUG_ON(nid >= nr_node_ids);
+	return lruvec_page_state(mem_cgroup_lruvec(memcg, NODE_DATA(nid)), idx);
+}
+
+static const char *memory_numa_stat_format(struct mem_cgroup *memcg)
+{
+	struct numa_stat {
+		const char *name;
+		unsigned int ratio;
+		enum node_stat_item idx;
+	};
+
+	static const struct numa_stat stats[] = {
+		{ "anno", PAGE_SIZE, NR_ANON_MAPPED },
+		{ "file", PAGE_SIZE, NR_FILE_PAGES },
+		{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
+		{ "shmem", PAGE_SIZE, NR_SHMEM },
+		{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
+		{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
+		{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		{ "anon_thp", HPAGE_PMD_SIZE, NR_ANON_THPS },
+#endif
+		{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
+		{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
+		{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
+		{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
+		{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
+		{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
+		{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
+	};
+
+	int i, nid;
+	struct seq_buf s;
+
+	/* Reserve a byte for the trailing null */
+	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE - 1);
+	if (!s.buffer)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(stats); i++) {
+		seq_buf_printf(&s, "%s", stats[i].name);
+		for_each_node_state(nid, N_MEMORY) {
+			u64 size;
+
+			size = memcg_node_page_state(memcg, nid, stats[i].idx);
+			size *= stats[i].ratio;
+			seq_buf_printf(&s, " N%d=%llu", nid, size);
+		}
+		seq_buf_putc(&s, '\n');
+	}
+
+	/* The above should easily fit into one page */
+	if (WARN_ON_ONCE(seq_buf_putc(&s, '\0')))
+		s.buffer[PAGE_SIZE - 1] = '\0';
+
+	return s.buffer;
+}
+
+static int memory_numa_stat_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	const char *buf;
+
+	buf = memory_numa_stat_format(memcg);
+	if (!buf)
+		return -ENOMEM;
+	seq_puts(m, buf);
+	kfree(buf);
+	return 0;
+}
+#endif
+
 static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
@@ -6492,6 +6570,12 @@ static struct cftype memory_files[] = {
 		.name = "stat",
 		.seq_show = memory_stat_show,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.name = "numa_stat",
+		.seq_show = memory_numa_stat_show,
+	},
+#endif
 	{
 		.name = "oom.group",
 		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3.patch
mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

