Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F072418A58
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525607; cv=none; b=aFR/YRRVTO/fnn2fQyTaFmSPVz7IYiaCmDQSE2Dq456Xje59UaxPK8Affo4lfWzA2rB2sv9gtHgECTG43OX4OT/7Vz1BabXPaJRnjEInNUSTi3zLMmoL77ANAxcwwEEzJTmsYvtg2LvrEvLhXjFp5L6dS6SpJulXlR4qhzoQXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525607; c=relaxed/simple;
	bh=GGJ5W8YaLUmJM+lzZPQZjRzfyK33nFmlOwNMQFriACM=;
	h=Date:To:From:Subject:Message-Id; b=n1ADe3x1MyByE8B/RAxfr9dknv3jmQva4BgXeVJf+/YYnE5GD7ro61dbuwSs9Zh7LzYGLDTNu4vzxQcitl42v5DudMJRmH51uNXvzdIscS/pRJo5CENNxrh2JMXMP38hUMDi23rtoii+vTJ6z+e3zU+rHK4vJ+lI+cBGFdyI/Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtYvWlRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtYvWlRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01AF1F00898;
	Fri,  9 Oct 2026 06:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525602;
	bh=TpPlxiLzyd3aeRSkP9khgV6+k/zGiNdAhnzjOH9ycb0=;
	h=Date:To:From:Subject;
	b=ZtYvWlRlJh8d98zlOuTUSr5/JpW6fqpXvcnfhvERC/qbMderA6IKrilR9yEbp9EzE
	 V6HApipbGysEQTUv9bRub7zqP9Z+Jxr4oavnJeEX4V22hob7PTTIfa82tJfU8bveVM
	 k1fMOmTrSec8tFr1ENiewpzT5pdTKbjQT7MOpy/Y=
Date: Thu, 08 Oct 2026 23:00:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch removed from -mm tree
Message-Id: <20261009060002.B01AF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move unmap and remap into the split helpers
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move unmap and remap into the split helpers
Date: Wed, 23 Sep 2026 23:32:39 +0200

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to be
remapped, so remap_page() is now only called for anon splits and the anon
check in remap_page() is redundant and can be removed.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-8-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-unmap-and-remap-into-the-split-helpers
+++ a/mm/huge_memory.c
@@ -3640,9 +3640,6 @@ static void remap_page(struct folio *fol
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -4016,15 +4013,23 @@ static int __folio_freeze_split_anon(str
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
+	const int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
+	bool need_remap = false;
 	int ret = 0;
 
+	if (folio_mapped(folio)) {
+		need_remap = true;
+		unmap_folio(folio);
+	}
+
 	local_irq_disable();
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
@@ -4073,7 +4078,13 @@ static int __folio_freeze_split_anon(str
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (need_remap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
@@ -4105,6 +4116,8 @@ static int __folio_freeze_split_file(str
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4189,7 +4202,6 @@ static int __folio_freeze_split_file(str
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
@@ -4230,7 +4242,6 @@ static int __folio_split(struct folio *f
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4318,8 +4329,6 @@ static int __folio_split(struct folio *f
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4327,11 +4336,6 @@ static int __folio_split(struct folio *f
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so
_

Patches currently in -mm which might be from kasong@tencent.com are


