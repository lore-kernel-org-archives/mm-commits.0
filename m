Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7F32D613
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247672; cv=none; b=hpfbBOZp5GEUpZie3U1OEofZDE00+NihXRKikyvkEUkE26qGrPVbVFhRZ26ySOG7fAHLli1/fJtcYJwEnglT51IZx++rtedfJvfV/puuB9OjKBeWZjIo9PELk3GLp8F01MOTJOp6CTPgu3JVi/qSwu9iS7p3otkeuoHR+nUeQuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247672; c=relaxed/simple;
	bh=X2/ZpyLtEtisjYjJOXYsuUgE7VCuBL/+ON46SBXsfqU=;
	h=Date:To:From:Subject:Message-Id; b=OYWWReCH9eDCob6k3dlawhetBJAt8qM0elvIHnA6Rx2sk9ryYbvsE84KbNjeC7OY7Hwm5yPg/tODClJgIeYdblIylL/IraJa0yxAuX56mCLqrgiYl+3pOiIqlB9mhFfl4U7gHqaiJJV8Z52xlvNoDfR2WfzfKr99AOkW4A6PCXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gvmBgMgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gvmBgMgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B99C4CEC2;
	Mon,  2 Sep 2024 03:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247671;
	bh=X2/ZpyLtEtisjYjJOXYsuUgE7VCuBL/+ON46SBXsfqU=;
	h=Date:To:From:Subject:From;
	b=gvmBgMgcLOYBM4xplsQoW/0rQQad1LTnlOlfi/OyzKCxpVrs8dvYYUTJubMeyt7QN
	 LhlTtN94KwB/yoyUi2gJjm61a2SKaBEzv4PzjRbimyrk2z4H+R8gOs4KceTG0aX1xb
	 /bVjZ2VWBM/BDvi++rrt+L0hoOt8tXfDCw5PpP3c=
Date: Sun, 01 Sep 2024 20:27:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch removed from -mm tree
Message-Id: <20240902032751.C0B99C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extend 'usage' parameter so that cluster_swap_free_nr() can be reused
has been removed from the -mm tree.  Its filename was
     mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: extend 'usage' parameter so that cluster_swap_free_nr() can be reused
Date: Wed, 24 Jul 2024 14:00:56 +1200

Extend a usage parameter so that cluster_swap_free_nr() can be reused by
both swapcache_clear() and swap_free().  __swap_entry_free() is quite
similar but more tricky as it requires the return value of
__swap_entry_free_locked() which cluster_swap_free_nr() doesn't support.

Link: https://lkml.kernel.org/r/20240724020056.65838-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused
+++ a/mm/swapfile.c
@@ -1344,7 +1344,8 @@ static void swap_entry_free(struct swap_
 }
 
 static void cluster_swap_free_nr(struct swap_info_struct *sis,
-		unsigned long offset, int nr_pages)
+		unsigned long offset, int nr_pages,
+		unsigned char usage)
 {
 	struct swap_cluster_info *ci;
 	DECLARE_BITMAP(to_free, BITS_PER_LONG) = { 0 };
@@ -1354,7 +1355,7 @@ static void cluster_swap_free_nr(struct
 	while (nr_pages) {
 		nr = min(BITS_PER_LONG, nr_pages);
 		for (i = 0; i < nr; i++) {
-			if (!__swap_entry_free_locked(sis, offset + i, 1))
+			if (!__swap_entry_free_locked(sis, offset + i, usage))
 				bitmap_set(to_free, i, 1);
 		}
 		if (!bitmap_empty(to_free, BITS_PER_LONG)) {
@@ -1388,7 +1389,7 @@ void swap_free_nr(swp_entry_t entry, int
 
 	while (nr_pages) {
 		nr = min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-		cluster_swap_free_nr(sis, offset, nr);
+		cluster_swap_free_nr(sis, offset, nr, 1);
 		offset += nr;
 		nr_pages -= nr;
 	}
@@ -3472,15 +3473,9 @@ int swapcache_prepare(swp_entry_t entry)
 
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
 {
-	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
-	unsigned char usage;
 
-	ci = lock_cluster_or_swap_info(si, offset);
-	usage = __swap_entry_free_locked(si, offset, SWAP_HAS_CACHE);
-	unlock_cluster_or_swap_info(si, ci);
-	if (!usage)
-		free_swap_slot(entry);
+	cluster_swap_free_nr(si, offset, 1, SWAP_HAS_CACHE);
 }
 
 struct swap_info_struct *swp_swap_info(swp_entry_t entry)
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

