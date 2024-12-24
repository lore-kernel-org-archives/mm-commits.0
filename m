Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003F28FD
	for <mm-commits@vger.kernel.org>; Tue, 24 Dec 2024 01:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735002721; cv=none; b=sVPC1Stov7iVEkV7sCt4kVd+x+Xpu5v0s0SMbOM9J7+Ry+3gQcqQONiddlsqouUSdCAA51cOfgGCIU4CtlVcRXcKyoPaGQnFZfE1wVuieEtXzj4fGpA/UeNNfod1NbiGoXhWZpBj05XbkZUtkbvWhMaH3xSqxds9XnPiKCzGHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735002721; c=relaxed/simple;
	bh=Aat/uDDlvYZGmlbu0O7K/n1//eVo3tNsb2zfgSC8o44=;
	h=Date:To:From:Subject:Message-Id; b=RyqsjJsldhQb5RIo1YLEAp5ZMl5gak2rRRQrKrnF8BKVk23omnPlUhx31re8/C9wV1Zp85miTGxYOZPvaQT0nRwiH8TBpL0GDc2/GeVLUbzCV+0oq/igg34j7cHDECpPkKmbEoxxy/aYSfV0cjyW28LAulE8gdz1s/rqKQImbvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1EBQjtUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1EBQjtUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D0BC4CED3;
	Tue, 24 Dec 2024 01:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735002721;
	bh=Aat/uDDlvYZGmlbu0O7K/n1//eVo3tNsb2zfgSC8o44=;
	h=Date:To:From:Subject:From;
	b=1EBQjtUZLijs0HmAjbpyVbnokggqx08gufVRNFnOchZjrkuXih3PkWW95BJI6k3Ol
	 SjHpYjFMKYgoM5v6JRfL7t0pF6iTtMgJTk7qoNDJ8g14gr5qDGHbd5gfSSIZ+ZiTLp
	 HTlRYZUM1ZFeDTrp3D6cjcuxf6fU0kELifeTGw9A=
Date: Mon, 23 Dec 2024 17:12:00 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,sashal@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch added to mm-hotfixes-unstable branch
Message-Id: <20241224011200.E0D0BC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, madvise: fix potential workingset node list_lru leaks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, madvise: fix potential workingset node list_lru leaks
Date: Sun, 22 Dec 2024 20:29:36 +0800

Since commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when
needed"), all list_lru users need to allocate the items using the new
infrastructure that provides list_lru info for slab allocation, ensuring
that the corresponding memcg list_lru is allocated before use.

For workingset shadow nodes (which are xa_node), users are converted to
use the new infrastructure by commit 9bbdc0f32409 ("xarray: use
kmem_cache_alloc_lru to allocate xa_node").  The xas->xa_lru will be set
correctly for filemap users.  However, there is a missing case: xa_node
allocations caused by madvise(..., MADV_COLLAPSE).

madvise(..., MADV_COLLAPSE) will also read in the absent parts of file
map, and there will be xa_nodes allocated for the caller's memcg (assuming
it's not rootcg).  However, these allocations won't trigger memcg list_lru
allocation because the proper xas info was not set.

If nothing else has allocated other xa_nodes for that memcg to trigger
list_lru creation, and memory pressure starts to evict file pages,
workingset_update_node will try to add these xa_nodes to their
corresponding memcg list_lru, and it does not exist (NULL).  So they will
be added to rootcg's list_lru instead.

This shouldn't be a significant issue in practice, but it is indeed
unexpected behavior, and these xa_nodes will not be reclaimed effectively.
And may lead to incorrect counting of the list_lru->nr_items counter.

This problem wasn't exposed until recent commit 28e98022b31ef
("mm/list_lru: simplify reparenting and initial allocation") added a
sanity check: only dying memcg could have a NULL list_lru when
list_lru_{add,del} is called.  This problem triggered this WARNING.

So make madvise(..., MADV_COLLAPSE) also call xas_set_lru() to pass the
list_lru which we may want to insert xa_node into later.  And move
mapping_set_update to mm/internal.h, and turn into a macro to avoid
including extra headers in mm/internal.h.

Link: https://lkml.kernel.org/r/20241222122936.67501-1-ryncsn@gmail.com
Fixes: 9bbdc0f32409 ("xarray: use kmem_cache_alloc_lru to allocate xa_node")
Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/675d01e9.050a0220.37aaf.00be.GAE@google.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    9 ---------
 mm/internal.h   |    6 ++++++
 mm/khugepaged.c |    3 +++
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/filemap.c~mm-madvise-fix-potential-workingset-node-list_lru-leaks
+++ a/mm/filemap.c
@@ -124,15 +124,6 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
-static void mapping_set_update(struct xa_state *xas,
-		struct address_space *mapping)
-{
-	if (dax_mapping(mapping) || shmem_mapping(mapping))
-		return;
-	xas_set_update(xas, workingset_update_node);
-	xas_set_lru(xas, &shadow_nodes);
-}
-
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
--- a/mm/internal.h~mm-madvise-fix-potential-workingset-node-list_lru-leaks
+++ a/mm/internal.h
@@ -1504,6 +1504,12 @@ static inline void shrinker_debugfs_remo
 /* Only track the nodes of mappings with shadow entries */
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
+#define mapping_set_update(xas, mapping) do {			\
+	if (!dax_mapping(mapping) && !shmem_mapping(mapping)) {	\
+		xas_set_update(xas, workingset_update_node);	\
+		xas_set_lru(xas, &shadow_nodes);		\
+	}							\
+} while (0)
 
 /* mremap.c */
 unsigned long move_page_tables(struct vm_area_struct *vma,
--- a/mm/khugepaged.c~mm-madvise-fix-potential-workingset-node-list_lru-leaks
+++ a/mm/khugepaged.c
@@ -19,6 +19,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
+#include <linux/dax.h>
 #include <linux/ksm.h>
 
 #include <asm/tlb.h>
@@ -1837,6 +1838,8 @@ static int collapse_file(struct mm_struc
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	mapping_set_update(&xas, mapping);
+
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-fix-false-warning-of-negative-counter.patch
mm-madvise-fix-potential-workingset-node-list_lru-leaks.patch
mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch

