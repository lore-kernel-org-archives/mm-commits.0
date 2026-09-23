Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5124728373
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202198; cv=none; b=dw0cfcGAKJjJqfEsKIcn5m3qBcXHq93nAiSA496SUujkbXDydf0Z1VbG0R44/sXDHRuG0niZAenUhLRr9gYrNi4CssJTY5lyX7KZS3KNU80jJA82k7sK12XFSY32pCMmmYY+Ga7UfgSlyEDRT+VqC+k9iWO4VfqGoZel+NQh2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202198; c=relaxed/simple;
	bh=A8XbdkRbAtcdeHLc7nA9ZUNDyD/IB5QKEw38boNXKEw=;
	h=Date:To:From:Subject:Message-Id; b=J3iPiSYpW5CZ6dhRsztgPlqPGxOIjItBEbjJcoZFlpDgPqjE8mOLsGV5Hq1iKXYyl42ckCwGB77tLmOz0Muv74dp1gKulpj11J2L7dOzPczPW/MjmtVAQFxHiD5zB4O2r0mB6OGd9S3FdngEFhcnQgiCINZ9rt9WEdSmyzjEbZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E8e9qKrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E8e9qKrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC921F00893;
	Wed, 23 Sep 2026 22:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202197;
	bh=0HuT31c4Ym3++v9dXhxDOqlyzuf7EyEOQKqkEvn9SuE=;
	h=Date:To:From:Subject;
	b=E8e9qKrTlL6XgHQJeoK+wrlqBSfA9HjJUfKM1nkAHV165Pu0rxRR46PW9ePKcg9K9
	 VnIQHvuBlXsGH9grdy5/Gs6ylShJekK51eVBBBog5bMZzlyYt9PV3irCPcRTATanDy
	 EuwMW4lG0kRKDWIFwgHN/6l/1bd85yoxCtCv7jis=
Date: Wed, 23 Sep 2026 15:23:16 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch removed from -mm tree
Message-Id: <20260923222317.1BC921F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move EOF trimming into the file split helper
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move EOF trimming into the file split helper
Date: Tue, 15 Sep 2026 01:14:48 +0800

Instead of receiving @end and @nr_shmem_dropped from the caller, the file
split helper now computes the EOF boundary and trims pages beyond it
itself, as this is only needed for file split.  This drops the redundant
parameter passing and sanity check.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-7-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

