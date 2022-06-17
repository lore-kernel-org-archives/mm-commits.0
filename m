Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F22C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379820AbiFQCtl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379803AbiFQCt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22064D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193A161D1F
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9A8C34114;
        Fri, 17 Jun 2022 02:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434166;
        bh=6ONgu08BfOTNgah2yMvIl5RDox6DdUCsp1xrgYerTd8=;
        h=Date:To:From:Subject:From;
        b=IvJbV+R0eqSaktPpu98CQTucAyiWh18lQTiDUWpSaFUKIm5XtU7NViKUgDlZJRimk
         ZgIx0h2/EUb+qKtTM5+jEOAAaJ7UNcmEy0ljJFYJAEI4BW99Ipw6zObcG+6YWOfy7c
         6k7BYnV56Jj6DZILHyH9O1iCdngHj0+gjE7uMEP8=
Date:   Thu, 16 Jun 2022 19:49:25 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, corbet@lwn.net, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch removed from -mm tree
Message-Id: <20220617024926.6F9A8C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: add {pgscan,pgsteal}_{kswapd,direct} items in memory.stat of cgroup v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: add {pgscan,pgsteal}_{kswapd,direct} items in memory.stat of cgroup v2
Date: Sat, 4 Jun 2022 16:22:09 +0800

There are already statistics of {pgscan,pgsteal}_kswapd and
{pgscan,pgsteal}_direct of memcg event here, but now only the sum of the
two is displayed in memory.stat of cgroup v2.

In order to obtain more accurate information during monitoring and
debugging, and to align with the display in /proc/vmstat, it better to
display {pgscan,pgsteal}_kswapd and {pgscan,pgsteal}_direct separately.

Also, for forward compatibility, we still display pgscan and pgsteal items
so that it won't break existing applications.

[zhengqi.arch@bytedance.com: add comment for memcg_vm_event_stat (suggested by Michal)]
  Link: https://lkml.kernel.org/r/20220606154028.55030-1-zhengqi.arch@bytedance.com
[zhengqi.arch@bytedance.com: fix the doc, thanks to Johannes]
  Link: https://lkml.kernel.org/r/20220607064803.79363-1-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/20220604082209.55174-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   24 +++++++--
 mm/memcontrol.c                         |   55 ++++++++++------------
 2 files changed, 45 insertions(+), 34 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1433,6 +1433,24 @@ PAGE_SIZE multiple when read back.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
+	  pgscan (npn)
+		Amount of scanned pages (in an inactive LRU list)
+
+	  pgsteal (npn)
+		Amount of reclaimed pages
+
+	  pgscan_kswapd (npn)
+		Amount of scanned pages by kswapd (in an inactive LRU list)
+
+	  pgscan_direct (npn)
+		Amount of scanned pages directly  (in an inactive LRU list)
+
+	  pgsteal_kswapd (npn)
+		Amount of reclaimed pages by kswapd
+
+	  pgsteal_direct (npn)
+		Amount of reclaimed pages directly
+
 	  pgfault (npn)
 		Total number of page faults incurred
 
@@ -1442,12 +1460,6 @@ PAGE_SIZE multiple when read back.
 	  pgrefill (npn)
 		Amount of scanned pages (in an active LRU list)
 
-	  pgscan (npn)
-		Amount of scanned pages (in an inactive LRU list)
-
-	  pgsteal (npn)
-		Amount of reclaimed pages
-
 	  pgactivate (npn)
 		Amount of pages moved to the active LRU list
 
--- a/mm/memcontrol.c~mm-memcontrol-add-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2
+++ a/mm/memcontrol.c
@@ -1460,6 +1460,29 @@ static inline unsigned long memcg_page_s
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
+/* Subset of vm_event_item to report for memcg event stats */
+static const unsigned int memcg_vm_event_stat[] = {
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGFAULT,
+	PGMAJFAULT,
+	PGREFILL,
+	PGACTIVATE,
+	PGDEACTIVATE,
+	PGLAZYFREE,
+	PGLAZYFREED,
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
+	ZSWPIN,
+	ZSWPOUT,
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	THP_FAULT_ALLOC,
+	THP_COLLAPSE_ALLOC,
+#endif
+};
+
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
@@ -1495,41 +1518,17 @@ static char *memory_stat_format(struct m
 	}
 
 	/* Accumulated memory events */
-
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGFAULT),
-		       memcg_events(memcg, PGFAULT));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGMAJFAULT),
-		       memcg_events(memcg, PGMAJFAULT));
-	seq_buf_printf(&s, "%s %lu\n",  vm_event_name(PGREFILL),
-		       memcg_events(memcg, PGREFILL));
 	seq_buf_printf(&s, "pgscan %lu\n",
 		       memcg_events(memcg, PGSCAN_KSWAPD) +
 		       memcg_events(memcg, PGSCAN_DIRECT));
 	seq_buf_printf(&s, "pgsteal %lu\n",
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGACTIVATE),
-		       memcg_events(memcg, PGACTIVATE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGDEACTIVATE),
-		       memcg_events(memcg, PGDEACTIVATE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGLAZYFREE),
-		       memcg_events(memcg, PGLAZYFREE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGLAZYFREED),
-		       memcg_events(memcg, PGLAZYFREED));
 
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(ZSWPIN),
-		       memcg_events(memcg, ZSWPIN));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(ZSWPOUT),
-		       memcg_events(memcg, ZSWPOUT));
-#endif
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(THP_FAULT_ALLOC),
-		       memcg_events(memcg, THP_FAULT_ALLOC));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(THP_COLLAPSE_ALLOC),
-		       memcg_events(memcg, THP_COLLAPSE_ALLOC));
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++)
+		seq_buf_printf(&s, "%s %lu\n",
+			       vm_event_name(memcg_vm_event_stat[i]),
+			       memcg_events(memcg, memcg_vm_event_stat[i]));
 
 	/* The above should easily fit into one page */
 	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


