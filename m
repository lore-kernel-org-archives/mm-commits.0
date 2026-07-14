Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E26144C642;
	Tue, 14 Jul 2026 19:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057930; cv=none; b=WuFyc1c+d7SPTwHSmGzr4+eN4VOl224TQdOh18pkU2Q58varNnvbAn+jhjBQs6Rjc4heeYccUNWojfqh914LWdn4eh4+CubSx2iVTJx90POwdwCvz8fw/sUKTxGmsliGT1rMwQ/cQWFs5stMLXcmK4Pk2hmdv+5eb7ECveepVvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057930; c=relaxed/simple;
	bh=mkzmVwBkSgkC5RKoGeRG6ecRwJxm0QqRXQdUefts/Vw=;
	h=Date:To:From:Subject:Message-Id; b=sJyILSvx/cDfIMRMocckiZztTclm4gFav3DMPOwaefLye+/zrRvnNszsljXPxJB02Q0gWpV7ynRebORKrW2NfGKzmXz5pyPeoo9KzHkMf4sw4WO1kVK5A50f4uTUKQsbR5xtImvCLOHonrf6CB8nmqmQIOF3Xy1+RAJgIJ6D84I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KD58VbTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KD58VbTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89431F000E9;
	Tue, 14 Jul 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057929;
	bh=1Dxprz+I0kwUrds5EguUr7qrklLmPCc4v0d18vTHlpQ=;
	h=Date:To:From:Subject;
	b=KD58VbTMPkVwVv2oHBzoWisSW3IsTcsavIjC9W4uz16aviX83028EPpm4kECwG0i8
	 g7WrEePqOt28tKhwTMhtPttNuasVvTWVZdQUklMk+LWT8N6xIOw6C4kFxYEFfjt0re
	 99Cut6KzK5ACKUosSBC1D6D+UFwY3Pu/XgUdW3ww=
Date: Tue, 14 Jul 2026 12:38:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhanghao1@kylinos.cn,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kirill@shutemov.name,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-thp-pin-the-inode-across-a-file-folio-split.patch removed from -mm tree
Message-Id: <20260714193848.E89431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: pin the inode across a file folio split
has been removed from the -mm tree.  Its filename was
     mm-thp-pin-the-inode-across-a-file-folio-split.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>
Subject: mm: thp: pin the inode across a file folio split
Date: Mon, 13 Jul 2026 18:09:15 +0100

__folio_split() looks up mapping = folio->mapping for a file-backed folio
and keeps dereferencing it after the split completes:
shmem_uncharge(mapping->host) for folios dropped beyond EOF and
i_mmap_unlock_read(mapping) on the way out.

Nothing holds an inode reference for that duration.  The split relies on
the folio the caller keeps locked (@lock_at) to pin the inode through the
page cache: while it is locked and present, truncate_inode_pages_final()
in evict() cannot make progress.  But the split drops @lock_at from the
page cache when it falls beyond EOF (the @end handling in
__folio_freeze_and_split_unmapped()), while keeping it locked for the
caller.  That removes the last pin, and a concurrent final iput() can then
evict and RCU-free the inode before __folio_split() is done touching
mapping.

This is reachable from memory_failure(): poisoning a tail page of a shmem
THP that straddles EOF makes try_to_split_thp_page() split at that page,
so the dropped @lock_at is the folio returned locked.  The result is a
use-after-free, e.g.:

  BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
   i_mmap_unlock_read include/linux/fs.h:537 [inline]
   __folio_split+0x732/0x1640 mm/huge_memory.c:4100
   try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
   memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

  Freed by task 4601:
   shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
   i_callback+0x4c/0xa0 fs/inode.c:326
   destroy_inode+0x144/0x1e0 fs/inode.c:402
   evict+0x57f/0xac0 fs/inode.c:870

Pin the inode with igrab() before the split and drop the reference with
iput() after the last mapping dereference.  igrab() returns NULL only if
the inode is already being evicted (i_count 0 and I_FREEING set), which a
split racing eviction can observe; there is nothing safe to split then, so
return -EBUSY, which callers already handle.

Link: https://lore.kernel.org/20260713170915.239819-1-kirill@shutemov.name
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Kiryl Shutsemau (Meta) <kirill@shutemov.name>
Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/huge_memory.c~mm-thp-pin-the-inode-across-a-file-folio-split
+++ a/mm/huge_memory.c
@@ -3986,6 +3986,7 @@ static int __folio_split(struct folio *f
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
+	struct inode *inode = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4057,6 +4058,20 @@ static int __folio_split(struct folio *f
 		}
 
 		anon_vma = NULL;
+
+		/*
+		 * The locked @lock_at folio keeps the inode alive: eviction
+		 * cannot remove it from the page cache while it is locked. But
+		 * the split drops it if it lies beyond EOF, after which we
+		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
+		 * Hold an inode reference across the split to be safe.
+		 */
+		inode = igrab(mapping->host);
+		if (!inode) {
+			/* Inode is being evicted; nothing to split. */
+			ret = -EBUSY;
+			goto out;
+		}
 		i_mmap_lock_read(mapping);
 
 		/*
@@ -4139,6 +4154,8 @@ out_unlock:
 	}
 	if (mapping)
 		i_mmap_unlock_read(mapping);
+	if (inode)
+		iput(inode);
 out:
 	xas_destroy(&xas);
 	if (is_pmd_order(old_order))
_

Patches currently in -mm which might be from kirill@shutemov.name are


