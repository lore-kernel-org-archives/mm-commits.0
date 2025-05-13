Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA491EBA0D
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119218; cv=none; b=f3fjk886zRVHEZBLynK6XRIGYu9fPiEaxRrDqFR3CedTqDFfErMRcV3RlpEFBVrP7/cvbVOpvFUW3e4G2CADK1MhvMPeigYDng5Dz28DZfbdQzmQKSjffUWKxPVvjF7QlFSgY0mJffFfIno32ExbtFwUy0wsABAg/fNO558XpG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119218; c=relaxed/simple;
	bh=KIwx2Ne0XefutTH/Bs0tgR9RZ5CjvLFh10qDuQDsdqQ=;
	h=Date:To:From:Subject:Message-Id; b=qHHDsh0xaf4DbmTEr6SbH+eL+2YeU8SLByQRg6Rm26OzlYC1lnlYkQnDceFPg0Ug9qRHvhbCaVjqpi5VoMvA6d7BuDW7Qow1JMnBG4CB7yCdnjBr3lhxdadSY7Dy6dK97p+Q47hNxxMD550lcltAD4c2CGnBC4Y716Ff9AF6VRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvmMRtEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvmMRtEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F08DC4CEE4;
	Tue, 13 May 2025 06:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119217;
	bh=KIwx2Ne0XefutTH/Bs0tgR9RZ5CjvLFh10qDuQDsdqQ=;
	h=Date:To:From:Subject:From;
	b=UvmMRtEQnoYIhC9pu69egZS8MSNUW6Awcw7yF4ZYYEPMNiuxd0Lw6W9aR0ahEdFfP
	 Jb39RDm2dpGmJLOM18EX0uFuKuElhS0hqIDCthSzWMA6UhjSJCLeaph7YPpCIOCxMP
	 Nwer/bMhZCKd7IEeM3O5oXaltvhbotGUn8ANxSJY=
Date: Mon, 12 May 2025 23:53:37 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch removed from -mm tree
Message-Id: <20250513065337.9F08DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: return explicit error value in alloc_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: return explicit error value in alloc_vmap_area()
Date: Sat, 19 Apr 2025 06:36:53 +0800

In codes of alloc_vmap_area(), it returns the upper bound 'vend' to
indicate if the allocation is successful or failed.  That is not very
clear.

Here change to return explicit error values and check them to judge if
allocation is successful.

Link: https://lkml.kernel.org/r/20250418223653.243436-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -1716,7 +1716,7 @@ va_clip(struct rb_root *root, struct lis
 			 */
 			lva = kmem_cache_alloc(vmap_area_cachep, GFP_NOWAIT);
 			if (!lva)
-				return -1;
+				return -ENOMEM;
 		}
 
 		/*
@@ -1730,7 +1730,7 @@ va_clip(struct rb_root *root, struct lis
 		 */
 		va->va_start = nva_start_addr + size;
 	} else {
-		return -1;
+		return -EINVAL;
 	}
 
 	if (type != FL_FIT_TYPE) {
@@ -1759,19 +1759,19 @@ va_alloc(struct vmap_area *va,
 
 	/* Check the "vend" restriction. */
 	if (nva_start_addr + size > vend)
-		return vend;
+		return -ERANGE;
 
 	/* Update the free vmap_area. */
 	ret = va_clip(root, head, va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
-		return vend;
+		return ret;
 
 	return nva_start_addr;
 }
 
 /*
  * Returns a start address of the newly allocated area, if success.
- * Otherwise a vend is returned that indicates failure.
+ * Otherwise an error value is returned that indicates failure.
  */
 static __always_inline unsigned long
 __alloc_vmap_area(struct rb_root *root, struct list_head *head,
@@ -1796,14 +1796,13 @@ __alloc_vmap_area(struct rb_root *root,
 
 	va = find_vmap_lowest_match(root, size, align, vstart, adjust_search_size);
 	if (unlikely(!va))
-		return vend;
+		return -ENOENT;
 
 	nva_start_addr = va_alloc(va, root, head, size, align, vstart, vend);
-	if (nva_start_addr == vend)
-		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
-	find_vmap_lowest_match_check(root, head, size, align);
+	if (!IS_ERR_VALUE(nva_start_addr))
+		find_vmap_lowest_match_check(root, head, size, align);
 #endif
 
 	return nva_start_addr;
@@ -1933,7 +1932,7 @@ node_alloc(unsigned long size, unsigned
 	struct vmap_area *va;
 
 	*vn_id = 0;
-	*addr = vend;
+	*addr = -EINVAL;
 
 	/*
 	 * Fallback to a global heap if not vmalloc or there
@@ -2013,20 +2012,20 @@ static struct vmap_area *alloc_vmap_area
 	}
 
 retry:
-	if (addr == vend) {
+	if (IS_ERR_VALUE(addr)) {
 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
 		addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
 			size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
 	}
 
-	trace_alloc_vmap_area(addr, size, align, vstart, vend, addr == vend);
+	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
 
 	/*
-	 * If an allocation fails, the "vend" address is
+	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (unlikely(addr == vend))
+	if (IS_ERR_VALUE(addr))
 		goto overflow;
 
 	va->va_start = addr;
_

Patches currently in -mm which might be from bhe@redhat.com are


