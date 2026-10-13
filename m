Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD5484222
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865967; cv=none; b=PUmirVuYdHy7erDYgAKQ6Rw2ECFoyTms1UPfsEZRslI0VMzmbuH/YxiapbFIPhZ92ctavHMRQIHI1sL5OLgvn/LFv/o61mZQwiJJdxraa+WtOuS+3E8zUd/9uJAYY84ExRPfv9B9DpjWyslH2e9B0kGayYUR8qTAz0mXkn6dGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865967; c=relaxed/simple;
	bh=frJ0jObjBM4rV5+JMIA1C1gC5C3LlCUVMOAMPSN8xuM=;
	h=Date:To:From:Subject:Message-Id; b=Vsn4kRf/9xRoR3Jr6igtos2Fc+wr+prWBpI/tF6VAS1ldHwmZ8KwtUFkdiNxB37nuOxaekpLMgI854Upvnhk4gb/Tpy2KtBJZMMT7LqEhyYa+2niD3GJyk0+hFD6RQIQwm6VMEeQCaD/XqC72g0rB/8mRRzhtMOjUEj5ZKS9T6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8R4l6Ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8R4l6Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06FF1F00893;
	Tue, 13 Oct 2026 04:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865965;
	bh=q9qMxhSpP+f3AfD/vBl8stGbjsGTrXJoTYtzgXnAPIM=;
	h=Date:To:From:Subject;
	b=o8R4l6GaXaaIqDOdujyncr0v5N3NR2WKQxYQw6g5Bymqds6vVUtK4oMKaTbnF5qdc
	 Rjx/JS0T1dYKJY+vEiSJm/X0RGiHOf7gHPnCvpdr996QFaiS0+tAR/RWhy39P+1qoo
	 dR4JJwB/ZOGeAeGYaX3qfUxM0lM8te9LxnuUpNHY=
Date: Mon, 12 Oct 2026 21:32:45 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,yosry@kernel.org,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,usama.arif@linux.dev,tz2294@columbia.edu,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,mhocko@kernel.org,ljs@kernel.org,kunwu.chan@gmail.com,kasong@tencent.com,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,brauner@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch removed from -mm tree
Message-Id: <20261013043245.A06FF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: drop cold writeback folios via swap dropbehind
has been removed from the -mm tree.  Its filename was
     mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: zswap: drop cold writeback folios via swap dropbehind
Date: Mon, 21 Sep 2026 17:13:04 +0200

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

__swap_cache_alloc_folio() evaluates a refault on the new folio, and
workingset_refault() sets PG_active when it looks recent. Until now
folio_add_lru() consumed that flag and __page_cache_release() cleared it
once the folio left the LRU. This folio never reaches the LRU, so nothing
would clear PG_active and the folio would be freed with a
PAGE_FLAGS_CHECK_AT_FREE flag set, tripping bad_page() under
CONFIG_DEBUG_VM. Clear it after allocation.

That is a workaround: the refault should not be evaluated on a writeback
buffer at all. A fix for that is on the mailing list [1].

Link: https://lore.kernel.org/20260921151306.625134-4-alex@ghiti.fr
Link: https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.fr/ [1]
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chis Li <chrisl@kernel.org>
Cc: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/zswap.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/zswap.c~mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind
+++ a/mm/zswap.c
@@ -1032,7 +1032,8 @@ static int zswap_writeback_entry(struct
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
+
+	folio_clear_active(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1046,12 +1047,12 @@ static int zswap_writeback_entry(struct
 	tree = swap_zswap_tree(swpentry);
 	if (entry != xa_load(tree, offset)) {
 		ret = -ENOMEM;
-		goto out;
+		goto err;
 	}
 
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
-		goto out;
+		goto err;
 	}
 
 	xa_erase(tree, offset);
@@ -1065,18 +1066,30 @@ static int zswap_writeback_entry(struct
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	folio_set_dropbehind(folio);
+
+	/*
+	 * Drop our reference before starting writeback so the swap cache holds
+	 * the only one: the drop in folio_end_writeback() needs that for
+	 * remove_mapping_set_shadow() to succeed, otherwise the folio is
+	 * handed back to reclaim instead.
+	 *
+	 * Nothing can free the folio in the meantime: we hold the folio lock
+	 * until writeback starts, PG_writeback then blocks swap cache removal,
+	 * and folio_end_writeback() takes its own reference before clearing
+	 * PG_writeback and donates it to the drop.
+	 */
+	folio_put(folio);
 
 	/* start writeback */
 	__swap_writeout(&ctx, folio);
 	swap_write_submit(&ctx);
 
-out:
-	if (ret) {
-		swap_cache_del_folio(folio);
-		folio_unlock(folio);
-	}
+	return 0;
+
+err:
+	swap_cache_del_folio(folio);
+	folio_unlock(folio);
 	folio_put(folio);
 	return ret;
 }
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-submit-the-last-readahead-batch-before-unplugging.patch

