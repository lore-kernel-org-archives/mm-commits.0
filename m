Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A409717578
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118481; cv=none; b=owLNjg+tjL1ZgLYW0aHxY5WgKTlyVxkVCl2PZGa2Cun5pHBKBi4mwsol7WyCKQKL/iEbgKvSxsaywteacZVeRHSMwZD0MwpLmAVb5zFswa0pfQbUrbDCULSNDkkkB9fen+I1gUT85IDpShepWR7nfNHZ+ZItZhzGsqCCkGmleOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118481; c=relaxed/simple;
	bh=O6Zbkf1cT8VqwGfkUP8YDAcFyjPFLDnyxTYPMC+Yzuk=;
	h=Date:To:From:Subject:Message-Id; b=au6ymx0jpbb1tC9bBjm0Y+vdxKNfCX2JQcUAQam3REMMG5YgucpL18yNOJbOf3bLgk/hYcJMMwmpdTh81R/zdimPphbCX/G+GoO3dORTrVMRu1QRR9En0dKTwfDAJ17hZgHao2qbTBxktSDON3iqZMubnNOngZjwmJLj87qcspE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLjxtKSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLjxtKSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719D6C4CEED;
	Tue, 13 May 2025 06:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118481;
	bh=O6Zbkf1cT8VqwGfkUP8YDAcFyjPFLDnyxTYPMC+Yzuk=;
	h=Date:To:From:Subject:From;
	b=MLjxtKSZIMjRShlFlFPjApzKgk2YRCbKuSZNW8XJSJN5ShkSkED6zEW2fRNcTuGEz
	 7nXWo6LzDXqpN+5TM4215OYJFqc0G2kbJn+ddkygjMx6d3WH4Uq0fRzY2J7rUJqcPw
	 M6k327/tXPoUxDDuiVZkCX1XO4IK4R3kN1vyGDJ8=
Date: Mon, 12 May 2025 23:41:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shivankg@amd.com,shaggy@kernel.org,lkp@intel.com,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,dan.carpenter@linaro.org,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch removed from -mm tree
Message-Id: <20250513064121.719D6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
has been removed from the -mm tree.  Its filename was
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch

This patch was dropped because it was folded into jfs-implement-migrate_folio-for-jfs_metapage_aops.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
Date: Thu May  1 03:52:07 PM PDT 2025

fix build by making fs/jfs/jfs_metapage.c change dependent upon
CONFIG_MIGRATION

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
+++ a/fs/jfs/jfs_metapage.c
@@ -152,8 +152,10 @@ static inline void dec_io(struct folio *
 		handler(folio, anchor->status);
 }
 
-static int __metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				    struct folio *src, enum migrate_mode mode)
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
 {
 	struct meta_anchor *src_anchor = src->private;
 	struct metapage *mps[MPS_PER_PAGE] = {0};
@@ -199,8 +201,10 @@ static int __metapage_migrate_folio(stru
 
 	return MIGRATEPAGE_SUCCESS;
 }
+#endif	/* CONFIG_MIGRATION */
 
 #else
+
 static inline struct metapage *folio_to_mp(struct folio *folio, int offset)
 {
 	return folio->private;
@@ -224,8 +228,10 @@ static inline void remove_metapage(struc
 #define inc_io(folio) do {} while(0)
 #define dec_io(folio, status, handler) handler(folio, status)
 
-static int __metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				    struct folio *src, enum migrate_mode mode)
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
 {
 	struct metapage *mp;
 	int page_offset;
@@ -249,6 +255,7 @@ static int __metapage_migrate_folio(stru
 
 	return MIGRATEPAGE_SUCCESS;
 }
+#endif	/* CONFIG_MIGRATION */
 
 #endif
 
@@ -629,11 +636,13 @@ static bool metapage_release_folio(struc
 	return ret;
 }
 
+#ifdef CONFIG_MIGRATION
 /*
  * metapage_migrate_folio - Migration function for JFS metapages
  */
-static int metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				  struct folio *src, enum migrate_mode mode)
+static int metapage_migrate_folio(struct address_space *mapping,
+				  struct folio *dst, struct folio *src,
+				  enum migrate_mode mode)
 {
 	int expected_count;
 
@@ -646,6 +655,9 @@ static int metapage_migrate_folio(struct
 		return -EAGAIN;
 	return __metapage_migrate_folio(mapping, dst, src, mode);
 }
+#else
+#define metapage_migrate_folio NULL
+#endif	/* CONFIG_MIGRATION */
 
 static void metapage_invalidate_folio(struct folio *folio, size_t offset,
 				    size_t length)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

jfs-implement-migrate_folio-for-jfs_metapage_aops.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

