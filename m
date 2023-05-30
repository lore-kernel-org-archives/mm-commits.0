Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ED0C77B73
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 21:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjE3VQj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 17:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjE3VQd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 17:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66B6196
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 14:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED0CC633B0
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 21:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B5EC433AC;
        Tue, 30 May 2023 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685481385;
        bh=OMm9uaZLTXghGxmXMXSybptBN1eR9X1tIVu4ULcKB7k=;
        h=Date:To:From:Subject:From;
        b=aZo9scHeOIlZCsFvW5xrWnFd0hDomgFaM6IL+tymihBbgQTL5Yu8f708Puvd74pEC
         1a3shLXsGZrAVtShb5qw8jdkvsesXVu+xbWkTGs08Jb2dYLt0KoIUfPsoR5MMQVg8C
         7yG3QeZVqNN9tYQ0IWDCsEcPR/lUJGTtDzpHiesw=
Date:   Tue, 30 May 2023 14:16:24 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nphamcs@gmail.com,
        konrad.wilk@oracle.com, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-support-exclusive-loads.patch added to mm-unstable branch
Message-Id: <20230530211625.37B5EC433AC@smtp.kernel.org>
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
Date: Tue, 30 May 2023 21:02:51 +0000

Commit 71024cb4a0bf ("frontswap: remove frontswap_tmem_exclusive_gets")
removed support for exclusive loads from frontswap as it was not used.

Bring back exclusive loads support to frontswap by adding an
exclusive_loads argument to frontswap_ops.  Add support for exclusive
loads to zswap behind CONFIG_ZSWAP_EXCLUSIVE_LOADS.

Refactor zswap entry invalidation in zswap_frontswap_invalidate_page()
into zswap_invalidate_entry() to reuse it in zswap_frontswap_load().

With exclusive loads, we avoid having two copies of the same page in
memory (compressed & uncompressed) after faulting it in from zswap.  On
the other hand, if the page is to be reclaimed again without being
dirtied, it will be re-compressed.  Compression is not usually slow, and a
page that was just faulted in is less likely to be reclaimed again soon.

Link: https://lkml.kernel.org/r/20230530210251.493194-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    1 +
 mm/Kconfig                |   13 +++++++++++++
 mm/frontswap.c            |    7 ++++++-
 mm/zswap.c                |   23 +++++++++++++++--------
 4 files changed, 35 insertions(+), 9 deletions(-)

--- a/include/linux/frontswap.h~mm-zswap-support-exclusive-loads
+++ a/include/linux/frontswap.h
@@ -13,6 +13,7 @@ struct frontswap_ops {
 	int (*load)(unsigned, pgoff_t, struct page *); /* load a page */
 	void (*invalidate_page)(unsigned, pgoff_t); /* page no longer needed */
 	void (*invalidate_area)(unsigned); /* swap type just swapoff'ed */
+	bool exclusive_loads; /* pages are invalidated after being loaded */
 };
 
 int frontswap_register_ops(const struct frontswap_ops *ops);
--- a/mm/frontswap.c~mm-zswap-support-exclusive-loads
+++ a/mm/frontswap.c
@@ -216,8 +216,13 @@ int __frontswap_load(struct page *page)
 
 	/* Try loading from each implementation, until one succeeds. */
 	ret = frontswap_ops->load(type, offset, page);
-	if (ret == 0)
+	if (ret == 0) {
 		inc_frontswap_loads();
+		if (frontswap_ops->exclusive_loads) {
+			SetPageDirty(page);
+			__frontswap_clear(sis, offset);
+		}
+	}
 	return ret;
 }
 
--- a/mm/Kconfig~mm-zswap-support-exclusive-loads
+++ a/mm/Kconfig
@@ -46,6 +46,19 @@ config ZSWAP_DEFAULT_ON
 	  The selection made here can be overridden by using the kernel
 	  command line 'zswap.enabled=' option.
 
+config ZSWAP_EXCLUSIVE_LOADS
+	bool "Invalidate zswap entries when pages are loaded"
+	depends on ZSWAP
+	help
+	  If selected, when a page is loaded from zswap, the zswap entry is
+	  invalidated at once, as opposed to leaving it in zswap until the
+	  swap entry is freed.
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
@@ -1329,6 +1329,16 @@ shrink:
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
@@ -1403,6 +1413,8 @@ stats:
 		count_objcg_event(entry->objcg, ZSWPIN);
 freeentry:
 	spin_lock(&tree->lock);
+	if (!ret && IS_ENABLED(CONFIG_ZSWAP_EXCLUSIVE_LOADS))
+		zswap_invalidate_entry(tree, entry);
 	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
@@ -1423,13 +1435,7 @@ static void zswap_frontswap_invalidate_p
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
 
@@ -1472,7 +1478,8 @@ static const struct frontswap_ops zswap_
 	.load = zswap_frontswap_load,
 	.invalidate_page = zswap_frontswap_invalidate_page,
 	.invalidate_area = zswap_frontswap_invalidate_area,
-	.init = zswap_frontswap_init
+	.init = zswap_frontswap_init,
+	.exclusive_loads = IS_ENABLED(CONFIG_ZSWAP_EXCLUSIVE_LOADS),
 };
 
 /*********************************
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

