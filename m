Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832241;
	b=YfebqEupstzp8AnIq8vwII+J44A5JgOkLMLozPmGVJC0ntTo5P2syUtgi3PJ10mSlLdq
	 JSkHOP3zMwXo/vHlAMz/8Vy6vbWDLGG0U6Z3BJheUSwhrzfwIxp4s1XzYdT5wLEjUDHlC
	 8Ep1Y7O8Kp7HaCgwe3jl6pj3i6nZOnH76CJsG/e9s+ooRVKe7ob4695SHbnBq0qjPqDHa
	 l3Mn2dmlcuqhuOphKALl7uNv2hq9TqpDqAD0nPR4CBVUjEZlGzJ4wNI235DMsyFmQwZo/
	 bIHFRyYvX+UnQydt7qT7uF0w5pIQZE+HMhIfm32NPgyCl1o+vIE0GVFgcAFUP3F8DUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832241;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=x4ZcKIyU7Xf/BXbd/bIsPdLNYiGuJ/uLWVv2h1exWHE=;
	b=waXNjiKios6BdX9jxVXjs288YSIhFZaWDaFR0hSWDqSfBSeZhB0NqZNfk7R8Dk2fQ9O5
	 SfyxiCrEyrSfJ0GsfAaEqxzRqJHN6bAY0khRwDBYY0zGZJJRsNHiXPwB6np44iNVhOgbv
	 Mr0dlreE09k8rhXdAEWPkYnbUEtaLzXWSQDuoevevnQGgQbKiv0n2a62qr1P8xZ7gLIGR
	 RczmEyqLNvfkuFHKhtOOiDkuou4X3kwBC565v4HeTseOBmczpzRT4sIXwYZZdQZUOz4MY
	 PXM54fxjDocQqRm1fd9GJOEMvZZL2zO+SoX2WrAaPgb4bJEMEu5PhlCWcxfNTCs5MdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="TIcaSO/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676EC606A31E;
	Sat, 24 Oct 2026 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TIcaSO/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D14E1F01825;
	Sat, 24 Oct 2026 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832241;
	bh=x4ZcKIyU7Xf/BXbd/bIsPdLNYiGuJ/uLWVv2h1exWHE=;
	h=Date:To:From:Subject;
	b=TIcaSO/gEApELU/tY5cfpB00OomEhw4+QTmdcFhOp26YlJHx4pxm2ofxK9jA5gea/
	 DuCgc/Cxn3LCFP+UrLrLxo9cJyTXv/ECy3CMlwZq8htH62rlicnvdn+A2TV9lNqcl1
	 TdCQbysM7xCSNlaRhN7Yn0Yvu1/shP/XiSa3CAIw=
Date: Sat, 24 Oct 2026 01:57:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch removed from -mm tree
Message-Id: <20261024085721.2D14E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix use-after-free of a new anon folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/hugetlb: fix use-after-free of a new anon folio
Date: Thu, 15 Oct 2026 18:07:08 +0200

For a fault in a private mapping with nothing in the page cache,
hugetlb_no_page() allocates a folio, locks it and maps it.  The folio has
one reference, which belongs to the page table entry from then on.  After
dropping the page table lock the function still sets the migratable flag
of the folio and unlocks it.

Whoever zaps the entry in between frees the folio.  The fault holds the
fault mutex and the lock of the vma.  MADV_DONTNEED and the first unmap of
a hole punch, hugetlb_vmdelete_list(), do not take the fault mutex, and a
private vma only has a lock if it owns a reservation map: not with
MAP_NORESERVE, and not in the child after fork().

Then the flag is set in, and folio_unlock() is called on, a folio that is
free or has a new owner.  A surplus page goes back to the page allocator
while it is locked:

  BUG: Bad page state in process init  pfn:108e00
  flags: 0x200000000000059(locked|uptodate|dirty|head|node=0|zone=2)
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set

A page of the pool can be given to the next user, of any file, who locks
it and loses the lock to the late folio_unlock():

  kernel BUG at mm/filemap.c:1532!
   hugetlb_no_page+0x111b/0x23e0
   hugetlb_fault+0x3a9/0x14a0

An unprivileged process is enough: threads that write to a MAP_PRIVATE |
MAP_NORESERVE hugetlb mapping, threads that call MADV_DONTNEED on it, and
one that takes the freed pages for another file.

Until commit 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more
pmd sharing synchronization") the fault held i_mmap_rwsem for reading,
which everybody who zaps takes for writing.  The lock that commit
bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs") gave
to private vmas closed the window again, but only for those with a
reservation map.

Be done with the folio before the page table lock is dropped, as
hugetlb_wp() is with its copy.  The function already unlocks page cache
folios under that lock.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: simplify+move comment]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-2-42796911043b@kernel.org
Fixes: 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-use-after-free-of-a-new-anon-folio
+++ a/mm/hugetlb.c
@@ -5991,8 +5991,6 @@ static vm_fault_t hugetlb_no_page(struct
 		ret = hugetlb_wp(vmf);
 	}
 
-	spin_unlock(vmf->ptl);
-
 	/*
 	 * Only set hugetlb_migratable in newly allocated pages.  Existing pages
 	 * found in the pagecache may not have hugetlb_migratable if they have
@@ -6003,6 +6001,12 @@ static vm_fault_t hugetlb_no_page(struct
 
 	if (folio_locked)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(vmf->ptl);
 out:
 	hugetlb_vma_unlock_read(vma);
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are


