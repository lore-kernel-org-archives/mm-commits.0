Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB194071F3
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525501; cv=none; b=b+FMyAZgmF9MmGJLfLja6DakBtFjy+ePp2d29eXH9mxaSw4WQ8Nt1F3UWor5eucqVHq1GtCi3ysByB/VxtWOYmgyn6azLTiP1Xw1NDDbNo9C1lKhUWvde2q+Q//+6Ni1pw6oeC4pbxBahVO/yHYgg5U7c1MtGzc1Nc6v0r7HbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525501; c=relaxed/simple;
	bh=ZPF9wNCd627ItxjEkNzqJnepig/Hm/P21l95TnB4aTs=;
	h=Date:To:From:Subject:Message-Id; b=VUN7+t77CBizWRRLZwDFzCoWpdraBvcTaiLeS9iIy2iBs+FVDdzdPxDyX5aHQlYLjIfa4O8hsac3lOuXLgfnVsA6wIF78tiZf1K5zhtCm7o6y9spaph7mX2lPDMY/YJOtFkiUHCtqOZKLNdtMt2bESDy4RCKYyAH8sdOCQ3e9Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZaSZTCvq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZaSZTCvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0069E1F00893;
	Fri,  9 Oct 2026 05:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525500;
	bh=2dpf9bFxzihVxM7A617JQNmCy5cIqJ4IzwCpRUmVFtk=;
	h=Date:To:From:Subject;
	b=ZaSZTCvqcEmvFPYcV5yqt4aPnw3l2kSLwr4LIM7DXh5gefUhSm/A9R93aAeyz0WKg
	 I/gOzWax3hWtMX82Z+QHQIxX3A+hEIL9YmbVNhHxpfVWIgH/FBo6ei7/Xc8G9ImK/m
	 ZaeMrWqejMv0WrHF9lKR7ZD84+4JEj/Ln4ezh3dg=
Date: Thu, 08 Oct 2026 22:58:19 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-potential-null-dereference-when-trying-a-sleep-table-allocation.patch removed from -mm tree
Message-Id: <20261009055820.0069E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix potential NULL dereference when trying a sleep table allocation
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-potential-null-dereference-when-trying-a-sleep-table-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: fix potential NULL dereference when trying a sleep table allocation
Date: Mon, 7 Sep 2026 17:13:53 +0800

Patch series "mm, swap: some random fixes and cleanups", v3.

This series contains some random fixes and cleanups.  More details can be
found in respective patches.


This patch (of 4):

The root cause of this issue is because multi-tables are updated in non
atomic context.  To be more specific, the issue could be triggerred as
following:

swap_alloc_fast         swap_cluster_populate()
                         /* Try a sleep allocation */
                         spin_unlock(&ci->lock);
                         swap_cluster_alloc_table()
                          rcu_assign_pointer(ci->table, table);

 ci = swap_cluster_lock(si, offset)
 cluster_is_usable(ci, order）
  if (!cluster_table_is_alloced(ci)) // ok
 alloc_swap_scan_cluster()
  cluster_scan_range()
   __swap_table_get()

                          /* free table when more table allocation fails */
                          ci->memcg_table = kzalloc_obj(*ci->memcg_table,
                                                        gfp);
                          if (!ci->memcg_table)
                           swap_cluster_free_table()
                            rcu_assign_pointer(ci->table, NULL);

    table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
     atomic_long_read(&table[off]); // NULL dereference

Since memory order guarantee between ci->table, as well as between
ci->table and ci->zero_bitmap, fix the issue by making tables visible at
the end of swap_cluster_populate().

Current memory order guarantee is as following: On write side:
rcu_assign_pointer(ci->table, table) will offer release to ensure
zero_bitmap and memcg_table visible before ci->table.

On read side:
folio_alloc_swap
 swap_alloc_fast/swap_alloc_slow
  /* ci->table: protected by cluster lock */
  swap_cluster_lock
  cluster_is_usable
  ...
  __swap_table_set
  ...
  swap_cluster_unlock

 mem_cgroup_try_charge_swap
  ...
  /* memcg_table: protected by cluster lock */
  swap_cluster_get_and_lock
  __swap_cgroup_set
  swap_cluster_unlock

swap_writeout
 swap_zeromap_folio_set
  /* zero_bitmap: protected by cluster lock */
  swap_cluster_get_and_lock
  __swap_table_set_zero
  swap_cluster_unlock

Link: https://lore.kernel.org/20260907091356.53026-1-shikemeng@huaweicloud.com
Link: https://lore.kernel.org/20260907091356.53026-2-shikemeng@huaweicloud.com
Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 mm/swapfile.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-potential-null-dereference-when-trying-a-sleep-table-allocation
+++ a/mm/swapfile.c
@@ -416,6 +416,17 @@ static void swap_cluster_free_table_foli
 	folio_put(folio);
 }
 
+static void swap_cluster_free_count_table(struct swap_table *table)
+{
+	if (!SWP_TABLE_USE_PAGE) {
+		kmem_cache_free(swap_table_cachep, table);
+		return;
+	}
+
+	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
+		 swap_cluster_free_table_folio_rcu_cb);
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	struct swap_table *table;
@@ -435,13 +446,7 @@ static void swap_cluster_free_table(stru
 		return;
 
 	rcu_assign_pointer(ci->table, NULL);
-	if (!SWP_TABLE_USE_PAGE) {
-		kmem_cache_free(swap_table_cachep, table);
-		return;
-	}
-
-	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
-		 swap_cluster_free_table_folio_rcu_cb);
+	swap_cluster_free_count_table(table);
 }
 
 static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
@@ -464,14 +469,12 @@ static int swap_cluster_alloc_table(stru
 	if (!table)
 		return -ENOMEM;
 
-	rcu_assign_pointer(ci->table, table);
-
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
-			swap_cluster_free_table(ci);
+			swap_cluster_free_count_table(table);
 			return -ENOMEM;
 		}
 	}
@@ -482,9 +485,16 @@ static int swap_cluster_alloc_table(stru
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
 	if (!ci->zero_bitmap) {
 		swap_cluster_free_table(ci);
+		swap_cluster_free_count_table(table);
 		return -ENOMEM;
 	}
 #endif
+
+	/*
+	 * Make tables visible to cluster_is_usable() after everything is
+	 * ready.
+	 */
+	rcu_assign_pointer(ci->table, table);
 	return 0;
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


