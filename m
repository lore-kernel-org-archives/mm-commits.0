Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793369818;
	b=46IbvWyIXgeSeK64WgzMQLrcmlqbB5vnSXjYikMl1EWLvKBZ0uOpfPzrCj5RfOo5nxVE
	 k7MxsPhBs38mTfzahK+LmQb9RkuFBV4R2Jf3pNCsXZV8isy4nfr4hEYFjjdUQ2svW91LO
	 vQbCEZB0vL9O+hQsh31BERYFA0PXie3MtlF1nHAU4XAHLeaeYTdHj21gobP2ROKFqiTle
	 SYtbVcGAcMmo6utaNQ1bNbwe5fNIjGXWFU6cOzQEJBsD6T93HA1qdcsJFPnlupJEjqlu5
	 giMRBmO6Ph7TOO/Xl7P7L+BTmx+q3RjTehBP6rwN5QcrmqP5KyfBqqExoZlecbdrWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793369818;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Oy1FZzGd5baPBNd1XD7o2U0rXnZgkLKngxQCfMt0msI=;
	b=NeezUf8YadTWwSuNNzlYmJiUHvlsRXQzpB5d8AeroMJqxwc3WN+QXTZdqQQBHes2z2s4
	 koOco/puDiPrGznikiGDw50M60oIoj5yXKS+Y7extsElOTmXngUMpSxDfVxdZ9uM5Zz2V
	 z3+m0q33tXHc+oKRdGYAMR3/HgRr2Hw637ShOoWv/uk9XPmYgA+GJtZ8nOGzPSIOJQSNi
	 YpdpX+VNSTSSzmcnfAaLxu7Hin6I1yL70I/s9iCqN99S3kNwoLpM8Dvfb4zYGuWAWFFpN
	 unjXXkCK/2PuQ2uzQqKMRp+3VkwiFQ7lHl5COZHMFrCXzdQ0RZEb9CnBMQBGaSpaxzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cpkxiOav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54EF606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cpkxiOav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4503C1F000C1;
	Fri, 30 Oct 2026 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793369817;
	bh=Oy1FZzGd5baPBNd1XD7o2U0rXnZgkLKngxQCfMt0msI=;
	h=Date:To:From:Subject;
	b=cpkxiOavXaWO1Q0gBOGw3VaOh5HdJigGB5Be3NHBmrVzmq9cH6IStwdbDWPVVneUy
	 T9LsFn6TNBiRqJDnKgSADlN/CU7CboYbnqoZbiE74XSgA902tuMQp1OGc6UDMyaChs
	 1JaPUZwbUCkZm2FaOATV4bzLHSS/BOerMHb3WCxY=
Date: Fri, 30 Oct 2026 07:16:56 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,shivankg@amd.com,
	ljs@kernel.org,baoquan.he@linux.dev,nickolai@csail.mit.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch removed from -mm tree
Message-Id: <20261030141657.4503C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

This patch was dropped because an updated version will be issued

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
Cc: "Garg, Shivank" <shivankg@amd.com>
---

 mm/vmalloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset
+++ a/mm/vmalloc.c
@@ -4655,7 +4655,7 @@ static size_t vmap_ram_vread_iter(struct
 	struct xarray *xa;
 	unsigned long offset;
 	unsigned int rs, re;
-	size_t remains, n;
+	size_t remains, n, size;
 
 	/*
 	 * If it's area created by vm_map_ram() interface directly, but
@@ -4689,6 +4689,10 @@ static size_t vmap_ram_vread_iter(struct
 			goto finished;
 
 		start = vmap_block_vaddr(vb->va->va_start, rs);
+		size = (re - rs) << PAGE_SHIFT;
+
+		if (addr >= start + size)
+			continue;
 
 		if (addr < start) {
 			size_t to_zero = min_t(size_t, start - addr, remains);
@@ -4702,8 +4706,8 @@ static size_t vmap_ram_vread_iter(struct
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

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
panic-zero-the-dynamically-allocated-taint-buffer.patch

