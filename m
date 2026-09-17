Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D93C5540
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 04:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789620563; cv=none; b=YXBcDM0Qd3ev4OOWlE9hh4poZ0HvKjmSQpPODp786fuOSBbYHInMKPXx2pt5e49wZPo5i1CJAfOgtbyBP8t6N2kE+iIMcUxIkP9WbNOpAE0xmo1cxCSnmcAoUJ0Y1AWkx54ynedDc4eSEErujJ0KuTYignTnyR8K8g7yNLLyZ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789620563; c=relaxed/simple;
	bh=k5FKJQJOUTMpRMQ2paxANNnlaPU3e8RQ4VpCeH/QD3s=;
	h=Date:To:From:Subject:Message-Id; b=ak3DVqQ+zHijla6tX02jbM2KjcHvqu7DgdkEkYwIr+dkMXFKZUyKjNPPGlPO4Ni6nbtimcqCopFg8MnTDz5CL2reoPefYpon3ke4vkwJKmJ8mbUNyLbhY9hPSZKBbQVRVkt0k1mCNLcBM2KrFEcuDuIhY/0qNmVOw58fplwvm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WydyZzDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WydyZzDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A9B1F000FF;
	Thu, 17 Sep 2026 04:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789620561;
	bh=z08EHdkvHH+39PkheJj8zxNdn5ML8FEEFTWBeFdh2+E=;
	h=Date:To:From:Subject;
	b=WydyZzDzOnGH/YUREzkPfJleIpkNC0UQ0oox9qDX5hbHQnJkdFjv8TqNh7btqSw3P
	 +Qo+2Mvx5ORlljUS04k9NoCL+d2uIFc2ZksxqDXgoXV0jqPNQ0/U/Gz33rxBnFQqn8
	 eEftXZuQ2Xn10zA/+qZuEw6vzCYZflp6GAlC/AhI=
Date: Wed, 16 Sep 2026 21:49:20 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yosry@kernel.org,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,usama.arif@linux.dev,tz2294@columbia.edu,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,nphamcs@gmail.com,mhocko@kernel.org,ljs@kernel.org,kunwu.chan@gmail.com,kasong@tencent.com,jack@suse.cz,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,brauner@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch added to mm-new branch
Message-Id: <20260917044921.03A9B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: drop cold writeback folios via swap dropbehind
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: zswap: drop cold writeback folios via swap dropbehind
Date: Fri, 11 Sep 2026 14:13:30 +0200

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back.  The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

__swap_cache_alloc_folio() evaluates a refault on the new folio, and
workingset_refault() sets PG_active when it looks recent.  Until now
folio_add_lru() consumed that flag and __page_cache_release() cleared it
once the folio left the LRU.  This folio never reaches the LRU, so nothing
would clear PG_active and the folio would be freed with a
PAGE_FLAGS_CHECK_AT_FREE flag set, tripping bad_page() under
CONFIG_DEBUG_VM.  Clear it after allocation.

That is a workaround: the refault should not be evaluated on a writeback
buffer at all.  A fix for that is on the mailing list [1].

Link: https://lore.kernel.org/20260911121341.178028-4-alex@ghiti.fr
Link: https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.fr/ [1]
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
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

mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch
mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch
mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

