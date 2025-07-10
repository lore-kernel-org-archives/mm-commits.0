Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B10A284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126255; cv=none; b=FnM6A3VSZS3OwGxYjESierdVrBjq6R1KA89k3B+nshIoREFJ4qbtMPkBRZiIH7MzIO1HE25tONy8GfoPkBNGJi9+9A1xb/i53beTs50Cx0GqX6XEpM2CHz1LBpkTiB3m2aRDiin0WspzXQ87EMZYf44ibWiW+Qa9ZVdHJ02412o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126255; c=relaxed/simple;
	bh=b3bOyZAiSgmLs4AA3ebmtbPlSaZ+VcxFCXHzEaV+AYQ=;
	h=Date:To:From:Subject:Message-Id; b=RXQdnxZ1j7dqnnGDN8iw7W0uLVRpFRqgC7bry8ZHAtkzMVYOpppRm0t87tePojJZ5hw/SrZ4ZZLyvC94YRR9vqT/7to9AsgNj4PRd9VyGTiLHj4q2KXK0PJmtHFCsjbnqULJjlLPyKIN+I0IlhwygZXfavoKg1jsqpOd8lgWbxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1Ke+A7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1Ke+A7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FEAC4CEE3;
	Thu, 10 Jul 2025 05:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126255;
	bh=b3bOyZAiSgmLs4AA3ebmtbPlSaZ+VcxFCXHzEaV+AYQ=;
	h=Date:To:From:Subject:From;
	b=x1Ke+A7S4PLVWeWWl/Fhb/7d0UaMFUPQJ0YY+wXwE9r1qfldVoXAxM8qKp9ZHCQpf
	 Jb9UU0DFGhX2lWIIT5IjNZ/Vrl+aGFckIjhqxNRUnkbO4pnWN5XNMRW8ZoJoJFnHIj
	 NVy2yB9IIO8ZRHd4HQcO5eTTDXHVjg7raXrNCDMY=
Date: Wed, 09 Jul 2025 22:44:14 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,david@redhat.com,chaitanyas.prakash@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-make-space-in-struct-file_ra_state.patch removed from -mm tree
Message-Id: <20250710054414.E8FEAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: make space in struct file_ra_state
has been removed from the -mm tree.  Its filename was
     mm-readahead-make-space-in-struct-file_ra_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1054,7 +1054,7 @@ struct file_ra_state {
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

mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

