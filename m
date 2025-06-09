Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0850622D7B8
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749511957; cv=none; b=WCkZdqgIw9HShmdhkFZx8OevJBai7bvQQaJnUSS0SnYG6UF4CM2cGqH5sh6bbQ5fg7kZ0O96vFt6kPEoEbKqJsj5IqnhObhFetPqvJOurZru9Od2PSo57cHsCnAGZkM965bn5DD3I7uwFfmDOxxZyfLJwqHZsWNr6yBchWYjYKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749511957; c=relaxed/simple;
	bh=bENcN9dGS19ZcUSlr/Ukv0YB48B7M/ddznLfjPhYab8=;
	h=Date:To:From:Subject:Message-Id; b=YxICSe83Qgd+6S8jTgevMIGzJfW6bPtLe1NH2HBEEAzJuAN50hBL1hcXWwfEb6Bc16fuvgKcluRnM2JxIuebOTJN1v76rk2yaVyMb0sLSQOTuoxtwNoWTkG2oWkvtaizPSfVDczVnMu7kAo5cR2CAEKUTtaHvXOkiiLxY4/6r54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GG+Z/iXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GG+Z/iXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C030DC4CEEB;
	Mon,  9 Jun 2025 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749511956;
	bh=bENcN9dGS19ZcUSlr/Ukv0YB48B7M/ddznLfjPhYab8=;
	h=Date:To:From:Subject:From;
	b=GG+Z/iXkISmuQpOO/UjYwJeAgNnqGbP2Ip9B0cEnBsBnenY4t9QQJ3NS1dENZFEIF
	 drB+wjmPsiJG1eKbRy9R85SlxymAHXnEj6uezyHYAQPwk5djv2sHI00FtpZgOQdjT7
	 hM/VckB6uQ5Zcv6vug4oKAsQEDohiFa5QRyytj1I=
Date: Mon, 09 Jun 2025 16:32:36 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,david@redhat.com,chaitanyas.prakash@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-make-space-in-struct-file_ra_state.patch added to mm-new branch
Message-Id: <20250609233236.C030DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: make space in struct file_ra_state
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-make-space-in-struct-file_ra_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-make-space-in-struct-file_ra_state.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/readahead: make space in struct file_ra_state
Date: Mon, 9 Jun 2025 10:27:25 +0100

We need to be able to store the preferred folio order associated with a
readahead request in the struct file_ra_state so that we can more
accurately increase the order across subsequent readahead requests.  But
struct file_ra_state is per-struct file, so we don't really want to
increase it's size.

mmap_miss is currently 32 bits but it is only counted up to 10 *
MMAP_LOTSAMISS, which is currently defined as 1000.  So 16 bits should be
plenty.  Redefine it to unsigned short, making room for order as unsigned
short in follow up commit.

Link: https://lkml.kernel.org/r/20250609092729.274960-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 mm/filemap.c       |   11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/fs.h~mm-readahead-make-space-in-struct-file_ra_state
+++ a/include/linux/fs.h
@@ -1052,7 +1052,7 @@ struct file_ra_state {
 	unsigned int size;
 	unsigned int async_size;
 	unsigned int ra_pages;
-	unsigned int mmap_miss;
+	unsigned short mmap_miss;
 	loff_t prev_pos;
 };
 
--- a/mm/filemap.c~mm-readahead-make-space-in-struct-file_ra_state
+++ a/mm/filemap.c
@@ -3217,7 +3217,7 @@ static struct file *do_sync_mmap_readahe
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	unsigned long vm_flags = vmf->vma->vm_flags;
-	unsigned int mmap_miss;
+	unsigned short mmap_miss;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
@@ -3285,7 +3285,7 @@ static struct file *do_async_mmap_readah
 	struct file_ra_state *ra = &file->f_ra;
 	DEFINE_READAHEAD(ractl, file, ra, file->f_mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	unsigned int mmap_miss;
+	unsigned short mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
@@ -3605,7 +3605,7 @@ skip:
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned int *mmap_miss)
+			unsigned long *rss, unsigned short *mmap_miss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
@@ -3667,7 +3667,7 @@ skip:
 
 static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		struct folio *folio, unsigned long addr,
-		unsigned long *rss, unsigned int *mmap_miss)
+		unsigned long *rss, unsigned short *mmap_miss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = &folio->page;
@@ -3709,7 +3709,8 @@ vm_fault_t filemap_map_pages(struct vm_f
 	struct folio *folio;
 	vm_fault_t ret = 0;
 	unsigned long rss = 0;
-	unsigned int nr_pages = 0, mmap_miss = 0, mmap_miss_saved, folio_type;
+	unsigned int nr_pages = 0, folio_type;
+	unsigned short mmap_miss = 0, mmap_miss_saved;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch
mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

