Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124584;
	b=OR6rY+vBIvMuDGe+hZ3XoMc1aq3zxAkIeW8aL8zxcLa6eDVmmeewngHNEo+LsUTAjQeC
	 co47bZNywk5dhrEPNzhirTx5RWtCE+8HY/sVgrNcjPvWlOc4TNM8yZGIr2LC8kNYYI4Ud
	 xak3muGNpUBwBqN5xkJuEYJ7jIP6n/CPCW5Vi5LTevaAOQpwuH2h3Ld8FjwByBnW7XT6J
	 ehthzrGD1+WfPnn18Gc7MarUW8ILpmsc4NUzqnPAUBcxUf023Blw82cGXtNSGV2BxmTQd
	 Y8Ng+x7jh6YP+p6zIBJnN0iFURfxIyUvdjRnu/D552/YtooKkiNZmUrH/zJRfDRRV+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124584;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pIbOM3MuCmZ3i3TlkFCVUyvmYToQ8qiGEOEg2dhoJKM=;
	b=ZDhn7hNayEOvLhL6xouw9IqH2UZm2KgjGFeYPRsTMGzd7L/e7zVdF7SDEDzVE59wAeOE
	 Yfq4pJnxDKLt25EhQrmTGHCQ2638f8Vlh2Yr+e/dyR/pPz8TXjWD3zPXx/gqlGgSmR2+I
	 8Umq6qAnMpCTpx6gpcYTgSH/bFreeciYuHCfC3a9VUjNEgT3NWkeUMu0aO6WMGJkJFyRV
	 ARasN9J2wCKkIMBPCD9z3yiEEXDpCRcLpifYDTZJHHatGSbkIQgiQox9dRYYVP/QQhzJm
	 Q6sT6lWwdX1tIG1/38u5ZEC7Aui5TtY9sN1rmAzZ81ta1lcLyHLc2WserzuRN7leOJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bCrm1GzF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88960606A320
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bCrm1GzF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB881F01825;
	Tue, 27 Oct 2026 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793124584;
	bh=pIbOM3MuCmZ3i3TlkFCVUyvmYToQ8qiGEOEg2dhoJKM=;
	h=Date:To:From:Subject;
	b=bCrm1GzFz9T8iyNGc3Q51jZHcuR4Zd/XNuQSoLtFT7mOFKZ8tGDS63vGAsHgKnCl+
	 0Zbf+2uRIF7gslVsyI4DamhnamXLg/+ANCvRxbId1awSs/0k3ozvjIxPaPWu/bf6Pz
	 A7z/EixBprcTPJOF0sj+s+7+qSZkOZfXe7IEvMiQ=
Date: Tue, 27 Oct 2026 11:09:43 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-shmem-hold-off-eviction-in-shmem_writeout.patch removed from -mm tree
Message-Id: <20261027180944.5FB881F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/shmem: hold off eviction in shmem_writeout()
has been removed from the -mm tree.  Its filename was
     mm-shmem-hold-off-eviction-in-shmem_writeout.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/shmem: hold off eviction in shmem_writeout()
Date: Mon, 26 Oct 2026 10:40:39 +0100

Once shmem_writeout() has moved the folio from the page cache to the
swap cache, the folio lock no longer keeps the inode alive: truncation
and eviction find a swap entry, free it and do not wait for anybody.
That did not matter as long as swap_writeout() was the last thing the
function did.  But since it puts the folio back when swap_writeout()
returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
afterwards:

  reclaim                               last close of an unlinked file
  shmem_writeout()
    shmem_delete_from_page_cache()
    swap_writeout()
      zswap_store() fails               shmem_evict_inode()
      writeback is disabled               shmem_truncate_range()
      return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
                                        destroy_inode()
                                        ... RCU grace period, freed
    shmem_add_to_page_cache(mapping)
      xas_lock_irq()            <- use after free

swap_writeout() behaves that way if zswap is enabled, cannot take the
folio and the memcg or one of its ancestors has memory.zswap.writeback
set to 0.

shmem_unuse() already added infrastructure to deal with that.
Reuse info->stop_eviction to protect the inode during writeout. Increment
it before removing the folio from the page cache, and decrement it after
swap_writeout() and any attempted reinsertion and inode accounting.
In shmem_evict_inode(), wait for the counter to reach zero even if
swapoff has already removed the inode from the swap list. Add some helpers
to make the code easier to digest.

Fix generated by an LLM and sent by Josef Bacik in private.

[david@kernel.org: code cleanups; improve description]
Link: https://lore.kernel.org/20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org
Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Chris Mason <mason@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <sashiko-bot@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 86b9d19f26c7e..c551e33c697fe 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1619,6 +1619,17 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 	return error;
 }
 
+static void shmem_disallow_eviction(struct shmem_inode_info *info)
+{
+	atomic_inc(&info->stop_eviction);
+}
+
+static void shmem_allow_eviction(struct shmem_inode_info *info)
+{
+	if (atomic_dec_and_test(&info->stop_eviction))
+		wake_up_var(&info->stop_eviction);
+}
+
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1631,16 +1642,21 @@ static void shmem_evict_inode(struct inode *inode)
 		mapping_set_exiting(inode->i_mapping);
 		shmem_truncate_range(inode, 0, (loff_t)-1);
 		shmem_unused_huge_del(inode);
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
+		/*
+		 * Writeout may still use the inode after swapoff has removed it
+		 * from the swaplist, so always wait at least once.
+		 */
+		do {
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
+			if (list_empty(&info->swaplist))
+				break;
 			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
 			spin_unlock(&shmem_swaplist_lock);
-		}
+		} while (!list_empty(&info->swaplist));
 	}
 
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1779,15 +1795,14 @@ int shmem_unuse(unsigned int type)
 		 * remove placeholder inode from swaplist, nor let it be freed
 		 * (igrab() would protect from unlink, but not from unmount).
 		 */
-		atomic_inc(&info->stop_eviction);
+		shmem_disallow_eviction(info);
 		spin_unlock(&shmem_swaplist_lock);
 
 		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
 		spin_lock(&shmem_swaplist_lock);
-		if (atomic_dec_and_test(&info->stop_eviction))
-			wake_up_var(&info->stop_eviction);
+		shmem_allow_eviction(info);
 		if (error)
 			break;
 		if (list_empty(&info->swaplist))
@@ -1918,6 +1933,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
+		/*
+		 * Once the folio has left the page cache, its lock no longer
+		 * keeps the inode from being evicted and freed: hold eviction
+		 * off, in case the folio has to be put back below.
+		 */
+		shmem_disallow_eviction(info);
+
 		folio_dup_swap(folio, NULL);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -1925,6 +1947,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
+			shmem_allow_eviction(info);
 			return error;
 		}
 
@@ -1941,6 +1964,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			shmem_recalc_inode(inode, 0, -nr_pages);
 			folio_put_swap(folio, NULL);
 		}
+		shmem_allow_eviction(info);
 
 		/*
 		 * The swap_cache_del_folio() below could be left for


Patches currently in -mm which might be from josef@toxicpanda.com are


