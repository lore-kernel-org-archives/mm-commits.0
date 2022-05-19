Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F744C43217
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiESW2A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245513AbiESW0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C60624F13
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23AA7B828C3
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD481C385AA;
        Thu, 19 May 2022 22:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999153;
        bh=rxLJRTsOjXBe2ELkE0tA2mOr+KfWv8QmX7KTSr6PKNk=;
        h=Date:To:From:Subject:From;
        b=TPKz2D2jh5hhpEFS/3ImYOhnuZQguK8f+aAV8c3YF4+0KWn+Kw2gaQC/mzSfxF+8h
         c7HCXEIvQqFnUdqDMY+w0lNBBevQh59pHvtuubCawur2XIZq6x4n91FH7yQ5sBa2CN
         wVX3Q9fSCdBHBuBkUw0GNP0DnVPwZxbqcslIJfHU=
Date:   Thu, 19 May 2022 15:25:53 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, david@redhat.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch removed from -mm tree
Message-Id: <20220519222553.BD481C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: zswap: add basic meminfo and vmstat coverage
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: add basic meminfo and vmstat coverage

Currently it requires poking at debugfs to figure out the size and
population of the zswap cache on a host.  There are no counters for reads
and writes against the cache.  As a result, it's difficult to understand
zswap behavior on production systems.

Print zswap memory consumption and how many pages are zswapped out in
/proc/meminfo.  Count zswapouts and zswapins in /proc/vmstat.

Link: https://lkml.kernel.org/r/20220510152847.230957-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    6 ++++++
 fs/proc/meminfo.c                  |    7 +++++++
 include/linux/swap.h               |    5 +++++
 include/linux/vm_event_item.h      |    4 ++++
 mm/vmstat.c                        |    4 ++++
 mm/zswap.c                         |   13 ++++++-------
 6 files changed, 32 insertions(+), 7 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/Documentation/filesystems/proc.rst
@@ -964,6 +964,8 @@ Example output. You may not have all of
     Mlocked:               0 kB
     SwapTotal:             0 kB
     SwapFree:              0 kB
+    Zswap:              1904 kB
+    Zswapped:           7792 kB
     Dirty:                12 kB
     Writeback:             0 kB
     AnonPages:       4654780 kB
@@ -1055,6 +1057,10 @@ SwapTotal
 SwapFree
               Memory which has been evicted from RAM, and is temporarily
               on the disk
+Zswap
+              Memory consumed by the zswap backend (compressed size)
+Zswapped
+              Amount of anonymous memory stored in zswap (original size)
 Dirty
               Memory which is waiting to get written back to the disk
 Writeback
--- a/fs/proc/meminfo.c~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/fs/proc/meminfo.c
@@ -86,6 +86,13 @@ static int meminfo_proc_show(struct seq_
 
 	show_val_kb(m, "SwapTotal:      ", i.totalswap);
 	show_val_kb(m, "SwapFree:       ", i.freeswap);
+#ifdef CONFIG_ZSWAP
+	seq_printf(m,  "Zswap:          %8lu kB\n",
+		   (unsigned long)(zswap_pool_total_size >> 10));
+	seq_printf(m,  "Zswapped:       %8lu kB\n",
+		   (unsigned long)atomic_read(&zswap_stored_pages) <<
+		   (PAGE_SHIFT - 10));
+#endif
 	show_val_kb(m, "Dirty:          ",
 		    global_node_page_state(NR_FILE_DIRTY));
 	show_val_kb(m, "Writeback:      ",
--- a/include/linux/swap.h~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/include/linux/swap.h
@@ -620,6 +620,11 @@ static inline int mem_cgroup_swappiness(
 }
 #endif
 
+#ifdef CONFIG_ZSWAP
+extern u64 zswap_pool_total_size;
+extern atomic_t zswap_stored_pages;
+#endif
+
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 extern void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
 static inline  void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
--- a/include/linux/vm_event_item.h~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/include/linux/vm_event_item.h
@@ -136,6 +136,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_KSM
 		COW_KSM,
 #endif
+#ifdef CONFIG_ZSWAP
+		ZSWPIN,
+		ZSWPOUT,
+#endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
 		DIRECT_MAP_LEVEL3_SPLIT,
--- a/mm/vmstat.c~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/mm/vmstat.c
@@ -1396,6 +1396,10 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_KSM
 	"cow_ksm",
 #endif
+#ifdef CONFIG_ZSWAP
+	"zswpin",
+	"zswpout",
+#endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
 	"direct_map_level3_splits",
--- a/mm/zswap.c~mm-zswap-add-basic-meminfo-and-vmstat-coverage
+++ a/mm/zswap.c
@@ -42,9 +42,9 @@
 * statistics
 **********************************/
 /* Total bytes used by the compressed storage */
-static u64 zswap_pool_total_size;
+u64 zswap_pool_total_size;
 /* The number of compressed pages currently stored in zswap */
-static atomic_t zswap_stored_pages = ATOMIC_INIT(0);
+atomic_t zswap_stored_pages = ATOMIC_INIT(0);
 /* The number of same-value filled pages currently stored in zswap */
 static atomic_t zswap_same_filled_pages = ATOMIC_INIT(0);
 
@@ -1243,6 +1243,7 @@ insert_entry:
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
 	zswap_update_total_size();
+	count_vm_event(ZSWPOUT);
 
 	return 0;
 
@@ -1285,11 +1286,10 @@ static int zswap_frontswap_load(unsigned
 		zswap_fill_page(dst, entry->value);
 		kunmap_atomic(dst);
 		ret = 0;
-		goto freeentry;
+		goto stats;
 	}
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
-
 		tmp = kmalloc(entry->length, GFP_ATOMIC);
 		if (!tmp) {
 			ret = -ENOMEM;
@@ -1304,10 +1304,8 @@ static int zswap_frontswap_load(unsigned
 		src += sizeof(struct zswap_header);
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
-
 		memcpy(tmp, src, entry->length);
 		src = tmp;
-
 		zpool_unmap_handle(entry->pool->zpool, entry->handle);
 	}
 
@@ -1326,7 +1324,8 @@ static int zswap_frontswap_load(unsigned
 		kfree(tmp);
 
 	BUG_ON(ret);
-
+stats:
+	count_vm_event(ZSWPIN);
 freeentry:
 	spin_lock(&tree->lock);
 	zswap_entry_put(tree, entry);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

