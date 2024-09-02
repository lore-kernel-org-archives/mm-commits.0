Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EC58F6D;
	Mon,  2 Sep 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238772; cv=none; b=LU8zm7kzMboS3z3ZmQWeeadYnBac3ImEepewdx4Bc//IoYz/VbVjai/LroYaoIbTefMpUxz4jvo74kSEqJ1x3z7+9PqKToRIVvSDm1ulGT/jYzZymYLCepzq106/2kuYUb3SQb/ZKI12jZrqT35J16zeGfXXQFlH1M3I9QX/SRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238772; c=relaxed/simple;
	bh=gQXcG4oDx9p4BcBvE0yFukciSu6a7GKPY4R6nUysUWQ=;
	h=Date:To:From:Subject:Message-Id; b=e5l37AAMjdmuRvkxQwNs6AiSHe9+8EW33Gy0SCEbWbCMi4zc0yskP0fOboRJWVKkn0lt9NDRAlLTCpQNMPE5K8nJuej9sXixyLkd6TrNCT1zPhuewVHCYTkqyNW9XlaDj1rcC3HjW1BsWcBkxyLqI0TZMYLdi8wrA8kN2eyhP/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U/8vzFLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U/8vzFLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE306C4CEC3;
	Mon,  2 Sep 2024 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238770;
	bh=gQXcG4oDx9p4BcBvE0yFukciSu6a7GKPY4R6nUysUWQ=;
	h=Date:To:From:Subject:From;
	b=U/8vzFLdLtvpnRsERpjWhLKMP0a2Z39o8SEBdShG83pAPb/Ec0T/EBB800MDRUYDU
	 DvHILwD7nmKvgabQfRz/WibeTuimiz/xAR0Ioqr6SJUZuCetIcXh37I1UiAh6tDuea
	 SeXRU8PUgOvFQFcVQGxRh3S7nPwLr9oUsQBOg48Q=
Date: Sun, 01 Sep 2024 17:59:30 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,urezki@gmail.com,tglx@linutronix.de,stable@vger.kernel.org,lstoakes@gmail.com,hch@infradead.org,hailong.liu@oppo.com,bhe@redhat.com,will@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch removed from -mm tree
Message-Id: <20240902005930.BE306C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: ensure vmap_block is initialised before adding to queue
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Will Deacon <will@kernel.org>
Subject: mm: vmalloc: ensure vmap_block is initialised before adding to queue
Date: Mon, 12 Aug 2024 18:16:06 +0100

Commit 8c61291fd850 ("mm: fix incorrect vbq reference in
purge_fragmented_block") extended the 'vmap_block' structure to contain a
'cpu' field which is set at allocation time to the id of the initialising
CPU.

When a new 'vmap_block' is being instantiated by new_vmap_block(), the
partially initialised structure is added to the local 'vmap_block_queue'
xarray before the 'cpu' field has been initialised.  If another CPU is
concurrently walking the xarray (e.g.  via vm_unmap_aliases()), then it
may perform an out-of-bounds access to the remote queue thanks to an
uninitialised index.

This has been observed as UBSAN errors in Android:

 | Internal error: UBSAN: array index out of bounds: 00000000f2005512 [#1] PREEMPT SMP
 |
 | Call trace:
 |  purge_fragmented_block+0x204/0x21c
 |  _vm_unmap_aliases+0x170/0x378
 |  vm_unmap_aliases+0x1c/0x28
 |  change_memory_common+0x1dc/0x26c
 |  set_memory_ro+0x18/0x24
 |  module_enable_ro+0x98/0x238
 |  do_init_module+0x1b0/0x310

Move the initialisation of 'vb->cpu' in new_vmap_block() ahead of the
addition to the xarray.

Link: https://lkml.kernel.org/r/20240812171606.17486-1-will@kernel.org
Fixes: 8c61291fd850 ("mm: fix incorrect vbq reference in purge_fragmented_block")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue
+++ a/mm/vmalloc.c
@@ -2626,6 +2626,7 @@ static void *new_vmap_block(unsigned int
 	vb->dirty_max = 0;
 	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
+	vb->cpu = raw_smp_processor_id();
 
 	xa = addr_to_vb_xa(va->va_start);
 	vb_idx = addr_to_vb_idx(va->va_start);
@@ -2642,7 +2643,6 @@ static void *new_vmap_block(unsigned int
 	 * integrity together with list_for_each_rcu from read
 	 * side.
 	 */
-	vb->cpu = raw_smp_processor_id();
 	vbq = per_cpu_ptr(&vmap_block_queue, vb->cpu);
 	spin_lock(&vbq->lock);
 	list_add_tail_rcu(&vb->free_list, &vbq->free);
_

Patches currently in -mm which might be from will@kernel.org are


