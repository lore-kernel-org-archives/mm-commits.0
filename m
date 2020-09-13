Return-Path: <SRS0=3wUv=CW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A1EC433E2
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C775921655
	for <mm-commits@archiver.kernel.org>; Sun, 13 Sep 2020 00:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599958007;
	bh=Pw9gTgLrP1SkGbV7+XEi4ELaMmQqDsUkZAoWp5sqyDU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dJgVQw07/CzDsDEa3CXpV14KsqQSRoQKfOol+/ba8bPBUYYQv8Jf7wMSCXXOkmdM2
	 AfO47D/utilTI1JIRv/Tjije1B7y3GrwPcu0lbDePkWy/heAFLuauzW74tVdnq4uya
	 z25HO7g6KK5TfWRuB7eAKE5B6ayBXqXGNQRsoVuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgIMAqq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 20:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgIMAqo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 20:46:44 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30FD2087C;
        Sun, 13 Sep 2020 00:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599958003;
        bh=Pw9gTgLrP1SkGbV7+XEi4ELaMmQqDsUkZAoWp5sqyDU=;
        h=Date:From:To:Subject:From;
        b=gQuIGuUfnWkB9Z2orsKJ4EnO3yGK8APl5+E36mTyQ5vUKk2JHsIIrPW9ptewopdui
         BBGqjt1g4RqMQO4hCGj2nQIz+LGrOus96dn3P7sf7aPU8Q9DT6BWGGSP9T8HGP9wP5
         3kMPRNH3XXItUdV7YElgnxsHB6zZ8VrG9kKOa5OA=
Date:   Sat, 12 Sep 2020 17:46:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        songmuchun@bytedance.com
Subject:  +
 mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch added
 to -mm tree
Message-ID: <20200913004642.IXxmu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add the missing numa_stat interface for cgroup v2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch
mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

