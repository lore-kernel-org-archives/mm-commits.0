Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A83B1D63E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343096; cv=none; b=Wr2wRTIb7pnv5NHMRsRkVJWg8oedQ98P9JwVXmedzuptE9ZNkCbV+w5OuK7LLJis+Or8XI5gK3GfvONEzKEeEBs9x+Nc8VzEkRAHM1t5yTxPpfFyTQAlIL0QHtxSqtLExVdqfPmBTyvJ25QWR1fXB0TObLtkrigENdHlEx7jRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343096; c=relaxed/simple;
	bh=D/Upeda60Rp3+VI0vnWG9nv48ZUx+98oaydZDgllLXQ=;
	h=Date:To:From:Subject:Message-Id; b=uU+9Ujo8OSkW+Sl337yTBvRsFtc+2uZInIMIbEvnovYVng4luboPiid6S5of23Q7U8s7PQZNS6pYIKmM7zG0aLd4SyKb0XTOWcfemPxmOWNcLd6jOrtExuog7AuYx2dURgBFnTTd1IxGQmMfHDI4oQlGlwBhj2b855O767ch9ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r4X9fZ8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r4X9fZ8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56A2C19425;
	Mon, 17 Nov 2025 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343095;
	bh=D/Upeda60Rp3+VI0vnWG9nv48ZUx+98oaydZDgllLXQ=;
	h=Date:To:From:Subject:From;
	b=r4X9fZ8UwEgR93k8H9DGn2a/NCRairnnkCjW+wBNBxMwbF2xX7XQHLkX3mqlo6wwB
	 IJkHUivgpE2HjoUIV+Jiu+pIc3gfUUDOjDaWjkJJ2A6qfkVBohySve+pnBqSG0QH51
	 cd1tDVNs41kUr+hkVeJX2/yJScWoR8NG970eOj0M=
Date: Sun, 16 Nov 2025 17:31:35 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dev.jain@arm.com,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-make-thp-readahead-conditional-to-mmap_miss-logic.patch removed from -mm tree
Message-Id: <20251117013135.D56A2C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: readahead: make thp readahead conditional to mmap_miss logic
has been removed from the -mm tree.  Its filename was
     mm-readahead-make-thp-readahead-conditional-to-mmap_miss-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: readahead: make thp readahead conditional to mmap_miss logic
Date: Mon, 6 Oct 2025 10:51:06 -0700

Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
introduced a special handling for VM_HUGEPAGE mappings: even if the
readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are allocated.

This change causes a significant regression for containers with a tight
memory.max limit, if VM_HUGEPAGE is widely used.  Prior to this commit,
mmap_miss logic would eventually lead to the readahead disablement,
effectively reducing the memory pressure in the cgroup.  With this change
the kernel is trying to allocate 1-2 huge pages for each fault, no matter
if these pages are used or not before being evicted, increasing the memory
pressure multi-fold.

To fix the regression, let's make the new VM_HUGEPAGE conditional to the
mmap_miss check, but keep independent from the ra->ra_pages.  This way the
main intention of commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE
for file mappings") stays intact, but the regression is resolved.

The logic behind this changes is simple: even if a user explicitly
requests using huge pages to back the file mapping (using VM_HUGEPAGE
flag), under a very strong memory pressure it's better to fall back to
ordinary pages.

Link: https://lkml.kernel.org/r/20251006175106.377411-1-roman.gushchin@linux.dev
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   68 +++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/filemap.c~mm-readahead-make-thp-readahead-conditional-to-mmap_miss-logic
+++ a/mm/filemap.c
@@ -3253,11 +3253,47 @@ static struct file *do_sync_mmap_readahe
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+		force_thp_readahead = true;
+
+	if (!force_thp_readahead) {
+		/*
+		 * If we don't want any read-ahead, don't bother.
+		 * VM_EXEC case below is already intended for random access.
+		 */
+		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
+			return fpin;
+
+		if (!ra->ra_pages)
+			return fpin;
+
+		if (vm_flags & VM_SEQ_READ) {
+			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+			page_cache_sync_ra(&ractl, ra->ra_pages);
+			return fpin;
+		}
+	}
+
+	if (!(vm_flags & VM_SEQ_READ)) {
+		/* Avoid banging the cache line if not needed */
+		mmap_miss = READ_ONCE(ra->mmap_miss);
+		if (mmap_miss < MMAP_LOTSAMISS * 10)
+			WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
+
+		/*
+		 * Do we miss much more than hit in this file? If so,
+		 * stop bothering with read-ahead. It will only hurt.
+		 */
+		if (mmap_miss > MMAP_LOTSAMISS)
+			return fpin;
+	}
+
+	if (force_thp_readahead) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
 		ra->size = HPAGE_PMD_NR;
@@ -3272,34 +3308,6 @@ static struct file *do_sync_mmap_readahe
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
-#endif
-
-	/*
-	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
-	 * already intended for random access.
-	 */
-	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
-		return fpin;
-	if (!ra->ra_pages)
-		return fpin;
-
-	if (vm_flags & VM_SEQ_READ) {
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		page_cache_sync_ra(&ractl, ra->ra_pages);
-		return fpin;
-	}
-
-	/* Avoid banging the cache line if not needed */
-	mmap_miss = READ_ONCE(ra->mmap_miss);
-	if (mmap_miss < MMAP_LOTSAMISS * 10)
-		WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
-
-	/*
-	 * Do we miss much more than hit in this file? If so,
-	 * stop bothering with read-ahead. It will only hurt.
-	 */
-	if (mmap_miss > MMAP_LOTSAMISS)
-		return fpin;
 
 	if (vm_flags & VM_EXEC) {
 		/*
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


