Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4C122089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957099; cv=none; b=FZ8MM03xZ2KwoQ2vkXGYnlcRYw9KiHLXFMpX8SMlEMTecT1dUaBNuMUlhcJJbgKYHRnH7FPaAKriE1I/mAb80NecPMKbvgbth7Hbb0gOp4IvwzFtLaMR4qJOH+xgGq13IFJ6LFYLevc2tlFYLgiQK6qPEWkITuVmVRMjZ/hqA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957099; c=relaxed/simple;
	bh=Uq512wrLiXCMm+WxPn3TMcCqLmY0pq0EVJdOPmyo/iA=;
	h=Date:To:From:Subject:Message-Id; b=eNd5IX2aGAKAJPlRW0wchaYiPgZe6ZG3ljBEvgw9WNKE8HeIYKVFC6229/V2qwReoPfTwm1/zRQiR+4g7R6e9MrBJOQ+Em5jyOmoxSSDE3crfo9T4hmXNLu33ZsnRs9LGhUv3xlifO/BDIPHRbk7JK60edkVrr8LjdkHd/6QQdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=du5VifOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="du5VifOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B421C116B1;
	Mon,  6 May 2024 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957099;
	bh=Uq512wrLiXCMm+WxPn3TMcCqLmY0pq0EVJdOPmyo/iA=;
	h=Date:To:From:Subject:From;
	b=du5VifOHwc/kEr+AUo+u25J2BtFt2u0i6H21ETzkSPgMhZfB8UW71rsQKX0rVs3M6
	 G58OUXQpW6ZUdgK7r2sMkphWqrOmEadIEiOnl4bisn/x/78/VRyf2Tx0zkYAXjYbPB
	 eTznNsDgsnd05bNJmXOcPPAcY+sDsaSEJdNJeDZA=
Date: Sun, 05 May 2024 17:58:19 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfault-expand-folio-use-in-mfill_atomic_install_pte.patch removed from -mm tree
Message-Id: <20240506005819.7B421C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfault; expand folio use in mfill_atomic_install_pte()
has been removed from the -mm tree.  Its filename was
     userfault-expand-folio-use-in-mfill_atomic_install_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: userfault; expand folio use in mfill_atomic_install_pte()
Date: Tue, 23 Apr 2024 23:55:36 +0100

Call page_folio() a little earlier so we can use folio_mapping()
instead of page_mapping(), saving a call to compound_head().

Link: https://lkml.kernel.org/r/20240423225552.4113447-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfault-expand-folio-use-in-mfill_atomic_install_pte
+++ a/mm/userfaultfd.c
@@ -180,9 +180,9 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	pte_t _dst_pte, *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
-	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
-	struct folio *folio;
+	struct folio *folio = page_folio(page);
+	bool page_in_cache = folio_mapping(folio);
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	_dst_pte = pte_mkdirty(_dst_pte);
@@ -212,7 +212,6 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	if (!pte_none_mostly(ptep_get(dst_pte)))
 		goto out_unlock;
 
-	folio = page_folio(page);
 	if (page_in_cache) {
 		/* Usually, cache pages are already added to LRU */
 		if (newly_allocated)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

