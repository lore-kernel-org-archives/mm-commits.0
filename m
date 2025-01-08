Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36EE199FB2
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307349; cv=none; b=Up7XhE33nH21vW77fm3IZGBnztqqplmK84o44wEQl8NySdmJ0HWm170o+fZS7nQL0qR7KK7A1SQWAS8NSsinIWrspG9qiuq+oQMV2zs2Tva/dbPl/9L4Z+Y4dv4jBLiHbPiF0xDFlPui9UnXHFULZ/Y9xBl1LEUIIPtJpq+nFGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307349; c=relaxed/simple;
	bh=ebNJrbboIOJr5SE3GG4BSyfkmfsusXbu0Ro8AR/L88Q=;
	h=Date:To:From:Subject:Message-Id; b=DBye5onZcPY48va+4jXZ1wNxsBT1aWvWi6KKEUZVqZMGMs5/Ms6Fznuqa8B6n1VqkOYnCbBsT+Z3zUfPnezLWioaNBDoNRRnjocISuj4BzKAhFE65wdigxTBUm4AyK5cSWGY6xUbRDmTagtxAB1aghG0DpCSumuYY7LbVyDWZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0aYFQLpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0aYFQLpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797ECC4CED0;
	Wed,  8 Jan 2025 03:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307349;
	bh=ebNJrbboIOJr5SE3GG4BSyfkmfsusXbu0Ro8AR/L88Q=;
	h=Date:To:From:Subject:From;
	b=0aYFQLpT9zAA1Sd8sqzVfXy1spuGzmYu0CnKPtrPTjm+KSUq7sOUPqEtaeODUtyLb
	 sMSa9qR9gv/xTlrgJ9JoL2xX9ORAIMcypxRbjdq8tug2gDI1ywBaL00NNwE5Ca+ux/
	 z+DwnFC01JNns0CZuKeHBTT2RzLKS2cNeVnAdnV0=
Date: Tue, 07 Jan 2025 19:35:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch added to mm-unstable branch
Message-Id: <20250108033549.797ECC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: change filemap_create_folio() to take a struct kiocb
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/filemap: change filemap_create_folio() to take a struct kiocb
Date: Fri, 20 Dec 2024 08:47:39 -0700

Patch series "Uncached buffered IO", v8.

5 years ago I posted patches adding support for RWF_UNCACHED, as a way to
do buffered IO that isn't page cache persistent.  The approach back then
was to have private pages for IO, and then get rid of them once IO was
done.  But that then runs into all the issues that O_DIRECT has, in terms
of synchronizing with the page cache.

So here's a new approach to the same concent, but using the page cache as
synchronization.  Due to excessive bike shedding on the naming, this is
now named RWF_DONTCACHE, and is less special in that it's just page cache
IO, except it prunes the ranges once IO is completed.

Why do this, you may ask?  The tldr is that device speeds are only getting
faster, while reclaim is not.  Doing normal buffered IO can be very
unpredictable, and suck up a lot of resources on the reclaim side.  This
leads people to use O_DIRECT as a work-around, which has its own set of
restrictions in terms of size, offset, and length of IO.  It's also
inherently synchronous, and now you need async IO as well.  While the
latter isn't necessarily a big problem as we have good options available
there, it also should not be a requirement when all you want to do is read
or write some data without caching.

Even on desktop type systems, a normal NVMe device can fill the entire
page cache in seconds.  On the big system I used for testing, there's a
lot more RAM, but also a lot more devices.  As can be seen in some of the
results in the following patches, you can still fill RAM in seconds even
when there's 1TB of it.  Hence this problem isn't solely a "big
hyperscaler system" issue, it's common across the board.

Common for both reads and writes with RWF_DONTCACHE is that they use the
page cache for IO.  Reads work just like a normal buffered read would,
with the only exception being that the touched ranges will get pruned
after data has been copied.  For writes, the ranges will get writeback
kicked off before the syscall returns, and then writeback completion will
prune the range.  Hence writes aren't synchronous, and it's easy to
pipeline writes using RWF_DONTCACHE.  Folios that aren't instantiated by
RWF_DONTCACHE IO are left untouched.  This means you that uncached IO will
take advantage of the page cache for uptodate data, but not leave anything
it instantiated/created in cache.

File systems need to support this.  This patchset adds support for the
generic read path, which covers file systems like ext4.  Patches exist to
add support for iomap/XFS and btrfs as well, which sit on top of this
series.  If RWF_DONTCACHE IO is attempted on a file system that doesn't
support it, -EOPNOTSUPP is returned.  Hence the user can rely on it either
working as designed, or flagging and error if that's not the case.  The
intent here is to give the application a sensible fallback path - eg, it
may fall back to O_DIRECT if appropriate, or just live with the fact that
uncached IO isn't available and do normal buffered IO.

Adding "support" to other file systems should be trivial, most of the time
just a one-liner adding FOP_DONTCACHE to the fop_flags in the
file_operations struct, if the file system is using either iomap or the
generic filemap helpers for reading and writing.

Performance results are in patch 8 for reads, and you can find the write
side results in the XFS patch adding support for DONTCACHE writes for XFS:

https://git.kernel.dk/cgit/linux/commit/?h=buffered-uncached-fs.10&id=257e92de795fdff7d7e256501e024fac6da6a7f4

with the tldr being that I see about a 65% improvement in performance for
both, with fully predictable IO times.  CPU reduction is substantial as
well, with no kswapd activity at all for reclaim when using uncached IO.

Using it from applications is trivial - just set RWF_DONTCACHE for the
read or write, using pwritev2(2) or preadv2(2).  For io_uring, same thing,
just set RWF_DONTCACHE in sqe->rw_flags for a buffered read/write
operation.  And that's it.

Patches 1..7 are just prep patches, and should have no functional changes
at all.  Patch 8 adds support for the filemap path for RWF_DONTCACHE
reads, and patches 9..12 are just prep patches for supporting the write
side of uncached writes.  In the below mentioned branch, there are then
patches to adopt uncached reads and writes for xfs, btrfs, and ext4.  The
latter currently relies on bit of a hack for passing whether this is an
uncached write or not through ->write_begin(), which can hopefully go away
once ext4 adopts iomap for buffered writes.  I say this is a hack as it's
not the prettiest way to do it, however it is fully solid and will work
just fine.

Passes full xfstests and fsx overnight runs, no issues observed.  That
includes the vm running the testing also using RWF_DONTCACHE on the host. 
I'll post fsstress and fsx patches for RWF_DONTCACHE separately.  As far
as I'm concerned, no further work needs doing here.

And git tree for the patches is here:

https://git.kernel.dk/cgit/linux/log/?h=buffered-uncached.10

with the file system patches on top adding support for xfs/btrfs/ext4
here:

https://git.kernel.dk/cgit/linux/log/?h=buffered-uncached-fs.10


This patch (of 12):

Rather than pass in both the file and position directly from the kiocb,
just take a struct kiocb instead.  With the kiocb being passed in, skip
passing in the address_space separately as well.  While doing so, move the
ki_flags checking into filemap_create_folio() as well.  In preparation for
actually needing the kiocb in the function.

No functional changes in this patch.

Link: https://lkml.kernel.org/r/20241220154831.1086649-1-axboe@kernel.dk
Link: https://lkml.kernel.org/r/20241220154831.1086649-2-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/filemap.c~mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb
+++ a/mm/filemap.c
@@ -2431,15 +2431,17 @@ unlock_mapping:
 	return error;
 }
 
-static int filemap_create_folio(struct file *file,
-		struct address_space *mapping, loff_t pos,
-		struct folio_batch *fbatch)
+static int filemap_create_folio(struct kiocb *iocb, struct folio_batch *fbatch)
 {
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct folio *folio;
 	int error;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t index;
 
+	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
+		return -EAGAIN;
+
 	folio = filemap_alloc_folio(mapping_gfp_mask(mapping), min_order);
 	if (!folio)
 		return -ENOMEM;
@@ -2458,7 +2460,7 @@ static int filemap_create_folio(struct f
 	 * well to keep locking rules simple.
 	 */
 	filemap_invalidate_lock_shared(mapping);
-	index = (pos >> (PAGE_SHIFT + min_order)) << min_order;
+	index = (iocb->ki_pos >> (PAGE_SHIFT + min_order)) << min_order;
 	error = filemap_add_folio(mapping, folio, index,
 			mapping_gfp_constraint(mapping, GFP_KERNEL));
 	if (error == -EEXIST)
@@ -2466,7 +2468,8 @@ static int filemap_create_folio(struct f
 	if (error)
 		goto error;
 
-	error = filemap_read_folio(file, mapping->a_ops->read_folio, folio);
+	error = filemap_read_folio(iocb->ki_filp, mapping->a_ops->read_folio,
+					folio);
 	if (error)
 		goto error;
 
@@ -2522,9 +2525,7 @@ retry:
 		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	}
 	if (!folio_batch_count(fbatch)) {
-		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
-			return -EAGAIN;
-		err = filemap_create_folio(filp, mapping, iocb->ki_pos, fbatch);
+		err = filemap_create_folio(iocb, fbatch);
 		if (err == AOP_TRUNCATED_PAGE)
 			goto retry;
 		return err;
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch

