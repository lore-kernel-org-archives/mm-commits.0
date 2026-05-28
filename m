Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B531EA65
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000083; cv=none; b=ot0EG+WhgRChOTNG/4rgbuhUK228vnzFdqQWaaaUp90yIaSOrimY/T8m7IMH2nLxe8FkMtumOlyfKWFvclhaTCz70AMPrzTME205G/vI5LFyK96CMblLL7QGpoNa+5wnrPQrHKJJlSE8FtRRzkFBMjzQu0RqfGAHCndD+gX22Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000083; c=relaxed/simple;
	bh=I1zoc8Z1xuQjoNre8mRcSW6RlKQd6WM+pxgxrTAz22o=;
	h=Date:To:From:Subject:Message-Id; b=XgIsNymjOTz8zs1znfwvY9XkbgsSiiMVEHHGUw4vNBmCbjijC737/xk/8yVFcyoqIHi2N/S+K32ZiRmu7z5OWAOJZFElrcP6U9JYK85PZAjWyNPzYM2UNGTK1CMtnEnykihyjrIj/b6DvUIbg4OAM93GIYvDsr39wQwo2URxggw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZbSccAmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZbSccAmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6221D1F000E9;
	Thu, 28 May 2026 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780000081;
	bh=MdkDMt5nHU6ILAETo69QmiWWZiedgizV0AZbmEYsWP4=;
	h=Date:To:From:Subject;
	b=ZbSccAmGmMzRevbWEfxgV+jG0g59Sh2AmX6nlnW+ehjUGFyHiNOoy4CMhTk6fvxzM
	 aevJoZJaKDYg2cX4XV+M9+I9FkWI8vrJb4pZFFPwR9DKsUsC+SJUUdB2+wNbTUbVBG
	 2NXgJLRHa+GXHYrDzv2vsg+wE9ton9SPkqpoWLC0=
Date: Thu, 28 May 2026 13:28:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pasha.tatashin@soleen.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch added to mm-new branch
Message-Id: <20260528202801.6221D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: bypass mmap_miss heuristic for VM_EXEC readahead
has been added to the -mm mm-new branch.  Its filename is
     mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Thu, 28 May 2026 09:55:19 -0700

Patch series "mm: improve large folio readahead for exec memory", v6.

Two checks in do_sync_mmap_readahead() limit large-folio readahead:

  1. The mmap_miss heuristic is meant to throttle wasteful speculative
     readahead. It is currently also applied to the VM_EXEC readahead
     path, which is targeted rather than speculative. Once mmap_miss exceeds
     MMAP_LOTSAMISS, exec readahead - including the large-folio
     order requested by exec_folio_order() - is disabled. On
     configurations where the mmap_miss decrement paths are not
     active (see patch 1) the counter only grows, so exec readahead
     is permanently disabled after the first 100 faults.

  2. The force_thp_readahead path is gated only on
     HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
     readahead at HPAGE_PMD_ORDER. Configurations where
     HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
     path, even when the mapping itself supports usefully large
     folios well below the cap.

Both issues are most visible on arm64 with a 64K base page size, where
HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER (11) -- and
where fault_around_pages collapses to 1 disabling should_fault_around()
(one of the two mmap_miss decrement sites).  However the fixes are
architecture-agnostic: patch 1 reflects the nature of VM_EXEC readahead
regardless of base page size, and patch 2 generalises the gate so any
mapping advertising a usefully large maximum folio order can benefit.

I created a benchmark that mmaps a large executable file madvises it as
huge and calls RET-stub functions at PAGE_SIZE offsets across it.  "Cold"
measures fault + readahead cost.  "Random" first faults in all pages with
a sequential sweep (not measured), then measures time for calling random
offsets, isolating iTLB miss cost for scattered execution.

The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
512MB executable file on ext4, averaged over 3 runs:

  Phase      | Baseline     | Patched      | Improvement
  -----------|--------------|--------------|------------------
  Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
  Random     | 76.0 ms      | 58.3 ms      | 23% faster


This patch (of 2):

The mmap_miss heuristic is intended to stop speculative mmap readahead
when a file looks like a random-access workload.  That does not fit the
VM_EXEC path very well.

VM_EXEC readahead is already constrained differently from ordinary mmap
read-around: it is bounded by the VMA, uses exec_folio_order() to choose
an order useful for executable mappings, and sets async_size to 0 so it
does not create follow-on readahead.  When VM_HUGEPAGE is also present,
the larger readahead is an explicit userspace opt-in.

The mmap_miss counter is decremented from cache-hit paths in
do_async_mmap_readahead() and filemap_map_pages().  Those paths are not
always enough to balance the synchronous miss increments for executable
mappings.  In particular, when fault-around is effectively disabled, such
as configurations where fault_around_pages is 1, filemap_map_pages() is
not reached from the fault path.  The counter can then become a stale
throttle for VM_EXEC mappings and suppress the readahead behavior that the
executable-specific path is trying to provide.

Skip both mmap_miss increments and decrements for VM_EXEC mappings,
matching the existing VM_SEQ_READ treatment and keeping the counter
accounting symmetric.

Link: https://lore.kernel.org/20260528165635.2068012-1-usama.arif@linux.dev
Link: https://lore.kernel.org/20260528165635.2068012-2-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Heiher <r@hev.cc>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead
+++ a/mm/filemap.c
@@ -3339,7 +3339,7 @@ static struct file *do_sync_mmap_readahe
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3434,12 +3434,12 @@ static struct file *do_async_mmap_readah
 	 * times for a single folio and break the balance with mmap_miss
 	 * increase in do_sync_mmap_readahead().
 	 *
-	 * VM_SEQ_READ mappings skip the mmap_miss increment in
+	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
 	 * do_sync_mmap_readahead(), so skip the decrement here as well to
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
+	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3941,14 +3941,14 @@ vm_fault_t filemap_map_pages(struct vm_f
 		 * Don't decrease mmap_miss in this scenario to make sure
 		 * we can stop read-ahead.
 		 *
-		 * VM_SEQ_READ mappings skip the mmap_miss increment in
-		 * do_sync_mmap_readahead(), so skip the decrement here as
-		 * well to keep the counter symmetric.
+		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
+		 * increment in do_sync_mmap_readahead(), so skip the
+		 * decrement here as well to keep the counter symmetric.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & VM_SEQ_READ)) {
+		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

