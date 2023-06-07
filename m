Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D905C77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbjFGUzt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbjFGUzs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65AE46
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 13:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A18864822
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 20:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBFBC433EF;
        Wed,  7 Jun 2023 20:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686171344;
        bh=LCiozvIhLtFKUsRbVHDVTfQuYptOaOmYCGixAl+E1po=;
        h=Date:To:From:Subject:From;
        b=HY4rMVJ3TkKSjYku11jC6EFMK6ABjz3wWCJ5/MizPH75+vHHR3Ydm4dupq6HtsjNr
         QIYUUtFrEzuMP/2rTYs3DB0p2k/AXPTGZCCe2TVXoEDw17DZp+OyUsTi/Taqi/n2kw
         tzZ+jqmwOXQiI0ToNDDOAR1UbIvzRivv1GgssiqE=
Date:   Wed, 07 Jun 2023 13:55:43 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        konrad.wilk@oracle.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-support-exclusive-loads.patch added to mm-unstable branch
Message-Id: <20230607205544.8FBFBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: support exclusive loads
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-support-exclusive-loads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-support-exclusive-loads.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: support exclusive loads
Date: Wed, 7 Jun 2023 19:51:43 +0000

Commit 71024cb4a0bf ("frontswap: remove frontswap_tmem_exclusive_gets")
removed support for exclusive loads from frontswap as it was not used. 
Bring back exclusive loads support to frontswap by adding an "exclusive"
output parameter to frontswap_ops->load.

On the zswap side, add a module parameter to enable/disable exclusive
loads, and a config option to control the boot default value.  Refactor
zswap entry invalidation in zswap_frontswap_invalidate_page() into
zswap_invalidate_entry() to reuse it in zswap_frontswap_load() if
exclusive loads are enabled.

With exclusive loads, we avoid having two copies of the same page in
memory (compressed & uncompressed) after faulting it in from zswap.  On
the other hand, if the page is to be reclaimed again without being
dirtied, it will be re-compressed.  Compression is not usually slow, and a
page that was just faulted in is less likely to be reclaimed again soon.

Link: https://lkml.kernel.org/r/20230607195143.1473802-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    2 +-
 mm/Kconfig                |   16 ++++++++++++++++
 mm/frontswap.c            |   10 ++++++++--
 mm/zswap.c                |   28 ++++++++++++++++++++--------
 4 files changed, 45 insertions(+), 11 deletions(-)

--- a/include/linux/frontswap.h~mm-zswap-support-exclusive-loads
+++ a/include/linux/frontswap.h
@@ -10,7 +10,7 @@
 struct frontswap_ops {
 	void (*init)(unsigned); /* this swap type was just swapon'ed */
 	int (*store)(unsigned, pgoff_t, struct page *); /* store a page */
-	int (*load)(unsigned, pgoff_t, struct page *); /* load a page */
+	int (*load)(unsigned, pgoff_t, struct page *, bool *); /* load a page */
 	void (*invalidate_page)(unsigned, pgoff_t); /* page no longer needed */
 	void (*invalidate_area)(unsigned); /* swap type just swapoff'ed */
 };
--- a/mm/frontswap.c~mm-zswap-support-exclusive-loads
+++ a/mm/frontswap.c
@@ -206,6 +206,7 @@ int __frontswap_load(struct page *page)
 	int type = swp_type(entry);
 	struct swap_info_struct *sis = swap_info[type];
 	pgoff_t offset = swp_offset(entry);
+	bool exclusive = false;
 
 	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(!PageLocked(page));
@@ -215,9 +216,14 @@ int __frontswap_load(struct page *page)
 		return -1;
 
 	/* Try loading from each implementation, until one succeeds. */
-	ret = frontswap_ops->load(type, offset, page);
-	if (ret == 0)
+	ret = frontswap_ops->load(type, offset, page, &exclusive);
+	if (ret == 0) {
 		inc_frontswap_loads();
+		if (exclusive) {
+			SetPageDirty(page);
+			__frontswap_clear(sis, offset);
+		}
+	}
 	return ret;
 }
 
--- a/mm/Kconfig~mm-zswap-support-exclusive-loads
+++ a/mm/Kconfig
@@ -46,6 +46,22 @@ config ZSWAP_DEFAULT_ON
 	  The selection made here can be overridden by using the kernel
 	  command line 'zswap.enabled=' option.
 
+config ZSWAP_EXCLUSIVE_LOADS_DEFAULT_ON
+	bool "Invalidate zswap entries when pages are loaded"
+	depends on ZSWAP
+	help
+	  If selected, exclusive loads for zswap will be enabled at boot,
+	  otherwise it will be disabled.
+
+	  If exclusive loads are enabled, when a page is loaded from zswap,
+	  the zswap entry is invalidated at once, as opposed to leaving it
+	  in zswap until the swap entry is freed.
+
+	  This avoids having two copies of the same page in memory
+	  (compressed and uncompressed) after faulting in a page from zswap.
+	  The cost is that if the page was never dirtied and needs to be
+	  swapped out again, it will be re-compressed.
+
 choice
 	prompt "Default compressor"
 	depends on ZSWAP
--- a/mm/zswap.c~mm-zswap-support-exclusive-loads
+++ a/mm/zswap.c
@@ -138,6 +138,10 @@ static bool zswap_non_same_filled_pages_
 module_param_named(non_same_filled_pages_enabled, zswap_non_same_filled_pages_enabled,
 		   bool, 0644);
 
+static bool zswap_exclusive_loads_enabled = IS_ENABLED(
+		CONFIG_ZSWAP_EXCLUSIVE_LOADS_DEFAULT_ON);
+module_param_named(exclusive_loads, zswap_exclusive_loads_enabled, bool, 0644);
+
 /*********************************
 * data structures
 **********************************/
@@ -1340,12 +1344,22 @@ shrink:
 	goto reject;
 }
 
+static void zswap_invalidate_entry(struct zswap_tree *tree,
+				   struct zswap_entry *entry)
+{
+	/* remove from rbtree */
+	zswap_rb_erase(&tree->rbroot, entry);
+
+	/* drop the initial reference from entry creation */
+	zswap_entry_put(tree, entry);
+}
+
 /*
  * returns 0 if the page was successfully decompressed
  * return -1 on entry not found or error
 */
 static int zswap_frontswap_load(unsigned type, pgoff_t offset,
-				struct page *page)
+				struct page *page, bool *exclusive)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
@@ -1415,6 +1429,10 @@ stats:
 freeentry:
 	spin_lock(&tree->lock);
 	zswap_entry_put(tree, entry);
+	if (!ret && zswap_exclusive_loads_enabled) {
+		zswap_invalidate_entry(tree, entry);
+		*exclusive = true;
+	}
 	spin_unlock(&tree->lock);
 
 	return ret;
@@ -1434,13 +1452,7 @@ static void zswap_frontswap_invalidate_p
 		spin_unlock(&tree->lock);
 		return;
 	}
-
-	/* remove from rbtree */
-	zswap_rb_erase(&tree->rbroot, entry);
-
-	/* drop the initial reference from entry creation */
-	zswap_entry_put(tree, entry);
-
+	zswap_invalidate_entry(tree, entry);
 	spin_unlock(&tree->lock);
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch
memcg-dump-memorystat-during-cgroup-oom-for-v1.patch
writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch
memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch
memcg-calculate-root-usage-from-global-state.patch
memcg-remove-mem_cgroup_flush_stats_atomic.patch
cgroup-remove-cgroup_rstat_flush_atomic.patch
mm-zswap-support-exclusive-loads.patch

