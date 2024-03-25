Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BBAFC01;
	Mon, 25 Mar 2024 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711398209; cv=none; b=bU8RtRBOqgeeaYf7PXfW9m2jabqS6AOPEJ6nFNTnwklF2cvXQs3xq8byH5s8mwPIbazErFiIRN/5C9cvJT+tzhrm5tN69Y+FnFstIW1FbbTnLnCdn+0CaQYCTqWV+odhoVvuEGUuxVVXqQYB3hX/+cW8CoDzyIIcke40BFpbunE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711398209; c=relaxed/simple;
	bh=DoxiTmCsXo9ozNxzItljg2+v4wn9wCDzq+3qpjb5J7E=;
	h=Date:To:From:Subject:Message-Id; b=ncP6/8djFpO6FXKX9H7wqEC8Wu3NJjBM2apoUIn9muadwEco+FXSJinhJuCY/gk0Ri9N9c0DyO+qQEVtcq9mjMYy9YIr6S7dEfcy8hrWdHNjowlZCZyxF0BQCmTPctqJwpB/ww7Gflm+e61WtqFfs9tbP9KrcMSywj0xjv75w/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fb2Ee6CO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fb2Ee6CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DB3C433F1;
	Mon, 25 Mar 2024 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711398208;
	bh=DoxiTmCsXo9ozNxzItljg2+v4wn9wCDzq+3qpjb5J7E=;
	h=Date:To:From:Subject:From;
	b=Fb2Ee6COZMnXsZC44HTs7hfxA3qP6TS2VIJCohmZTM3IlF8GuZafFn3Q0uH1zf2Uz
	 AwdtyfMcN0neBOnCX7ycPGDh0lqB73Vjoohoi7P+9WHsxUUiu+eYNEA0+Fu8l5ZPsy
	 e/nCjsC5dUZzpU1kC5DA0ZoZHYTUpYoY1+qsh/8Y=
Date: Mon, 25 Mar 2024 13:23:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,nphamcs@gmail.com,hezhongkun.hzk@bytedance.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-data-loss-on-swp_synchronous_io-devices.patch added to mm-hotfixes-unstable branch
Message-Id: <20240325202328.70DB3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix data loss on SWP_SYNCHRONOUS_IO devices
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-data-loss-on-swp_synchronous_io-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-data-loss-on-swp_synchronous_io-devices.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: zswap: fix data loss on SWP_SYNCHRONOUS_IO devices
Date: Sun, 24 Mar 2024 17:04:47 -0400

Zhongkun He reports data corruption when combining zswap with zram.

The issue is the exclusive loads we're doing in zswap. They assume
that all reads are going into the swapcache, which can assume
authoritative ownership of the data and so the zswap copy can go.

However, zram files are marked SWP_SYNCHRONOUS_IO, and faults will try to
bypass the swapcache.  This results in an optimistic read of the swap data
into a page that will be dismissed if the fault fails due to races.  In
this case, zswap mustn't drop its authoritative copy.

Link: https://lore.kernel.org/all/CACSyD1N+dUvsu8=zV9P691B9bVq33erwOXNTmEaUbi9DrDeJzw@mail.gmail.com/
Fixes: b9c91c43412f ("mm: zswap: support exclusive loads")
Link: https://lkml.kernel.org/r/20240324210447.956973-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Tested-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-data-loss-on-swp_synchronous_io-devices
+++ a/mm/zswap.c
@@ -1636,6 +1636,7 @@ bool zswap_load(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
+	bool swapcache = folio_test_swapcache(folio);
 	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 	u8 *dst;
@@ -1648,7 +1649,20 @@ bool zswap_load(struct folio *folio)
 		spin_unlock(&tree->lock);
 		return false;
 	}
-	zswap_rb_erase(&tree->rbroot, entry);
+	/*
+	 * When reading into the swapcache, invalidate our entry. The
+	 * swapcache can be the authoritative owner of the page and
+	 * its mappings, and the pressure that results from having two
+	 * in-memory copies outweighs any benefits of caching the
+	 * compression work.
+	 *
+	 * (Most swapins go through the swapcache. The notable
+	 * exception is the singleton fault on SWP_SYNCHRONOUS_IO
+	 * files, which reads into a private page and may free it if
+	 * the fault fails. We remain the primary owner of the entry.)
+	 */
+	if (swapcache)
+		zswap_rb_erase(&tree->rbroot, entry);
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
@@ -1663,9 +1677,10 @@ bool zswap_load(struct folio *folio)
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPIN);
 
-	zswap_entry_free(entry);
-
-	folio_mark_dirty(folio);
+	if (swapcache) {
+		zswap_entry_free(entry);
+		folio_mark_dirty(folio);
+	}
 
 	return true;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-cachestat-fix-two-shmem-bugs.patch
mm-zswap-fix-writeback-shinker-gfp_noio-gfp_nofs-recursion.patch
mm-zswap-fix-data-loss-on-swp_synchronous_io-devices.patch
mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch

