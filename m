Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614AE4688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739366; cv=none; b=rBKWeNLj+f5W9FkeWxuAzGdgCapeVHJEFiS6ItjzNlX+RIe9RPDBVCU3cVIGDEW/BS4Z/IURBspS2q6sIHz6/gSjyiFR/co4fgxVo3U4IL6fqP/Kq2ZHRK28DMYCH4aJ69sX0rvzk7wwgMR9G1VK0vNmeKZrV36b5WF4V+fp4Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739366; c=relaxed/simple;
	bh=nG6FFyNfELhlzd1oY86mqcDf65cH9l85PEffbH93SVw=;
	h=Date:To:From:Subject:Message-Id; b=rFJICZx96hlr8BlA3vH9gRXDhMfmsMZEMxQWJwH3K4fMeAI5FZjeOyJGrdiC4RMoEacgvymKeRowVj+mKPB7xpoDcxXbzHHVY48bZ1NEy6wVD3kMlBVI5kg4gvOt7otLoqqNj8aujE7kJncd6jKroFo5GTmfsMc2R+UQeLDhZjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t07/qQdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t07/qQdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D406C433C7;
	Sat, 24 Feb 2024 01:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739366;
	bh=nG6FFyNfELhlzd1oY86mqcDf65cH9l85PEffbH93SVw=;
	h=Date:To:From:Subject:From;
	b=t07/qQdtsLciI7fEKQ0fRQ11pzDezIpUAeYvNyqMjOCRP6ErnQC06Q8hQr430kFkc
	 D1K1Gn/0rvoWLwN5CsZ5l3XRj3jNmeD55wS2WG8IBYUNwf/sO39DGZWbN1J1dMKnDM
	 TwfplS4HBFGKmQV5SA8piNAgDBFfXx3o3Xm6YiOQ=
Date: Fri, 23 Feb 2024 17:49:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-va_alloc-helper.patch removed from -mm tree
Message-Id: <20240224014926.2D406C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: add va_alloc() helper
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-va_alloc-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add va_alloc() helper
Date: Tue, 2 Jan 2024 19:46:23 +0100

Patch series "Mitigate a vmap lock contention", v3.

1. Motivation

- Offload global vmap locks making it scaled to number of CPUS;

- If possible and there is an agreement, we can remove the "Per cpu kva
  allocator" to make the vmap code to be more simple;

- There were complaints from XFS folk that a vmalloc might be contented
  on their workloads.

2. Design(high level overview)

We introduce an effective vmap node logic.  A node behaves as independent
entity to serve an allocation request directly(if possible) from its pool.
That way it bypasses a global vmap space that is protected by its own
lock.

An access to pools are serialized by CPUs.  Number of nodes are equal to
number of CPUs in a system.  Please note the high threshold is bound to
128 nodes.

Pools are size segregated and populated based on system demand.  The
maximum alloc request that can be stored into a segregated storage is 256
pages.  The lazily drain path decays a pool by 25% as a first step and as
second populates it by fresh freed VAs for reuse instead of returning them
into a global space.

When a VA is obtained(alloc path), it is stored in separate nodes.  A
va->va_start address is converted into a correct node where it should be
placed and resided.  Doing so we balance VAs across the nodes as a result
an access becomes scalable.  The addr_to_node() function does a proper
address conversion to a correct node.

A vmap space is divided on segments with fixed size, it is 16 pages.  That
way any address can be associated with a segment number.  Number of
segments are equal to num_possible_cpus() but not grater then 128.  The
numeration starts from 0.  See below how it is converted:

static inline unsigned int
addr_to_node_id(unsigned long addr)
{
	return (addr / zone_size) % nr_nodes;
}

On a free path, a VA can be easily found by converting its "va_start"
address to a certain node it resides.  It is moved from "busy" data to
"lazy" data structure.  Later on, as noted earlier, the lazy kworker
decays each node pool and populates it by fresh incoming VAs.  Please
note, a VA is returned to a node that did an alloc request.

3. Test on AMD Ryzen Threadripper 3970X 32-Core Processor

sudo ./test_vmalloc.sh run_test_mask=7 nr_threads=64

<default perf>
 94.41%     0.89%  [kernel]        [k] _raw_spin_lock
 93.35%    93.07%  [kernel]        [k] native_queued_spin_lock_slowpath
 76.13%     0.28%  [kernel]        [k] __vmalloc_node_range
 72.96%     0.81%  [kernel]        [k] alloc_vmap_area
 56.94%     0.00%  [kernel]        [k] __get_vm_area_node
 41.95%     0.00%  [kernel]        [k] vmalloc
 37.15%     0.01%  [test_vmalloc]  [k] full_fit_alloc_test
 35.17%     0.00%  [kernel]        [k] ret_from_fork_asm
 35.17%     0.00%  [kernel]        [k] ret_from_fork
 35.17%     0.00%  [kernel]        [k] kthread
 35.08%     0.00%  [test_vmalloc]  [k] test_func
 34.45%     0.00%  [test_vmalloc]  [k] fix_size_alloc_test
 28.09%     0.01%  [test_vmalloc]  [k] long_busy_list_alloc_test
 23.53%     0.25%  [kernel]        [k] vfree.part.0
 21.72%     0.00%  [kernel]        [k] remove_vm_area
 20.08%     0.21%  [kernel]        [k] find_unlink_vmap_area
  2.34%     0.61%  [kernel]        [k] free_vmap_area_noflush
<default perf>
   vs
<patch-series perf>
 82.32%     0.22%  [test_vmalloc]  [k] long_busy_list_alloc_test
 63.36%     0.02%  [kernel]        [k] vmalloc
 63.34%     2.64%  [kernel]        [k] __vmalloc_node_range
 30.42%     4.46%  [kernel]        [k] vfree.part.0
 28.98%     2.51%  [kernel]        [k] __alloc_pages_bulk
 27.28%     0.19%  [kernel]        [k] __get_vm_area_node
 26.13%     1.50%  [kernel]        [k] alloc_vmap_area
 21.72%    21.67%  [kernel]        [k] clear_page_rep
 19.51%     2.43%  [kernel]        [k] _raw_spin_lock
 16.61%    16.51%  [kernel]        [k] native_queued_spin_lock_slowpath
 13.40%     2.07%  [kernel]        [k] free_unref_page
 10.62%     0.01%  [kernel]        [k] remove_vm_area
  9.02%     8.73%  [kernel]        [k] insert_vmap_area
  8.94%     0.00%  [kernel]        [k] ret_from_fork_asm
  8.94%     0.00%  [kernel]        [k] ret_from_fork
  8.94%     0.00%  [kernel]        [k] kthread
  8.29%     0.00%  [test_vmalloc]  [k] test_func
  7.81%     0.05%  [test_vmalloc]  [k] full_fit_alloc_test
  5.30%     4.73%  [kernel]        [k] purge_vmap_node
  4.47%     2.65%  [kernel]        [k] free_vmap_area_noflush
<patch-series perf>

confirms that a native_queued_spin_lock_slowpath goes down to
16.51% percent from 93.07%.

The throughput is ~12x higher:

urezki@pc638:~$ time sudo ./test_vmalloc.sh run_test_mask=7 nr_threads=64
Run the test with following parameters: run_test_mask=7 nr_threads=64
Done.
Check the kernel ring buffer to see the summary.

real    10m51.271s
user    0m0.013s
sys     0m0.187s
urezki@pc638:~$

urezki@pc638:~$ time sudo ./test_vmalloc.sh run_test_mask=7 nr_threads=64
Run the test with following parameters: run_test_mask=7 nr_threads=64
Done.
Check the kernel ring buffer to see the summary.

real    0m51.301s
user    0m0.015s
sys     0m0.040s
urezki@pc638:~$


This patch (of 11):

Currently __alloc_vmap_area() function contains an open codded logic that
finds and adjusts a VA based on allocation request.

Introduce a va_alloc() helper that adjusts found VA only.  There is no a
functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20240102184633.748113-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20240102184633.748113-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-va_alloc-helper
+++ a/mm/vmalloc.c
@@ -1481,6 +1481,32 @@ adjust_va_to_fit_type(struct rb_root *ro
 	return 0;
 }
 
+static unsigned long
+va_alloc(struct vmap_area *va,
+		struct rb_root *root, struct list_head *head,
+		unsigned long size, unsigned long align,
+		unsigned long vstart, unsigned long vend)
+{
+	unsigned long nva_start_addr;
+	int ret;
+
+	if (va->va_start > vstart)
+		nva_start_addr = ALIGN(va->va_start, align);
+	else
+		nva_start_addr = ALIGN(vstart, align);
+
+	/* Check the "vend" restriction. */
+	if (nva_start_addr + size > vend)
+		return vend;
+
+	/* Update the free vmap_area. */
+	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
+	if (WARN_ON_ONCE(ret))
+		return vend;
+
+	return nva_start_addr;
+}
+
 /*
  * Returns a start address of the newly allocated area, if success.
  * Otherwise a vend is returned that indicates failure.
@@ -1493,7 +1519,6 @@ __alloc_vmap_area(struct rb_root *root,
 	bool adjust_search_size = true;
 	unsigned long nva_start_addr;
 	struct vmap_area *va;
-	int ret;
 
 	/*
 	 * Do not adjust when:
@@ -1511,18 +1536,8 @@ __alloc_vmap_area(struct rb_root *root,
 	if (unlikely(!va))
 		return vend;
 
-	if (va->va_start > vstart)
-		nva_start_addr = ALIGN(va->va_start, align);
-	else
-		nva_start_addr = ALIGN(vstart, align);
-
-	/* Check the "vend" restriction. */
-	if (nva_start_addr + size > vend)
-		return vend;
-
-	/* Update the free vmap_area. */
-	ret = adjust_va_to_fit_type(root, head, va, nva_start_addr, size);
-	if (WARN_ON_ONCE(ret))
+	nva_start_addr = va_alloc(va, root, head, size, align, vstart, vend);
+	if (nva_start_addr == vend)
 		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
_

Patches currently in -mm which might be from urezki@gmail.com are


