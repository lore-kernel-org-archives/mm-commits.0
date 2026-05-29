Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC2536A033
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026861; cv=none; b=DPjShTJLTUilsVwN2gB3aaQj0h9GHQyAXkutfegNbCHqAUg+zU+ZfZHN+FGD77oTMBxTVaP8YFiki8+hJVKTj43fRL8QunGqq8Pu7CfCJEvA6xIne2Bw4+YLcbUNFBPp2HDRrufp8m0f4XRvqM7XtcK1/UwSJNfhr4t1jrN8PB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026861; c=relaxed/simple;
	bh=nJAKPjcP5ht1WOaGl3VgLY8Dqg0d4WzDyLrqcrdNLSg=;
	h=Date:To:From:Subject:Message-Id; b=pQ72/c0lhFzdKkRg/iBw9M1AQP4+X2VqaE1efMr7x/LlKXU4sIawhrz/Mfytega/0iviaaFA547ix4nlp9T4F4l6wkV3UX4S0lq/2GCLrGEbhp1wzSyRIa4Xritecj4Q99nzDfhN5NhvHTEat7M3fckCa0a/j569x0NVNhG0Vt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FtGyfFJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FtGyfFJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27451F00893;
	Fri, 29 May 2026 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026859;
	bh=9V+VHw39WMPRrNpW6zxaHh6R2fAujgq9pZMckWqqxQA=;
	h=Date:To:From:Subject;
	b=FtGyfFJ/EQpKNHCYSSQJCntZYBYsizcvSxSmOz26L/qpDTep4VPOtcP+qNGiiAlkx
	 S1nniyJMCJ0ycSmAApdAF191h/hJFoXj4OQIJU8iYoVXsIYNwgV30wxfy03QLaSY8B
	 ogzTvFptdge7ZudriogbyWt2coaeGih0EG8mfqY0=
Date: Thu, 28 May 2026 20:54:19 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch removed from -mm tree
Message-Id: <20260529035419.C27451F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix.patch

This patch was dropped because it was folded into mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch

------------------------------------------------------
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
Date: Mon, 25 May 2026 16:17:47 +0530

pcpu_get_vm_areas() creates VM_ALLOC areas without setting nr_pages.
Add an nr_pages check to fall back to get_vm_area_size() for these
areas.

Link: https://lore.kernel.org/aff47da5-4fd5-481d-be18-e1eb99639490@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas-fix
+++ a/mm/vmalloc.c
@@ -4673,7 +4673,7 @@ long vread_iter(struct iov_iter *iter, c
 			 * the mapping without updating area->size. Other
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
-			size = (vm->flags & VM_ALLOC) ?
+			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
 				       (vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

