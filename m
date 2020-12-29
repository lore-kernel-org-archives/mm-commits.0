Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13851C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F75206ED
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgL2T6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 14:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgL2T6o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 14:58:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A64572222A;
        Tue, 29 Dec 2020 19:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609271859;
        bh=GZe0pblXrlbPso1nUUsesqV4rlJEfn+I1B2Mx43xV0Y=;
        h=Date:From:To:Subject:From;
        b=yKuPK6dLGqffUIaGIws+H3HQYnPNvFsjTseLmkELmKel7BKIqlPE2uekHYqKofWpu
         UPGdVB56GH5K9L2VTkoOaswQ9FQCgT0QzAdr5a8cql3kySM/g2HOhmL4JzBPvseblr
         mm3bXBeJyAXSDR0Z9fOSQsOo5LhNxSmeedMTNa0k=
Date:   Tue, 29 Dec 2020 11:57:38 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, samitolvanen@google.com,
        rdunlap@infradead.org, rafael@kernel.org,
        pankaj.gupta@cloud.ionos.com, neilb@suse.de, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        guro@fb.com, gregkh@linuxfoundation.org, feng.tang@intel.com,
        adobriyan@gmail.com, songmuchun@bytedance.com
Subject:  + mm-memcontrol-make-the-slab-calculation-consistent.patch
 added to -mm tree
Message-ID: <20201229195738.R5p_1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make the slab calculation consistent
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-the-slab-calculation-consistent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-the-slab-calculation-consistent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-the-slab-calculation-consistent.patch

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
Subject: mm: memcontrol: make the slab calculation consistent

Although the ratio of the slab is one, we also should read the ratio from
the related memory_stats instead of hard-coding.  And the local variable
of size is already the value of slab_unreclaimable.  So we do not need to
read again.

To do this we need some code like below:

if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
-	size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
-	       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
+       VM_BUG_ON(i < 1);
+       VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);
+	size += memcg_page_state(memcg, memory_stats[i - 1].idx) *
+		memory_stats[i - 1].ratio;

It requires a series of VM_BUG_ONs or comments to ensure these two items
are actually adjacent and in the right order.  So it would probably be
easier to implement this using a wrapper that has a big switch() for unit
conversion.

More details about this discussion can refer to:

    https://lore.kernel.org/patchwork/patch/1348611/

This would fix the ratio inconsistency and get rid of the order
guarantee.

Link: https://lkml.kernel.org/r/20201228164110.2838-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Rafael. J. Wysocki <rafael@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  105 ++++++++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 39 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-make-the-slab-calculation-consistent
+++ a/mm/memcontrol.c
@@ -1512,49 +1512,71 @@ static bool mem_cgroup_wait_acct_move(st
 
 struct memory_stat {
 	const char *name;
-	unsigned int ratio;
 	unsigned int idx;
 };
 
 static const struct memory_stat memory_stats[] = {
-	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
-	{ "file", PAGE_SIZE, NR_FILE_PAGES },
-	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
-	{ "pagetables", PAGE_SIZE, NR_PAGETABLE },
-	{ "percpu", 1, MEMCG_PERCPU_B },
-	{ "sock", PAGE_SIZE, MEMCG_SOCK },
-	{ "shmem", PAGE_SIZE, NR_SHMEM },
-	{ "file_mapped", PAGE_SIZE, NR_FILE_MAPPED },
-	{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
-	{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
+	{ "anon",			NR_ANON_MAPPED			},
+	{ "file",			NR_FILE_PAGES			},
+	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
+	{ "pagetables",			NR_PAGETABLE			},
+	{ "percpu",			MEMCG_PERCPU_B			},
+	{ "sock",			MEMCG_SOCK			},
+	{ "shmem",			NR_SHMEM			},
+	{ "file_mapped",		NR_FILE_MAPPED			},
+	{ "file_dirty",			NR_FILE_DIRTY			},
+	{ "file_writeback",		NR_WRITEBACK			},
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
-	{ "file_thp", PAGE_SIZE, NR_FILE_THPS },
-	{ "shmem_thp", PAGE_SIZE, NR_SHMEM_THPS },
+	{ "anon_thp",			NR_ANON_THPS			},
+	{ "file_thp",			NR_FILE_THPS			},
+	{ "shmem_thp",			NR_SHMEM_THPS			},
 #endif
-	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
-	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
-	{ "inactive_file", PAGE_SIZE, NR_INACTIVE_FILE },
-	{ "active_file", PAGE_SIZE, NR_ACTIVE_FILE },
-	{ "unevictable", PAGE_SIZE, NR_UNEVICTABLE },
-
-	/*
-	 * Note: The slab_reclaimable and slab_unreclaimable must be
-	 * together and slab_reclaimable must be in front.
-	 */
-	{ "slab_reclaimable", 1, NR_SLAB_RECLAIMABLE_B },
-	{ "slab_unreclaimable", 1, NR_SLAB_UNRECLAIMABLE_B },
+	{ "inactive_anon",		NR_INACTIVE_ANON		},
+	{ "active_anon",		NR_ACTIVE_ANON			},
+	{ "inactive_file",		NR_INACTIVE_FILE		},
+	{ "active_file",		NR_ACTIVE_FILE			},
+	{ "unevictable",		NR_UNEVICTABLE			},
+	{ "slab_reclaimable",		NR_SLAB_RECLAIMABLE_B		},
+	{ "slab_unreclaimable",		NR_SLAB_UNRECLAIMABLE_B		},
 
 	/* The memory events */
-	{ "workingset_refault_anon", 1, WORKINGSET_REFAULT_ANON },
-	{ "workingset_refault_file", 1, WORKINGSET_REFAULT_FILE },
-	{ "workingset_activate_anon", 1, WORKINGSET_ACTIVATE_ANON },
-	{ "workingset_activate_file", 1, WORKINGSET_ACTIVATE_FILE },
-	{ "workingset_restore_anon", 1, WORKINGSET_RESTORE_ANON },
-	{ "workingset_restore_file", 1, WORKINGSET_RESTORE_FILE },
-	{ "workingset_nodereclaim", 1, WORKINGSET_NODERECLAIM },
+	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
+	{ "workingset_refault_file",	WORKINGSET_REFAULT_FILE		},
+	{ "workingset_activate_anon",	WORKINGSET_ACTIVATE_ANON	},
+	{ "workingset_activate_file",	WORKINGSET_ACTIVATE_FILE	},
+	{ "workingset_restore_anon",	WORKINGSET_RESTORE_ANON		},
+	{ "workingset_restore_file",	WORKINGSET_RESTORE_FILE		},
+	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
 };
 
+/* Translate stat items to the correct unit for memory.stat output */
+static int memcg_page_state_unit(int item)
+{
+	switch (item) {
+	case MEMCG_PERCPU_B:
+	case NR_SLAB_RECLAIMABLE_B:
+	case NR_SLAB_UNRECLAIMABLE_B:
+	case WORKINGSET_REFAULT_ANON:
+	case WORKINGSET_REFAULT_FILE:
+	case WORKINGSET_ACTIVATE_ANON:
+	case WORKINGSET_ACTIVATE_FILE:
+	case WORKINGSET_RESTORE_ANON:
+	case WORKINGSET_RESTORE_FILE:
+	case WORKINGSET_NODERECLAIM:
+		return 1;
+	case NR_KERNEL_STACK_KB:
+		return SZ_1K;
+	default:
+		return PAGE_SIZE;
+	}
+}
+
+static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
+						    int item)
+{
+	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
+}
+
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
@@ -1578,13 +1600,12 @@ static char *memory_stat_format(struct m
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
 
-		size = memcg_page_state(memcg, memory_stats[i].idx);
-		size *= memory_stats[i].ratio;
+		size = memcg_page_state_output(memcg, memory_stats[i].idx);
 		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
-			size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
-			       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
+			size += memcg_page_state_output(memcg,
+							NR_SLAB_RECLAIMABLE_B);
 			seq_buf_printf(&s, "slab %llu\n", size);
 		}
 	}
@@ -6378,6 +6399,12 @@ static int memory_stat_show(struct seq_f
 }
 
 #ifdef CONFIG_NUMA
+static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
+						     int item)
+{
+	return lruvec_page_state(lruvec, item) * memcg_page_state_unit(item);
+}
+
 static int memory_numa_stat_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -6395,8 +6422,8 @@ static int memory_numa_stat_show(struct
 			struct lruvec *lruvec;
 
 			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-			size = lruvec_page_state(lruvec, memory_stats[i].idx);
-			size *= memory_stats[i].ratio;
+			size = lruvec_page_state_output(lruvec,
+							memory_stats[i].idx);
 			seq_printf(m, " N%d=%llu", nid, size);
 		}
 		seq_putc(m, '\n');
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch

