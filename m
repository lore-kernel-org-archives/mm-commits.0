Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E091A706A;
	Tue, 13 Aug 2024 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583335; cv=none; b=iEOrRXzERbVl7ZnfUaZ9S7bSI2cseZFr2tej2T+YqZz4KNVCHhu1cpn70BhIRqj5Uate1u195Y0x+Dt8hr/55EgtnZcEXOXSRQ7NaMDQgiVbq87qWnzbefrHFLGHL65vAl2nunL2Ls7U4Ap9m/3oRgo6Jn94y8AIlBke0l1mkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583335; c=relaxed/simple;
	bh=gWuO5hezVV8kXnzUe6XCJo5DwhOnTZS07C3P9XDvlb0=;
	h=Date:To:From:Subject:Message-Id; b=lacQRCg5YCvGucp8MsVGFiKGGA/gwrn6r5+HrzMnl0KtxI+kYnlBGeK215KnPKMRMBHW3qJhl4bzfcn81r3xU9q1HgG2gmbuo55MNTLWuPtDhPJl4i+05sVAKGYF5uTTdenCHBWnMooMHmvAUNfNc0mSwsElV7uZ4fKbm5oAb+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIqPnVif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIqPnVif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A743C32782;
	Tue, 13 Aug 2024 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723583334;
	bh=gWuO5hezVV8kXnzUe6XCJo5DwhOnTZS07C3P9XDvlb0=;
	h=Date:To:From:Subject:From;
	b=JIqPnVifbgpE1yPoxXcpI5MRCfzaPyWBiLruo/O0KamThW6xkTS/KMf2fDbkUTQKw
	 Wj14L1Gl7z1KAp7FnUcqB1fXq3lTt9t4p5YH6PUIjjKVH3eKw2TwqD4KKN1zXqOvgp
	 nAffsnNK/4jMjkN0Bm9vhuKboIQIypKn1D67Js2E=
Date: Tue, 13 Aug 2024 14:08:54 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,urezki@gmail.com,tglx@linutronix.de,stable@vger.kernel.org,lstoakes@gmail.com,hch@infradead.org,hailong.liu@oppo.com,bhe@redhat.com,will@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813210854.9A743C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: ensure vmap_block is initialised before adding to queue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-vmalloc-ensure-vmap_block-is-initialised-before-adding-to-queue.patch

