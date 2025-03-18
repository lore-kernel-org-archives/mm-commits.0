Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D861C5F2F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274613; cv=none; b=hidGvmNi3McM/PDl3dLbj0cvB2+UWSAR4Q/X4fF/OFqx6LlWeNpPzx8OKe+3/122Onq30hTIFi2gxYFCfa+JkWHI/5ekaUtWBnNHL0QrP6jek6n/Wdjl4vR7dtJmYS7Sk+0D7as5Wv4qdtXMzw16IOdRI4SYvOPU0RQC5kOZG4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274613; c=relaxed/simple;
	bh=DireO0YLjhzS+fArQ6JnlNKP0IQoMakvcsn97kK3KPU=;
	h=Date:To:From:Subject:Message-Id; b=klzE1cT/y7ZRup7iV9EotxB12/XbqaX6wAxrlUp06nPFA4xq8izUeyWjfAb5EAfLXkzvq5FeKl8SGVNLzV1/cZUmZTWVDAtLlaGUgf6XFozmifIVEEg3XogPShpNdaZiGdjEW+SDeDbWkRKUhr9Zmq6y1PP/u/9moOYMMNllTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCWwsDmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCWwsDmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62EC4CEDD;
	Tue, 18 Mar 2025 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274613;
	bh=DireO0YLjhzS+fArQ6JnlNKP0IQoMakvcsn97kK3KPU=;
	h=Date:To:From:Subject:From;
	b=yCWwsDmOp3SrKD05EBjdiQ6yvGC0HdkptF0GLAmrXZn5rcu7w6UTCwTZPHXeYhG+l
	 fyOKdToBZfyvcRIEsI1TVJNSpqf1sqLCpq475IlE2dEuAQK9QISz1SSheOF4rReaH4
	 q35iKKKfmVXNNu86gqIC/34nMxUyafQEY9Pl16KA=
Date: Mon, 17 Mar 2025 22:10:12 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch removed from -mm tree
Message-Id: <20250318051013.6A62EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: refactor __vmalloc_node_range_noprof()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/vmalloc: refactor __vmalloc_node_range_noprof()
Date: Thu, 6 Mar 2025 15:21:31 +0800

According to the code logic, the first parameter of the sub-function
__get_vm_area_node() should be size instead of real_size.

Then in __get_vm_area_node(), the size will be aligned, so the redundant
alignment operation is deleted.

The use of the real_size variable causes code redundancy, so it is removed
to simplify the code.

The real prefix is generally used to indicate the adjusted value of a
parameter, but according to the code logic, it should indicate the
original value, so it is recommended to rename it to original_align.

Link: https://lkml.kernel.org/r/20250306072131.800499-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof
+++ a/mm/vmalloc.c
@@ -3771,8 +3771,7 @@ void *__vmalloc_node_range_noprof(unsign
 	struct vm_struct *area;
 	void *ret;
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
-	unsigned long real_size = size;
-	unsigned long real_align = align;
+	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
 
 	if (WARN_ON_ONCE(!size))
@@ -3781,7 +3780,7 @@ void *__vmalloc_node_range_noprof(unsign
 	if ((size >> PAGE_SHIFT) > totalram_pages()) {
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, exceeds total pages",
-			real_size);
+			size);
 		return NULL;
 	}
 
@@ -3798,19 +3797,18 @@ void *__vmalloc_node_range_noprof(unsign
 		else
 			shift = arch_vmap_pte_supported_shift(size);
 
-		align = max(real_align, 1UL << shift);
-		size = ALIGN(real_size, 1UL << shift);
+		align = max(original_align, 1UL << shift);
 	}
 
 again:
-	area = __get_vm_area_node(real_size, align, shift, VM_ALLOC |
+	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
 				  gfp_mask, caller);
 	if (!area) {
 		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, vm_struct allocation failed%s",
-			real_size, (nofail) ? ". Retrying." : "");
+			size, (nofail) ? ". Retrying." : "");
 		if (nofail) {
 			schedule_timeout_uninterruptible(1);
 			goto again;
@@ -3860,7 +3858,7 @@ again:
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, real_size, kasan_flags);
+	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -3869,17 +3867,15 @@ again:
 	 */
 	clear_vm_uninitialized_flag(area);
 
-	size = PAGE_ALIGN(size);
 	if (!(vm_flags & VM_DEFER_KMEMLEAK))
-		kmemleak_vmalloc(area, size, gfp_mask);
+		kmemleak_vmalloc(area, PAGE_ALIGN(size), gfp_mask);
 
 	return area->addr;
 
 fail:
 	if (shift > PAGE_SHIFT) {
 		shift = PAGE_SHIFT;
-		align = real_align;
-		size = real_size;
+		align = original_align;
 		goto again;
 	}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are


