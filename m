Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4711013541B
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729285362; cv=none; b=RF/jw1iZajJ62UG9StGIhglOgyeoZmfAW7pATxYqxRfRZh5yON+5P0QhvmIKPfuefHNtUkvLqSN/YzTEjaPJbZyX1juV8zfRqfYKVVKx1ZamYgjcm/xKXcjj5kiWT/GDkClFEs2cRjoaMOGGiOxAI9UGvgzW/ZixPag8EJ61yBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729285362; c=relaxed/simple;
	bh=zAQeo/Z/2S9Pr1MYbMNriqU9jvguTh6uuLgaoVhayKk=;
	h=Date:To:From:Subject:Message-Id; b=SoCNKKaMkqam1W7sElET9ibNCU5bYqLuXcU8WZ96gbs7KehtOxBf4jmU5vJFh/u75x59QUmZOUuYCsUDoQZD5BJmSccymp5EWhbcgxocfJy4sI+OqXzd17vR0K0sAUWo08D61OVtKfS/cSdnPXnwAlDv5ENB3b/cdBfl9wYbhSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tX/JdaWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tX/JdaWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC56C4CEC3;
	Fri, 18 Oct 2024 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729285361;
	bh=zAQeo/Z/2S9Pr1MYbMNriqU9jvguTh6uuLgaoVhayKk=;
	h=Date:To:From:Subject:From;
	b=tX/JdaWhtxtQb33Qw/RPGjSV2ekcffuExwjJgmG7Ydn3Ix6NWem6ImSdTtRftAUfA
	 tXFNZqiGD6mN7nkEUYdzipw7ROM/VcbjlN6SawZPBgulYgI8wYs5XRYdKdwQoIz3Jm
	 N16sR3Iy9tw0aS7M7Yh8prneD5u+3ju+4K7JJVEA=
Date: Fri, 18 Oct 2024 14:02:41 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangkefeng.wang@huawei.com,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-remove-goto-from-mremap_to.patch added to mm-unstable branch
Message-Id: <20241018210241.CDC56C4CEC3@smtp.kernel.org>
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
Date: Fri, 18 Oct 2024 13:41:14 -0400

mremap_to() has a goto label at the end that doesn't unwind anything. 
Removing the label makes the code cleaner.

This commit also adds documentation to the function.

Link: https://lkml.kernel.org/r/20241018174114.2871880-3-Liam.Howlett@oracle.com
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

 mm/mremap.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/mm/mremap.c~mm-mremap-remove-goto-from-mremap_to
+++ a/mm/mremap.c
@@ -887,6 +887,20 @@ static int resize_is_valid(struct vm_are
 	return 0;
 }
 
+/*
+ * mremap_to() - remap a vma to a new location
+ * @addr: The old address
+ * @old_len: The old size
+ * @new_addr: The target address
+ * @new_len: The new size
+ * @locked: If the returned vma is locked (VM_LOCKED)
+ * @flags: the mremap flags
+ * @uf: The mremap userfaultfd context
+ * @uf_unmap_early: The userfaultfd unmap early context
+ * @uf_unmap: The userfaultfd unmap context
+ *
+ * Returns: The new address of the vma or an error.
+ */
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 		unsigned long new_addr, unsigned long new_len, bool *locked,
 		unsigned long flags, struct vm_userfaultfd_ctx *uf,
@@ -895,18 +909,18 @@ static unsigned long mremap_to(unsigned
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
@@ -933,31 +947,28 @@ static unsigned long mremap_to(unsigned
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
 
 	ret = resize_is_valid(vma, addr, old_len, new_len, flags);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
 	if (flags & MREMAP_DONTUNMAP &&
 		!may_expand_vm(mm, vma->vm_flags, old_len >> PAGE_SHIFT)) {
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	if (flags & MREMAP_FIXED)
@@ -970,17 +981,14 @@ static unsigned long mremap_to(unsigned
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

