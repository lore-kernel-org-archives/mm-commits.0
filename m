Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859E64266B8
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525604; cv=none; b=VdcTfZDFPPxK9py4GxDHSoxd7XHkZIf4ejtoMwdeRf2x80fyHzlajIj4VsWZKyB4FIWVmy3sD3bszKdIVx/vQXa3rGTkV9Een04hWTv4hBVnbyGoAXBN/4NcacztKW2uqb1+N0OqhD4vhr3y2HANisZzRChPNNBor4mqcjao4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525604; c=relaxed/simple;
	bh=Hx79cSaNv5at7c3dF7Cno0Mr7Xy+TUnW5EfbxOB/FdE=;
	h=Date:To:From:Subject:Message-Id; b=B/QhFrV9Su0Rmpr7ZWiaBtodocbh/gfK3DW5xUttVo2LBDw5Jy35MXtVmtQ0KTdHwrmtlc/xa/hQkTcdxR/K7Ixk2HdKhYXvajES7wX214VOdWFuYil6HZu6fJGj/PrtN+nddwfodEImHflEoKL488CXHgslx33h4SxEdEY4fkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Aza2c76N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Aza2c76N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1B01F000FF;
	Fri,  9 Oct 2026 06:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525601;
	bh=q/L5da+BDXof3jMvDJUcXy1vcuzVwRHPAIOqvigNkik=;
	h=Date:To:From:Subject;
	b=Aza2c76ND8teXCjg93R1p2ExJI6T58xJDyRkSomLpCRBN9WwOgr/XUHnDE7AIQmpg
	 g6Dxt2thEFRj8vE6liGesMSxWmWCaj+nUaiZ2gpCYy5yg12GbVtBiAHzuzDqTZnKQN
	 cOZ91TBd0cdtNRO1hCMX38VrrsZsrQPi3MFfHOM0=
Date: Thu, 08 Oct 2026 23:00:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch removed from -mm tree
Message-Id: <20261009060000.DF1B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move EOF trimming into the file split helper
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move EOF trimming into the file split helper
Date: Wed, 23 Sep 2026 23:32:38 +0200

Instead of receiving @end and @nr_shmem_dropped from the caller, the file
split helper now computes the EOF boundary and trims pages beyond it
itself, as this is only needed for file split.  This drops the redundant
parameter passing and sanity check.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-7-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
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

 mm/huge_memory.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-eof-trimming-into-the-file-split-helper
+++ a/mm/huge_memory.c
@@ -4082,16 +4082,29 @@ static int __folio_freeze_split_file(str
 		unsigned int new_order, struct page *split_at,
 		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
-		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+		enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end;
 	int ret;
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
+	/*
+	 * The loop below may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4156,10 +4169,9 @@ static int __folio_freeze_split_file(str
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(
 				new_folio, inode_to_wb(mapping->host));
@@ -4180,6 +4192,8 @@ static int __folio_freeze_split_file(str
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4216,9 +4230,7 @@ static int __folio_split(struct folio *f
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4295,17 +4307,6 @@ static int __folio_split(struct folio *f
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 * __split_frozen_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4324,11 +4325,7 @@ static int __folio_split(struct folio *f
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end,
-						&nr_shmem_dropped);
-
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
+						true, list, split_type);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
_

Patches currently in -mm which might be from kasong@tencent.com are


