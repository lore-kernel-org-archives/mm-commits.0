Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE9F1D45FE
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 21:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115985; cv=none; b=a8X/aW/yOVrYwcp+pe23z3uBADqeZ0UZvqfcDK29o/LSl8uqc17q/2Iy9Rfcjlmk07+1Yib5KJ+sozaO9cS5WIvBKQu0jk47Ge6j7Wf6Kupjfpjz/VtfR39H50uG20mnrGG7DrSLGIWnnesWxK/UTfQmHfimRfuT75DyI6Y7xvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115985; c=relaxed/simple;
	bh=GP1ZT6Bg8e+RTRklWTfBl4Pug4P+07GGZUuaJdeQe5A=;
	h=Date:To:From:Subject:Message-Id; b=PYs+Z/iUhgc+CgXHsE3jepRgSS9f1zg7CbHls4AXk6QWsqWUUoMIQgCEl7nIPU4n051gVELgHmG83e8cTwR3N5/Kr/dgWRuggeKSMgCA7PpZq+2NIxoczjrgECk8vy7lhszNrDUjcCGQGn2yyiF0pguCyiXj9/gQVdoXVzIZSC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agMoy3JD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agMoy3JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2875C4CEC5;
	Wed, 16 Oct 2024 21:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729115985;
	bh=GP1ZT6Bg8e+RTRklWTfBl4Pug4P+07GGZUuaJdeQe5A=;
	h=Date:To:From:Subject:From;
	b=agMoy3JDzK6Z35LXzUmMkNUImPm20pYJ3zmlMslhm+T9OAObTAwLkNhtEWXopla7s
	 ud42yYIhfzdRTrYBGeQ2kLclk+1fOCLmvvhytpAjq/gN+NUXwlYZXtd0obNknFQUY6
	 egAF4qYXVYlb4/M9zwbHtfJLI4VnFSFxe3EryR/w=
Date: Wed, 16 Oct 2024 14:59:44 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangkefeng.wang@huawei.com,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-remove-goto-from-mremap_to.patch added to mm-unstable branch
Message-Id: <20241016215944.F2875C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: remove goto from mremap_to()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-remove-goto-from-mremap_to.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-remove-goto-from-mremap_to.patch

This patch will later appear in the mm-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: remove goto from mremap_to()
Date: Wed, 16 Oct 2024 16:17:18 -0400

mremap_to() has a goto label at the end that doesn't unwind anything. 
Removing the label makes the code cleaner.

Link: https://lkml.kernel.org/r/20241016201719.2449143-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/mm/mremap.c~mm-mremap-remove-goto-from-mremap_to
+++ a/mm/mremap.c
@@ -883,18 +883,18 @@ static unsigned long mremap_to(unsigned
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long ret = -EINVAL;
+	unsigned long ret;
 	unsigned long map_flags = 0;
 
 	if (offset_in_page(new_addr))
-		goto out;
+		return -EINVAL;
 
 	if (new_len > TASK_SIZE || new_addr > TASK_SIZE - new_len)
-		goto out;
+		return -EINVAL;
 
 	/* Ensure the old/new locations do not overlap */
 	if (addr + old_len > new_addr && new_addr + new_len > addr)
-		goto out;
+		return -EINVAL;
 
 	/*
 	 * move_vma() need us to stay 4 maps below the threshold, otherwise
@@ -921,33 +921,28 @@ static unsigned long mremap_to(unsigned
 		 */
 		ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	if (old_len > new_len) {
 		ret = do_munmap(mm, addr+new_len, old_len - new_len, uf_unmap);
 		if (ret)
-			goto out;
+			return ret;
 		old_len = new_len;
 	}
 
 	vma = vma_lookup(mm, addr);
-	if (!vma) {
-		ret = -EFAULT;
-		goto out;
-	}
+	if (!vma)
+		return -EFAULT;
 
-	mremap_vma_check(vma, addr, old_len, new_len, flags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto out;
-	}
+	ret = mremap_vma_check(vma, addr, old_len, new_len, flags);
+	if (ret)
+		return ret;
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (flags & MREMAP_DONTUNMAP &&
 		!may_expand_vm(mm, vma->vm_flags, old_len >> PAGE_SHIFT)) {
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	if (flags & MREMAP_FIXED)
@@ -960,17 +955,14 @@ static unsigned long mremap_to(unsigned
 				((addr - vma->vm_start) >> PAGE_SHIFT),
 				map_flags);
 	if (IS_ERR_VALUE(ret))
-		goto out;
+		return ret;
 
 	/* We got a new mapping */
 	if (!(flags & MREMAP_FIXED))
 		new_addr = ret;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf,
-		       uf_unmap);
-
-out:
-	return ret;
+	return move_vma(vma, addr, old_len, new_len, new_addr, locked, flags,
+			uf, uf_unmap);
 }
 
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch
mm-mremap-clean-up-vma_to_resize.patch
mm-mremap-remove-goto-from-mremap_to.patch

