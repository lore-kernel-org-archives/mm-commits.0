Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB79B12B7D;
	Thu, 25 Apr 2024 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012525; cv=none; b=o5cOFavf1ucsZL18GESxjPl37J4gHR8kbCdtEqfBEbHIS1TBE6I+NI2QA3L1n1AewDWDX3cY/jnuLyd+2MezZlfJOfNy0w857p/TxXPNe2hOrI55hq1c/qOodJLu7dAPkfw4j9u/0bjA3nZoQX3IXy44AnkJUWL3lTKJHVJEpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012525; c=relaxed/simple;
	bh=8dop1Ls++lkj8OZa5MzLQQbmt75kFLlH96YMShH/rR0=;
	h=Date:To:From:Subject:Message-Id; b=tmdzIuyPzvfIkd2cUxDuRVEgFGvC8drYF4rqyYIpS4ujgOo353oyrfbS3zfvm/DQEFsXbO5UHD8bbpEOxE5DDutp7z25PX9bcDeVsVPSBdlq0YifHf/YZqOkyOBuVLVzkGlZyIsZTNpu7TyGUXe07zinhWPf0m+o4c2MEITXtQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWUuWeRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWUuWeRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C4DC2BD10;
	Thu, 25 Apr 2024 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012524;
	bh=8dop1Ls++lkj8OZa5MzLQQbmt75kFLlH96YMShH/rR0=;
	h=Date:To:From:Subject:From;
	b=NWUuWeRUehgRcVsDJwcN6FaQwI1Acm0KBs0ucpmXTUZoEQ8djyzf+G7SELY0Inge9
	 nAVzRMguIFU0hPlLCajsIzDw4yEJX9wobzIuKWDjeAS8CUnJ43BNkrK6caYqeVw40f
	 Waro8fCcooaxurCvlqPiWZr5sFv+5LSDfPbyuCOY=
Date: Wed, 24 Apr 2024 19:35:23 -0700
To: mm-commits@vger.kernel.org,xiubli@redhat.com,stable@vger.kernel.org,hch@infradead.org,glider@google.com,david@fromorbit.com,damien.lemoal@opensource.wdc.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] stackdepot-respect-__gfp_nolockdep-allocation-flag.patch removed from -mm tree
Message-Id: <20240425023524.70C4DC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: respect __GFP_NOLOCKDEP allocation flag
has been removed from the -mm tree.  Its filename was
     stackdepot-respect-__gfp_nolockdep-allocation-flag.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: stackdepot: respect __GFP_NOLOCKDEP allocation flag
Date: Thu, 18 Apr 2024 16:11:33 +0200

If stack_depot_save_flags() allocates memory it always drops
__GFP_NOLOCKDEP flag.  So when KASAN tries to track __GFP_NOLOCKDEP
allocation we may end up with lockdep splat like bellow:

======================================================
 WARNING: possible circular locking dependency detected
 6.9.0-rc3+ #49 Not tainted
 ------------------------------------------------------
 kswapd0/149 is trying to acquire lock:
 ffff88811346a920
(&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reclaim_inode+0x3ac/0x590
[xfs]

 but task is already holding lock:
 ffffffff8bb33100 (fs_reclaim){+.+.}-{0:0}, at:
balance_pgdat+0x5d9/0xad0

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:
 -> #1 (fs_reclaim){+.+.}-{0:0}:
        __lock_acquire+0x7da/0x1030
        lock_acquire+0x15d/0x400
        fs_reclaim_acquire+0xb5/0x100
 prepare_alloc_pages.constprop.0+0xc5/0x230
        __alloc_pages+0x12a/0x3f0
        alloc_pages_mpol+0x175/0x340
        stack_depot_save_flags+0x4c5/0x510
        kasan_save_stack+0x30/0x40
        kasan_save_track+0x10/0x30
        __kasan_slab_alloc+0x83/0x90
        kmem_cache_alloc+0x15e/0x4a0
        __alloc_object+0x35/0x370
        __create_object+0x22/0x90
 __kmalloc_node_track_caller+0x477/0x5b0
        krealloc+0x5f/0x110
        xfs_iext_insert_raw+0x4b2/0x6e0 [xfs]
        xfs_iext_insert+0x2e/0x130 [xfs]
        xfs_iread_bmbt_block+0x1a9/0x4d0 [xfs]
        xfs_btree_visit_block+0xfb/0x290 [xfs]
        xfs_btree_visit_blocks+0x215/0x2c0 [xfs]
        xfs_iread_extents+0x1a2/0x2e0 [xfs]
 xfs_buffered_write_iomap_begin+0x376/0x10a0 [xfs]
        iomap_iter+0x1d1/0x2d0
 iomap_file_buffered_write+0x120/0x1a0
        xfs_file_buffered_write+0x128/0x4b0 [xfs]
        vfs_write+0x675/0x890
        ksys_write+0xc3/0x160
        do_syscall_64+0x94/0x170
 entry_SYSCALL_64_after_hwframe+0x71/0x79

Always preserve __GFP_NOLOCKDEP to fix this.

Link: https://lkml.kernel.org/r/20240418141133.22950-1-ryabinin.a.a@gmail.com
Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reported-by: Xiubo Li <xiubli@redhat.com>
Closes: https://lore.kernel.org/all/a0caa289-ca02-48eb-9bf2-d86fd47b71f4@redhat.com/
Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Closes: https://lore.kernel.org/all/f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com/
Suggested-by: Dave Chinner <david@fromorbit.com>
Tested-by: Xiubo Li <xiubli@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~stackdepot-respect-__gfp_nolockdep-allocation-flag
+++ a/lib/stackdepot.c
@@ -627,10 +627,10 @@ depot_stack_handle_t stack_depot_save_fl
 		/*
 		 * Zero out zone modifiers, as we don't have specific zone
 		 * requirements. Keep the flags related to allocation in atomic
-		 * contexts and I/O.
+		 * contexts, I/O, nolockdep.
 		 */
 		alloc_flags &= ~GFP_ZONEMASK;
-		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
+		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
 		alloc_flags |= __GFP_NOWARN;
 		page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
 		if (page)
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are


