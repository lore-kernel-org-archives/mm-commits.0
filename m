Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DF0C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 18:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiEJSrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 14:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349084AbiEJSqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 14:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877CD18B34
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 11:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23CAB60F6B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 18:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A57C385C2;
        Tue, 10 May 2022 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652208403;
        bh=cdSoPcqlHO4qc/D5cvEYhA7F1x7NF42CCMKHCF0TlAY=;
        h=Date:To:From:Subject:From;
        b=KN9kD+vNsGIJPI1+OAsglp8IZ2BOjbmxDsq3B9TErTN58Z1qs4sTaBcmVrKLsqjAy
         5mG5t+GX7uLIsKBY2TOVB2/sLdkQvysKCRQe6B2qcoOSfN8gyYI+r3oKvYsorRpE8x
         PRqGbdsRZ3HzlZrWTj78tbjGItFi2/BSsOR6COSg=
Date:   Tue, 10 May 2022 11:46:42 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch added to mm-unstable branch
Message-Id: <20220510184643.72A57C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: add basic meminfo and vmstat coverage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -625,6 +625,11 @@ static inline int mem_cgroup_swappiness(
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
@@ -132,6 +132,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
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
@@ -1392,6 +1392,10 @@ const char * const vmstat_text[] = {
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

documentation-filesystems-proc-update-meminfo-section.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch

