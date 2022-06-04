Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6ADC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  4 Jun 2022 19:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbiFDTBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Jun 2022 15:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiFDTBt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Jun 2022 15:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE54F470
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 12:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 099B1B8013B
        for <mm-commits@vger.kernel.org>; Sat,  4 Jun 2022 19:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90908C385B8;
        Sat,  4 Jun 2022 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654369304;
        bh=sijnNY3Fsy0gHUVS6oJK6MrXUr+IjCdkOP3UNqwuACI=;
        h=Date:To:From:Subject:From;
        b=U+SB4016ujBwM6YqbNrbXJ7R2DYopxHwQF0U+418YRgejlyVU9dti/WKh0C2l02WS
         8LZbuM3PVf1LHyqBA57vgOqXoggGJRqDvpNQtn4dprhGw9RzN0VuOrJob66OdPkTRa
         wr5CHUILqS8aZtzRJY7T9XtJZGLm7J0WdLqetmJo=
Date:   Sat, 04 Jun 2022 12:01:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, corbet@lwn.net, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-separate-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch removed from -mm tree
Message-Id: <20220604190144.90908C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: separate {pgscan,pgsteal}_{kswapd,direct} items in memory.stat of cgroup v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-separate-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: separate {pgscan,pgsteal}_{kswapd,direct} items in memory.stat of cgroup v2
Date: Fri, 3 Jun 2022 15:04:23 +0800

There are already statistics of {pgscan,pgsteal}_kswapd and
{pgscan,pgsteal}_direct of memcg event here, but now the sum of the two is
displayed in memory.stat of cgroup v2.

In order to obtain more accurate information during monitoring and
debugging, and to align with the display in /proc/vmstat, it better to
display {pgscan,pgsteal}_kswapd and {pgscan,pgsteal}_direct separately.

Moreover, after this modification, all memcg events can be printed with a
combination of vm_event_name() and memcg_events().  This allows us to
create an array to traverse and print, which reduces redundant
seq_buf_printf() codes.

Link: https://lkml.kernel.org/r/20220603070423.10025-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   14 +++--
 mm/memcontrol.c                         |   61 +++++++++-------------
 2 files changed, 36 insertions(+), 39 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-separate-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1442,11 +1442,17 @@ PAGE_SIZE multiple when read back.
 	  pgrefill (npn)
 		Amount of scanned pages (in an active LRU list)
 
-	  pgscan (npn)
-		Amount of scanned pages (in an inactive LRU list)
+	  pgscan_kswapd (npn)
+		Amount of scanned pages by kswapd (in an inactive LRU list)
 
-	  pgsteal (npn)
-		Amount of reclaimed pages
+	  pgscan_direct (npn)
+		Amount of scanned pages directly  (in an inactive LRU list)
+
+	  pgsteal_kswapd (npn)
+		Amount of reclaimed pages by kswapd
+
+	  pgsteal_direct (npn)
+		Amount of reclaimed pages directly
 
 	  pgactivate (npn)
 		Amount of pages moved to the active LRU list
--- a/mm/memcontrol.c~mm-memcontrol-separate-pgscanpgsteal_kswapddirect-items-in-memorystat-of-cgroup-v2
+++ a/mm/memcontrol.c
@@ -1460,6 +1460,28 @@ static inline unsigned long memcg_page_s
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
+static const unsigned int memcg_vm_event_stat[] = {
+	PGFAULT,
+	PGMAJFAULT,
+	PGREFILL,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
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
@@ -1495,41 +1517,10 @@ static char *memory_stat_format(struct m
 	}
 
 	/* Accumulated memory events */
-
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGFAULT),
-		       memcg_events(memcg, PGFAULT));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGMAJFAULT),
-		       memcg_events(memcg, PGMAJFAULT));
-	seq_buf_printf(&s, "%s %lu\n",  vm_event_name(PGREFILL),
-		       memcg_events(memcg, PGREFILL));
-	seq_buf_printf(&s, "pgscan %lu\n",
-		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT));
-	seq_buf_printf(&s, "pgsteal %lu\n",
-		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGACTIVATE),
-		       memcg_events(memcg, PGACTIVATE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGDEACTIVATE),
-		       memcg_events(memcg, PGDEACTIVATE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGLAZYFREE),
-		       memcg_events(memcg, PGLAZYFREE));
-	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGLAZYFREED),
-		       memcg_events(memcg, PGLAZYFREED));
-
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


