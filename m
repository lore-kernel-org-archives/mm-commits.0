Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF45802
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178528; cv=none; b=d7tBCxiUBg4Yp/DQ7k4es4k7oZLKYcmodSPF8GADk844HPaDD3ZFgRXt9536xWVk6vm7Mj8LlwbhqaOaTuk1CgsPSUl01PPqJN4/SRXUmClNn9HGMeyTZwoC4u3UPH105zigzO+j9Ie6eh8FCJgyTlRsPQ0dTgN+V0ZRyjgjHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178528; c=relaxed/simple;
	bh=5iijkUS9qOYrD/njHo/xc11XEGP7GR6VntMYRhZ+ezM=;
	h=Date:To:From:Subject:Message-Id; b=bWY3mTfKBUGnvK2y0Cybmvft8jAKxbOXqAvUiSWYiFb2ycUt0meebIt+wNS1RdkRMGvyjKnHXYk4d/Luo1MYbT42p7kz/4CiVEdZZcSjJzb9WFIrZZK5xciEHzoEZ86PP99cyZD9vuaTgYKmU+P5pFPzVRn2QhmMEwq7tyclAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dCpbSrog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCpbSrog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EC3C43394;
	Tue,  6 Feb 2024 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178528;
	bh=5iijkUS9qOYrD/njHo/xc11XEGP7GR6VntMYRhZ+ezM=;
	h=Date:To:From:Subject:From;
	b=dCpbSrogjOuH8pF8YQ7WdtlUAYUpJerw5vai3IccHq7lqe0foh186smf3/AOqmfHE
	 oaRNz0ogX9zKXwaDCXMApYZwfzBb8TcNHkgBotaQn0Fka0Ph4Ad/cOWhvywCx42SVm
	 RChWzTdMCHfZwL21umWWc/wpKiLqIaOzyvnbklPA=
Date: Mon, 05 Feb 2024 16:15:28 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-only-support-zswap_exclusive_loads_enabled.patch added to mm-unstable branch
Message-Id: <20240206001528.95EC3C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: only support zswap_exclusive_loads_enabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-only-support-zswap_exclusive_loads_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-only-support-zswap_exclusive_loads_enabled.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: only support zswap_exclusive_loads_enabled
Date: Sun, 04 Feb 2024 03:06:03 +0000

The !zswap_exclusive_loads_enabled mode will leave compressed copy in
the zswap tree and lru list after the folio swapin.

There are some disadvantages in this mode:
1. It's a waste of memory since there are two copies of data, one is
   folio, the other one is compressed data in zswap. And it's unlikely
   the compressed data is useful in the near future.

2. If that folio is dirtied, the compressed data must be not useful,
   but we don't know and don't invalidate the trashy memory in zswap.

3. It's not reclaimable from zswap shrinker since zswap_writeback_entry()
   will always return -EEXIST and terminate the shrinking process.

On the other hand, the only downside of zswap_exclusive_loads_enabled
is a little more cpu usage/latency when compression, and the same if
the folio is removed from swapcache or dirtied.

More explanation by Johannes on why we should consider exclusive load
as the default for zswap:

  Caching "swapout work" is helpful when the system is thrashing. Then
  recently swapped in pages might get swapped out again very soon. It
  certainly makes sense with conventional swap, because keeping a clean
  copy on the disk saves IO work and doesn't cost any additional memory.

  But with zswap, it's different. It saves some compression work on a
  thrashing page. But the act of keeping compressed memory contributes
  to a higher rate of thrashing. And that can cause IO in other places
  like zswap writeback and file memory.

And the A/B test results of the kernel build in tmpfs with limited memory
can support this theory:

			!exclusive	exclusive
real                       63.80         63.01
user                       1063.83       1061.32
sys                        290.31        266.15

workingset_refault_anon    2383084.40    1976397.40
workingset_refault_file    44134.00      45689.40
workingset_activate_anon   837878.00     728441.20
workingset_activate_file   4710.00       4085.20
workingset_restore_anon    732622.60     639428.40
workingset_restore_file    1007.00       926.80
workingset_nodereclaim     0.00          0.00
pgscan                     14343003.40   12409570.20
pgscan_kswapd              0.00          0.00
pgscan_direct              14343003.40   12409570.20
pgscan_khugepaged          0.00          0.00

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-5-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   16 ----------------
 mm/zswap.c |   14 +++-----------
 2 files changed, 3 insertions(+), 27 deletions(-)

--- a/mm/Kconfig~mm-zswap-only-support-zswap_exclusive_loads_enabled
+++ a/mm/Kconfig
@@ -45,22 +45,6 @@ config ZSWAP_DEFAULT_ON
 	  The selection made here can be overridden by using the kernel
 	  command line 'zswap.enabled=' option.
 
-config ZSWAP_EXCLUSIVE_LOADS_DEFAULT_ON
-	bool "Invalidate zswap entries when pages are loaded"
-	depends on ZSWAP
-	help
-	  If selected, exclusive loads for zswap will be enabled at boot,
-	  otherwise it will be disabled.
-
-	  If exclusive loads are enabled, when a page is loaded from zswap,
-	  the zswap entry is invalidated at once, as opposed to leaving it
-	  in zswap until the swap entry is freed.
-
-	  This avoids having two copies of the same page in memory
-	  (compressed and uncompressed) after faulting in a page from zswap.
-	  The cost is that if the page was never dirtied and needs to be
-	  swapped out again, it will be re-compressed.
-
 config ZSWAP_SHRINKER_DEFAULT_ON
 	bool "Shrink the zswap pool on memory pressure"
 	depends on ZSWAP
--- a/mm/zswap.c~mm-zswap-only-support-zswap_exclusive_loads_enabled
+++ a/mm/zswap.c
@@ -139,10 +139,6 @@ static bool zswap_non_same_filled_pages_
 module_param_named(non_same_filled_pages_enabled, zswap_non_same_filled_pages_enabled,
 		   bool, 0644);
 
-static bool zswap_exclusive_loads_enabled = IS_ENABLED(
-		CONFIG_ZSWAP_EXCLUSIVE_LOADS_DEFAULT_ON);
-module_param_named(exclusive_loads, zswap_exclusive_loads_enabled, bool, 0644);
-
 /* Number of zpools in zswap_pool (empirically determined for scalability) */
 #define ZSWAP_NR_ZPOOLS 32
 
@@ -1722,16 +1718,12 @@ bool zswap_load(struct folio *folio)
 		count_objcg_event(entry->objcg, ZSWPIN);
 
 	spin_lock(&tree->lock);
-	if (zswap_exclusive_loads_enabled) {
-		zswap_invalidate_entry(tree, entry);
-		folio_mark_dirty(folio);
-	} else if (entry->length) {
-		zswap_lru_del(&entry->pool->list_lru, entry);
-		zswap_lru_add(&entry->pool->list_lru, entry);
-	}
+	zswap_invalidate_entry(tree, entry);
 	zswap_entry_put(entry);
 	spin_unlock(&tree->lock);
 
+	folio_mark_dirty(folio);
+
 	return true;
 }
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

