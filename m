Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758A6F073
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247768; cv=none; b=Yfr5D7QCM7cTPFUpMXXT23gn5EQL7RBc8TJPiCQcvWCCuG8U4sLvDviCinJI9nvRA5hiu7j1r9iBfaRls/BS89BW1HgIj9A/CwW2qXJWLWAvyCVWhy7FAbLRsV6vxH2KNTct2SveuH/o/ZvqUwFXR9pidYkOEQf6x458EzCAhJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247768; c=relaxed/simple;
	bh=NdVarNRKwYIuSB74YU96ELLU9SOFWB5+o+dbpziMWCo=;
	h=Date:To:From:Subject:Message-Id; b=om+2sQABhc5U5fKSLBIps9e2PXBy6JJYl9e/67iQXvxLKi9YAEjNp7DAXIfcBbLfhBHoVs9DzHO99cW1U/vH5fD/qNzJ5M2+M/Aicd/UCfRDglYO/jQGYgYYiyZYjyG3fsFYUlmwvcTS4ju4CXuwQOSkj7Wcpvyjp77ht0Me+Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=op4at8WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="op4at8WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1462C4CEC2;
	Mon,  2 Sep 2024 03:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247768;
	bh=NdVarNRKwYIuSB74YU96ELLU9SOFWB5+o+dbpziMWCo=;
	h=Date:To:From:Subject:From;
	b=op4at8WOzaa8XS9rwLzx9ycLrNy/o5vyd31X73ISkUiI5QiDhpJXG7XLfThgqUL7P
	 psOcVSbpWPCZ/c2/Nr5XlZNOKNzPy7f6hqBWl06SXVivG/HAzHjGEzO4+vLromz7bM
	 wPyLPKHaOE1dwsGbnhZHPzR9JwXahh/ft+2tTm58=
Date: Sun, 01 Sep 2024 20:29:27 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,JonasZhou@zhaoxin.com,dennis@kernel.org,cl@linux.com,912460177@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-remove-pcpu_alloc_size.patch removed from -mm tree
Message-Id: <20240902032927.E1462C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove pcpu_alloc_size()
has been removed from the -mm tree.  Its filename was
     percpu-remove-pcpu_alloc_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianhui Zhou <912460177@qq.com>
Subject: percpu: remove pcpu_alloc_size()
Date: Wed, 7 Aug 2024 15:44:48 +0800

pcpu_alloc_size() was added in 7ac5c53e0073 "mm/percpu.c: introduce
pcpu_alloc_size()", which is used to get the allocated memory size in bpf.
However, pcpu_alloc_size() is no longer used in "bpf: Use c->unit_size to
select target cache during free" because its actuall allocated memory size
may change at runtime due to its slab merging mechanism.  Therefore,
pcpu_alloc_size() can be removed.

Link: https://lkml.kernel.org/r/tencent_AD5C50E8D78C07A3CE539BD5F6BF39706507@qq.com
Signed-off-by: Jianhui Zhou <912460177@qq.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    1 -
 mm/percpu.c            |   31 -------------------------------
 2 files changed, 32 deletions(-)

--- a/include/linux/percpu.h~percpu-remove-pcpu_alloc_size
+++ a/include/linux/percpu.h
@@ -135,7 +135,6 @@ extern void __init setup_per_cpu_areas(v
 
 extern void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 				   gfp_t gfp) __alloc_size(1);
-extern size_t pcpu_alloc_size(void __percpu *__pdata);
 
 #define __alloc_percpu_gfp(_size, _align, _gfp)				\
 	alloc_hooks(pcpu_alloc_noprof(_size, _align, false, _gfp))
--- a/mm/percpu.c~percpu-remove-pcpu_alloc_size
+++ a/mm/percpu.c
@@ -2217,37 +2217,6 @@ static void pcpu_balance_workfn(struct w
 }
 
 /**
- * pcpu_alloc_size - the size of the dynamic percpu area
- * @ptr: pointer to the dynamic percpu area
- *
- * Returns the size of the @ptr allocation.  This is undefined for statically
- * defined percpu variables as there is no corresponding chunk->bound_map.
- *
- * RETURNS:
- * The size of the dynamic percpu area.
- *
- * CONTEXT:
- * Can be called from atomic context.
- */
-size_t pcpu_alloc_size(void __percpu *ptr)
-{
-	struct pcpu_chunk *chunk;
-	unsigned long bit_off, end;
-	void *addr;
-
-	if (!ptr)
-		return 0;
-
-	addr = __pcpu_ptr_to_addr(ptr);
-	/* No pcpu_lock here: ptr has not been freed, so chunk is still alive */
-	chunk = pcpu_chunk_addr_search(addr);
-	bit_off = (addr - chunk->base_addr) / PCPU_MIN_ALLOC_SIZE;
-	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
-			    bit_off + 1);
-	return (end - bit_off) * PCPU_MIN_ALLOC_SIZE;
-}
-
-/**
  * free_percpu - free percpu area
  * @ptr: pointer to area to free
  *
_

Patches currently in -mm which might be from 912460177@qq.com are


