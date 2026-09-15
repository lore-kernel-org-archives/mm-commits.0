Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956F1F91F6
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 04:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446985; cv=none; b=GzR2NGFj9SwAbfBMDKYwjNDLKyeOLVa9gMWsZaq9Jh3lcIBw8pSFTXw/7Ok2zkGPTtn+3btZ5E/wXf5CYi1FVK/n/vrmWmQ7JzNj+Ei/98C6TjFWaX6Td7mlYobseR/wMQ9kGiAxCwyDpdJxilHWkogFYvvd9hCJark6tkDcedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446985; c=relaxed/simple;
	bh=/840TeIWUcSD6wfWtzkGESFlu7plYkWkkNpRQbw55oE=;
	h=Date:To:From:Subject:Message-Id; b=iHWRDod0qqe2st1Kf+wQUADgNqLzwhX0qKjj3wq3ZHPnT+cBwi5Y7bcQM6h9+e7Rwbpvbftuqn+SDCbYbNGsMfAkZ4f8vF3qxsWo4ZNj/13nnsTZvKmb66jTq6Dp9LJNccL2P6MJjBngcg26X4Jxd7kYia4Wdfj2a7tdc2auVTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VlRJD68+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VlRJD68+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480391F00893;
	Tue, 15 Sep 2026 04:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446983;
	bh=U14KKZ06BQRzW8mLoe0Zfy9A6P2q2g42ZItHU+pcQlM=;
	h=Date:To:From:Subject;
	b=VlRJD68+q/e6t6nmF7Uxc+BvNcV80BeU/ZYqoX3XojplybLWUHucxhybgGYlVlqve
	 ZJxyvLa8mGWntg7VbbD9HKg/s5bBgG3UOKN+Y5fFr+t83nHc8x2yQzpbVuefMV4SJu
	 otMDViPcguoV06mdAZeE771Yp11Uu/WdYWH+uc84=
Date: Mon, 14 Sep 2026 21:36:22 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extract-vmap_insert_free_area-helper.patch added to mm-new branch
Message-Id: <20260915043623.480391F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: extract vmap_insert_free_area helper
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-extract-vmap_insert_free_area-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extract-vmap_insert_free_area-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: extract vmap_insert_free_area helper
Date: Mon, 14 Sep 2026 11:34:01 +0800

The allocation and insertion of a free vmap_area is duplicated between the
loop body and the tail of vmap_init_free_space.  Factor it into a small
helper so the main function only deals with computing the free gaps
between busy regions.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-2-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_insert_free_area-helper
+++ a/mm/vmalloc.c
@@ -5439,11 +5439,23 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
+{
+	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+
+	if (!WARN_ON_ONCE(!free)) {
+		free->va_start = start;
+		free->va_end = end;
+		insert_vmap_area_augment(free, NULL,
+					 &free_vmap_area_root,
+					 &free_vmap_area_list);
+	}
+}
+
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *free;
 	struct vm_struct *busy;
 
 	/*
@@ -5453,32 +5465,15 @@ static void __init vmap_init_free_space(
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if ((unsigned long) busy->addr - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = (unsigned long) busy->addr;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
+		if ((unsigned long)busy->addr - vmap_start > 0)
+			vmap_insert_free_area(vmap_start,
+					      (unsigned long)busy->addr);
 
 		vmap_start = (unsigned long) busy->addr + busy->size;
 	}
 
-	if (vmap_end - vmap_start > 0) {
-		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (!WARN_ON_ONCE(!free)) {
-			free->va_start = vmap_start;
-			free->va_end = vmap_end;
-
-			insert_vmap_area_augment(free, NULL,
-				&free_vmap_area_root,
-					&free_vmap_area_list);
-		}
-	}
+	if (vmap_end - vmap_start > 0)
+		vmap_insert_free_area(vmap_start, vmap_end);
 }
 
 static void vmap_init_nodes(void)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch

