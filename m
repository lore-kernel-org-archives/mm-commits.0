Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5355344376;
	Fri, 24 May 2024 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576942; cv=none; b=bjAqlk+aJNfHMiDtaZNN2s4phEcugitMBvpCJZ8QOnEeHMRikSOPDGNQc8xFFdd4PxrxhRJ9nV8XJAssPnaN8X5W/RnlD1eTfA3QyOmkXRj8WbMiAPpF9Z/TNtHDKSAaGSVEDPnUiFUT25OOO8RC4UdE07umOKNFvkGbuJ75uic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576942; c=relaxed/simple;
	bh=E4fXX5q/OyLzCcN3xRPeWiPp33Vs428oFxbG6egcinc=;
	h=Date:To:From:Subject:Message-Id; b=dZwON7B3EsWDO974qp9XanxtHma1bYRBYBZnmSv2c2kK6eERuA9tCviDVyh6YhegnFCmwHNzDveoSft2MvU+s+7HUuyHvik6Ae4zLaJQnMlNXdij2k0gBMg/8qLypUw1ZrDTNIHZegiwNC1xsLsgzTX8b9vsYZNPpujesTjLLgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ngSOvjtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ngSOvjtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C661FC2BBFC;
	Fri, 24 May 2024 18:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576941;
	bh=E4fXX5q/OyLzCcN3xRPeWiPp33Vs428oFxbG6egcinc=;
	h=Date:To:From:Subject:From;
	b=ngSOvjtQVnfPULZ5ALIcWpUA5rmpgZncQ9YUaeOdzTfR9b2KeYhbhcW4qv8u5xR6z
	 DPldXDmbBA8bmEnz5YOUUS/yqtDHfd5uyYOHJrpkJOnolqLtxp2ZH+r6VCtVLGlzRb
	 NWu9WiZQk2cOQcKjV7FNz1+pQuslrMbwAdynHf3A=
Date: Fri, 24 May 2024 11:55:41 -0700
To: mm-commits@vger.kernel.org,xiang@kernel.org,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,lstoakes@gmail.com,liyangouwen1@oppo.com,hch@infradead.org,chao@kernel.org,baohua@kernel.org,21cnbao@gmail.com,hailong.liu@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-vmalloc-which-may-return-null-if-called-with-__gfp_nofail.patch removed from -mm tree
Message-Id: <20240524185541.C661FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-vmalloc-which-may-return-null-if-called-with-__gfp_nofail.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Hailong.Liu" <hailong.liu@oppo.com>
Subject: mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL
Date: Fri, 10 May 2024 18:01:31 +0800

commit a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
includes support for __GFP_NOFAIL, but it presents a conflict with commit
dd544141b9eb ("vmalloc: back off when the current task is OOM-killed").  A
possible scenario is as follows:

process-a
__vmalloc_node_range(GFP_KERNEL | __GFP_NOFAIL)
    __vmalloc_area_node()
        vm_area_alloc_pages()
		--> oom-killer send SIGKILL to process-a
        if (fatal_signal_pending(current)) break;
--> return NULL;

To fix this, do not check fatal_signal_pending() in vm_area_alloc_pages()
if __GFP_NOFAIL set.

This issue occurred during OPLUS KASAN TEST. Below is part of the log
-> oom-killer sends signal to process
[65731.222840] [ T1308] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/apps/uid_10198,task=gs.intelligence,pid=32454,uid=10198

[65731.259685] [T32454] Call trace:
[65731.259698] [T32454]  dump_backtrace+0xf4/0x118
[65731.259734] [T32454]  show_stack+0x18/0x24
[65731.259756] [T32454]  dump_stack_lvl+0x60/0x7c
[65731.259781] [T32454]  dump_stack+0x18/0x38
[65731.259800] [T32454]  mrdump_common_die+0x250/0x39c [mrdump]
[65731.259936] [T32454]  ipanic_die+0x20/0x34 [mrdump]
[65731.260019] [T32454]  atomic_notifier_call_chain+0xb4/0xfc
[65731.260047] [T32454]  notify_die+0x114/0x198
[65731.260073] [T32454]  die+0xf4/0x5b4
[65731.260098] [T32454]  die_kernel_fault+0x80/0x98
[65731.260124] [T32454]  __do_kernel_fault+0x160/0x2a8
[65731.260146] [T32454]  do_bad_area+0x68/0x148
[65731.260174] [T32454]  do_mem_abort+0x151c/0x1b34
[65731.260204] [T32454]  el1_abort+0x3c/0x5c
[65731.260227] [T32454]  el1h_64_sync_handler+0x54/0x90
[65731.260248] [T32454]  el1h_64_sync+0x68/0x6c

[65731.260269] [T32454]  z_erofs_decompress_queue+0x7f0/0x2258
--> be->decompressed_pages = kvcalloc(be->nr_pages, sizeof(struct page *), GFP_KERNEL | __GFP_NOFAIL);
	kernel panic by NULL pointer dereference.
	erofs assume kvmalloc with __GFP_NOFAIL never return NULL.
[65731.260293] [T32454]  z_erofs_runqueue+0xf30/0x104c
[65731.260314] [T32454]  z_erofs_readahead+0x4f0/0x968
[65731.260339] [T32454]  read_pages+0x170/0xadc
[65731.260364] [T32454]  page_cache_ra_unbounded+0x874/0xf30
[65731.260388] [T32454]  page_cache_ra_order+0x24c/0x714
[65731.260411] [T32454]  filemap_fault+0xbf0/0x1a74
[65731.260437] [T32454]  __do_fault+0xd0/0x33c
[65731.260462] [T32454]  handle_mm_fault+0xf74/0x3fe0
[65731.260486] [T32454]  do_mem_abort+0x54c/0x1b34
[65731.260509] [T32454]  el0_da+0x44/0x94
[65731.260531] [T32454]  el0t_64_sync_handler+0x98/0xb4
[65731.260553] [T32454]  el0t_64_sync+0x198/0x19c

Link: https://lkml.kernel.org/r/20240510100131.1865-1-hailong.liu@oppo.com
Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
Signed-off-by: Hailong.Liu <hailong.liu@oppo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Barry Song <21cnbao@gmail.com>
Reported-by: Oven <liyangouwen1@oppo.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc-which-may-return-null-if-called-with-__gfp_nofail
+++ a/mm/vmalloc.c
@@ -3498,7 +3498,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 {
 	unsigned int nr_allocated = 0;
 	gfp_t alloc_gfp = gfp;
-	bool nofail = false;
+	bool nofail = gfp & __GFP_NOFAIL;
 	struct page *page;
 	int i;
 
@@ -3555,12 +3555,11 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		 * and compaction etc.
 		 */
 		alloc_gfp &= ~__GFP_NOFAIL;
-		nofail = true;
 	}
 
 	/* High-order pages or fallback path if "bulk" fails. */
 	while (nr_allocated < nr_pages) {
-		if (fatal_signal_pending(current))
+		if (!nofail && fatal_signal_pending(current))
 			break;
 
 		if (nid == NUMA_NO_NODE)
_

Patches currently in -mm which might be from hailong.liu@oppo.com are


