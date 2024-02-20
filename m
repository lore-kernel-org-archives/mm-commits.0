Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F317764E
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451933; cv=none; b=aovb8wer2olzA7FXsKKMW6publwES50xi2Ssg1Exb8W/FXcYVBcNBu6tkXaSnCmcTAPVZmLm/E6bYflM1uEOtLP8seRk5tzN+r/NUHl0krLyqBchpemY4bwt4yxZ0W/bMnb8AjQD+uH2q2/zvRICyeJcs9V+39YdHyv84RnZ0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451933; c=relaxed/simple;
	bh=zkaXRypaLIVPZ30fyPhvlajffvdB+b3WocxuViytDEk=;
	h=Date:To:From:Subject:Message-Id; b=WCOG4ZUcsPdcFgdIcaCaaCgohK3jZWDm0kNs17b5x4Vd29xWrZ7QpK/HXvQxztvlFDwLE6QUNCLxEU5/U3tUUGUik6xSBvg/Xjg9JT4jq6N4YOsXVf+iClLu97zrEF/zGxmjMs6SRuhFOJxPxO43Nou5wNWJzBgMMYrdTVUMHeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MbvhkKAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbvhkKAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0D2C433C7;
	Tue, 20 Feb 2024 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708451933;
	bh=zkaXRypaLIVPZ30fyPhvlajffvdB+b3WocxuViytDEk=;
	h=Date:To:From:Subject:From;
	b=MbvhkKAxx9/i53tQqacjaXYDjM4N/C1svtgiGArMvgKj82J0fjwMwcWE4h5O7XQA8
	 LP/6aV2v3HxO/iPFpYGMAPPZ745GccQhg20H8kiQoo2akoXAqnsuywUMXK0EeePBKP
	 YWVepaC3MmDQuSCnhtn8JCHzea+Pqw1rcT3XzHgA=
Date: Tue, 20 Feb 2024 09:58:52 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch added to mm-unstable branch
Message-Id: <20240220175852.DE0D2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove_zspage() don't need fullness parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch

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
Subject: mm/zsmalloc: remove_zspage() don't need fullness parameter
Date: Tue, 20 Feb 2024 06:53:01 +0000

We must remove_zspage() from its current fullness list, then use
insert_zspage() to update its fullness and insert to new fullness list. 
Obviously, remove_zspage() doesn't need the fullness parameter.

Link: https://lkml.kernel.org/r/20240220-b4-zsmalloc-cleanup-v1-2-5c5ee4ccdd87@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove_zspage-dont-need-fullness-parameter
+++ a/mm/zsmalloc.c
@@ -687,10 +687,10 @@ static void insert_zspage(struct size_cl
  * This function removes the given zspage from the freelist identified
  * by <class, fullness_group>.
  */
-static void remove_zspage(struct size_class *class,
-				struct zspage *zspage,
-				int fullness)
+static void remove_zspage(struct size_class *class, struct zspage *zspage)
 {
+	int fullness = zspage->fullness;
+
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
 
 	list_del_init(&zspage->list);
@@ -716,7 +716,7 @@ static int fix_fullness_group(struct siz
 	if (newfg == currfg)
 		goto out;
 
-	remove_zspage(class, zspage, currfg);
+	remove_zspage(class, zspage);
 	insert_zspage(class, zspage, newfg);
 out:
 	return newfg;
@@ -878,7 +878,7 @@ static void free_zspage(struct zs_pool *
 		return;
 	}
 
-	remove_zspage(class, zspage, ZS_INUSE_RATIO_0);
+	remove_zspage(class, zspage);
 	__free_zspage(pool, class, zspage);
 }
 
@@ -1609,7 +1609,7 @@ static struct zspage *isolate_src_zspage
 		zspage = list_first_entry_or_null(&class->fullness_list[fg],
 						  struct zspage, list);
 		if (zspage) {
-			remove_zspage(class, zspage, fg);
+			remove_zspage(class, zspage);
 			return zspage;
 		}
 	}
@@ -1626,7 +1626,7 @@ static struct zspage *isolate_dst_zspage
 		zspage = list_first_entry_or_null(&class->fullness_list[fg],
 						  struct zspage, list);
 		if (zspage) {
-			remove_zspage(class, zspage, fg);
+			remove_zspage(class, zspage);
 			return zspage;
 		}
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
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
mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch
mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch

