Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB711B808
	for <mm-commits@vger.kernel.org>; Sun, 18 Oct 2026 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792282379; cv=none; b=b/QbeDpcGGfcO7BP05p7ekbKbdyA7aojrcaKPEMkBwB+QNBL4tJ70cLUA71FFpgPbgCa41ncAsu/bf3aVrnNVTle795FBr8T4Fk9ttacK4BZ/kAy5wDddEjNl1BTKv6q2wBw8VF4mWn8O3ctDYEw+lS+xK3XsSP6ZfdH39tA5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792282379; c=relaxed/simple;
	bh=lJrbzeA7T1yPU1Vy76AtgPeMSIIUKTf89n3Q4pDUb8c=;
	h=Date:To:From:Subject:Message-Id; b=A1DXo68ZizC3LOsfKcH9SuAJsUSurw/JATOn4R3vXE2iwrPO0KfJjs1GS9hVUOgdfqdfF6vk0slUHaQH54xVWaJxztWQX55xNDve75ps5TENpN3/rKy1ff97lPVmWXeSlVm2a3zRv855Cck1HUcM+mDx6CnxElyx/5/Ezzcd+0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d63eTvVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d63eTvVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B247E1F000C4;
	Sun, 18 Oct 2026 00:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792282377;
	bh=/xP+Ve0zIPG3qbDR2g+77EM8UhxrCZY7tVgdUaoXKVA=;
	h=Date:To:From:Subject;
	b=d63eTvVK/x3jga9asmwwrhJXOeai3e4ID0RNZHjjPOgc2BcurQBjqGvxbHPJ2PFYr
	 DFa7EFUeIt4B5IQE3M/lClXCFhKB8qDlTgsvI+IAu1ubDDAA9TDRRRz3c/OdCvd8o4
	 enBSumMXHEl1fjgn70OjxjA+ykb/O+kHvTZ+K73k=
Date: Sat, 17 Oct 2026 17:12:57 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,ljs@kernel.org,baoquan.he@linux.dev,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch added to mm-unstable branch
Message-Id: <20261018001257.B247E1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
Date: Sat, 17 Oct 2026 19:13:25 -0400

Reading a vm_map_ram() mapping through /proc/kcore returns the wrong
memory for every page except the first page of the first used region in
its vmap block.  read_kcore_iter() calls vread_iter() one page at a time,
so a root user reading a live system with drgn, crash or gdb gets that
first page in place of every later page of the mapping, and in place of
the zeroes of the unused pages after it.  This affects every vm_map_ram()
mapping that fits in a vmap block (up to BITS_PER_LONG pages): erofs and
f2fs decompression buffers, videobuf2 vmalloc/dma-sg buffers, udmabuf
vmaps, fuse readdir pages.  Kernels since v6.3 are affected.

vmap_ram_vread_iter() walks the used regions of the block and, for each
region, zero-fills up to its start and then copies from start +
offset_in_page(addr).  A read starting in a later page of a region
therefore copies the region's first page, and a read starting past the end
of a region still copies from that region.

Skip regions that end at or before addr, and copy from addr itself, i.e. 
use addr - start as the offset into the region.  The region is re - rs
pages long, not re - rs + 1: for_each_set_bitrange() returns [rs, re) with
re the first clear bit.  The extra page is one whose used_map bit is
clear, and vb_free() clears the bits before it unmaps the pages, so a read
racing with vm_unmap_ram() copied the page being freed instead of
zero-filling it.

Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(), page
i starting with "userptr page i", and reading every page of its vmap block
through /proc/kcore.  Before, all 1024 pages of the block read as page 0. 
After, pages 0..28 read back in order and the rest of the block carries no
tag.  With a second buffer in the same block and a 100-page buffer outside
the block path, reads at unaligned offsets, across page and region
boundaries, into and within the unused part of the block, and of the whole
block return the true contents.  With an msleep() inserted between the
bitmap_clear() and the vunmap_range_noflush() of vb_free(), a read of a
one-page buffer being unmapped between two mapped ones returns zeroes.

Link: https://lore.kernel.org/20261017231325.796986-1-nickolai@csail.mit.edu
Fixes: 06c8994626d1 ("mm/vmalloc.c: allow vread() to read out vm_map_ram areas")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 mm/vmalloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset
+++ a/mm/vmalloc.c
@@ -4649,7 +4649,7 @@ static size_t vmap_ram_vread_iter(struct
 	struct xarray *xa;
 	unsigned long offset;
 	unsigned int rs, re;
-	size_t remains, n;
+	size_t remains, n, size;
 
 	/*
 	 * If it's area created by vm_map_ram() interface directly, but
@@ -4683,6 +4683,10 @@ static size_t vmap_ram_vread_iter(struct
 			goto finished;
 
 		start = vmap_block_vaddr(vb->va->va_start, rs);
+		size = (re - rs) << PAGE_SHIFT;
+
+		if (addr >= start + size)
+			continue;
 
 		if (addr < start) {
 			size_t to_zero = min_t(size_t, start - addr, remains);
@@ -4696,8 +4700,8 @@ static size_t vmap_ram_vread_iter(struct
 		}
 
 		/*it could start reading from the middle of used region*/
-		offset = offset_in_page(addr);
-		n = ((re - rs + 1) << PAGE_SHIFT) - offset;
+		offset = addr - start;
+		n = size - offset;
 		if (n > remains)
 			n = remains;
 
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch
resource-report-a-devm_request_resource-conflict-under-the-lock.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch

