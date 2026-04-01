Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1844502A;
	Wed,  1 Apr 2026 00:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775003614; cv=none; b=Tw+qRzWyjWUVVuuZprHulEShQHCmbfM02t/DKv7SZTv0Jdy2Yo2A+jOFWzsPvkwVWXZsjaIpd2/vdnZNXRAfHgGtRfbgH21+D9OuUOw7tA7vPbRt4anXWmINJbOC+9yfqB+BpRoCCHZ4eo0atBt08U3uVlyGXO5tPsDPbPIVRBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775003614; c=relaxed/simple;
	bh=K8dquG2PUKKuN7O/6xf/xKWp4UuJ6R6RcFQ76uhDSyQ=;
	h=Date:To:From:Subject:Message-Id; b=t+c2hdlodEC7AkYx2xPcI5oYQIhWVWXQ+Wh4XHpzXnsV0Z5O65uEtXcgGF5+Td4RogtbaNgFxfwVVn5Sswlw38SRj2jyPYHQN0gBxVfBo8KUrLWCVEdapEgAwQOG0hlz2+3JenNJTPj1flSB6K5+AsVcHsNSIKMpfx7BVatD/fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bUDFWiZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bUDFWiZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A85EC19423;
	Wed,  1 Apr 2026 00:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775003614;
	bh=K8dquG2PUKKuN7O/6xf/xKWp4UuJ6R6RcFQ76uhDSyQ=;
	h=Date:To:From:Subject:From;
	b=bUDFWiZxzYP7Hbhfg4A7noMORjh5C8DYB86LhYfpGcKMMTsUkfpuzviRvE15h/7zV
	 ax6cCFHZXza/bOzhG5IU8m37eiXU5NEfKO/eHfcKpHwPNsKr0lKh+W1YZm4Jvwelu2
	 Lf6gbq4nrIjbMNrCyHDCwXP9oWxbf9yEzp+oOiKs=
Date: Tue, 31 Mar 2026 17:33:33 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,surenb@google.com,kernel.org,stable@vger,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch added to mm-new branch
Message-Id: <20260401003334.2A85EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_hmm: evict device pages on file close to avoid use-after-free
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: lib: test_hmm: evict device pages on file close to avoid use-after-free
Date: Tue, 31 Mar 2026 17:34:43 +1100

Patch series "Minor hmm_test fixes and cleanups".

Two bugfixes a cleanup for the HMM kernel selftests.  These were mostly
reported by Zenghui Yu with special thanks to Lorenzo for analysing and
pointing out the problems.


This patch (of 3):

When dmirror_fops_release() is called it frees the dmirror struct but
doesn't migrate device private pages back to system memory first.  This
leaves those pages with a dangling zone_device_data pointer to the freed
dmirror.

If a subsequent fault occurs on those pages (eg.  during coredump) the
dmirror_devmem_fault() callback dereferences the stale pointer causing a
kernel panic.  This was reported [1] when running mm/ksft_hmm.sh on arm64,
where a test failure triggered SIGABRT and the resulting coredump walked
the VMAs faulting in the stale device private pages.

Fix this by calling dmirror_device_evict_chunk() for each devmem chunk in
dmirror_fops_release() to migrate all device private pages back to system
memory before freeing the dmirror struct.  The function is moved earlier
in the file to avoid a forward declaration.

Link: https://lkml.kernel.org/r/20260331063445.3551404-1-apopple@nvidia.com
Link: https://lkml.kernel.org/r/20260331063445.3551404-2-apopple@nvidia.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger,kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |  112 ++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 50 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free
+++ a/lib/test_hmm.c
@@ -185,11 +185,73 @@ static int dmirror_fops_open(struct inod
 	return 0;
 }
 
+static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
+{
+	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
+	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
+	unsigned long npages = end_pfn - start_pfn + 1;
+	unsigned long i;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
+	unsigned int order = 0;
+
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
+	migrate_device_range(src_pfns, start_pfn, npages);
+	for (i = 0; i < npages; i++) {
+		struct page *dpage, *spage;
+
+		spage = migrate_pfn_to_page(src_pfns[i]);
+		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		if (WARN_ON(!is_device_private_page(spage) &&
+			    !is_device_coherent_page(spage)))
+			continue;
+
+		order = folio_order(page_folio(spage));
+		spage = BACKING_PAGE(spage);
+		if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
+			dpage = folio_page(folio_alloc(GFP_HIGHUSER_MOVABLE,
+					      order), 0);
+		} else {
+			dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+			order = 0;
+		}
+
+		/* TODO Support splitting here */
+		lock_page(dpage);
+		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		if (src_pfns[i] & MIGRATE_PFN_WRITE)
+			dst_pfns[i] |= MIGRATE_PFN_WRITE;
+		if (order)
+			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
+		folio_copy(page_folio(dpage), page_folio(spage));
+	}
+	migrate_device_pages(src_pfns, dst_pfns, npages);
+	migrate_device_finalize(src_pfns, dst_pfns, npages);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
+}
+
 static int dmirror_fops_release(struct inode *inode, struct file *filp)
 {
 	struct dmirror *dmirror = filp->private_data;
+	struct dmirror_device *mdevice = dmirror->mdevice;
+	int i;
 
 	mmu_interval_notifier_remove(&dmirror->notifier);
+
+	if (mdevice->devmem_chunks) {
+		for (i = 0; i < mdevice->devmem_count; i++) {
+			struct dmirror_chunk *devmem =
+				mdevice->devmem_chunks[i];
+
+			dmirror_device_evict_chunk(devmem);
+		}
+	}
+
 	xa_destroy(&dmirror->pt);
 	kfree(dmirror);
 	return 0;
@@ -1377,56 +1439,6 @@ static int dmirror_snapshot(struct dmirr
 	return ret;
 }
 
-static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
-{
-	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
-	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
-	unsigned long npages = end_pfn - start_pfn + 1;
-	unsigned long i;
-	unsigned long *src_pfns;
-	unsigned long *dst_pfns;
-	unsigned int order = 0;
-
-	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
-	migrate_device_range(src_pfns, start_pfn, npages);
-	for (i = 0; i < npages; i++) {
-		struct page *dpage, *spage;
-
-		spage = migrate_pfn_to_page(src_pfns[i]);
-		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-			continue;
-
-		if (WARN_ON(!is_device_private_page(spage) &&
-			    !is_device_coherent_page(spage)))
-			continue;
-
-		order = folio_order(page_folio(spage));
-		spage = BACKING_PAGE(spage);
-		if (src_pfns[i] & MIGRATE_PFN_COMPOUND) {
-			dpage = folio_page(folio_alloc(GFP_HIGHUSER_MOVABLE,
-					      order), 0);
-		} else {
-			dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
-			order = 0;
-		}
-
-		/* TODO Support splitting here */
-		lock_page(dpage);
-		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
-		if (src_pfns[i] & MIGRATE_PFN_WRITE)
-			dst_pfns[i] |= MIGRATE_PFN_WRITE;
-		if (order)
-			dst_pfns[i] |= MIGRATE_PFN_COMPOUND;
-		folio_copy(page_folio(dpage), page_folio(spage));
-	}
-	migrate_device_pages(src_pfns, dst_pfns, npages);
-	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kvfree(src_pfns);
-	kvfree(dst_pfns);
-}
-
 /* Removes free pages from the free list so they can't be re-allocated */
 static void dmirror_remove_free_pages(struct dmirror_chunk *devmem)
 {
_

Patches currently in -mm which might be from apopple@nvidia.com are

lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch
selftests-mm-hmm-tests-dont-hardcode-thp-size-to-2mb.patch
lib-test_hmm-implement-a-device-release-method.patch

