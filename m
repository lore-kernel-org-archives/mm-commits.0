Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B76F18801F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854829; cv=none; b=mf3PEzQqyNKtzYYaGfYZ6429PvvhIULmOBL5IxzH0f3BHA7cFW5o6wwKwrGlvTGMe+0PJWwqtHGVMumd/8fp3mZB5xvZhKP8uGIp3t87POOHgy7Q5ME2x1HKb2HNTIsgEMomYoKjJP63BfwvQYgAnq0Kbp2EI5rDDtYdIcrsPkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854829; c=relaxed/simple;
	bh=TdZvvv8RzD6LKs/lJvIiYTF3cTD8Dn48tcxtVscAblY=;
	h=Date:To:From:Subject:Message-Id; b=kynvIEhA33qK38qmgBGlpVFPNjbwk0KGPvr51qcvUHlXcyrcz6va5xR8repSO9BEYprEDAKACFouOZzyPRWp1WFEyw8z3jgL6qJb7UAAtIzXLo0kWTYOZH75hMauTqQ3QT4QHwRlhSztwVKfafDhdHsSASHnYSdAbbsiLgsdlKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=delaup1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="delaup1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EC0C4CED1;
	Wed,  6 Nov 2024 01:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854829;
	bh=TdZvvv8RzD6LKs/lJvIiYTF3cTD8Dn48tcxtVscAblY=;
	h=Date:To:From:Subject:From;
	b=delaup1JDJAKz8KJzsRJkGYQLa98kbvtCspKwi7SgGhjtjxWlc66XjcZwOCa0jFRP
	 MOA3jC4RtLAAwWnMU3RNTIX3najY2V6Vkj8QirUMkVXOKuiSuhooPKvNLqp2m/G/kQ
	 4o9pOTQ+7t+brnUlL6g7NtgR0oIyUPOW5Wma25OI=
Date: Tue, 05 Nov 2024 17:00:28 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,wangkefeng.wang@huawei.com,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-remove-goto-from-mremap_to.patch removed from -mm tree
Message-Id: <20241106010028.E5EC0C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: remove goto from mremap_to()
has been removed from the -mm tree.  Its filename was
     mm-mremap-remove-goto-from-mremap_to.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mremap: remove goto from mremap_to()
Date: Fri, 18 Oct 2024 13:41:14 -0400

mremap_to() has a goto label at the end that doesn't unwind anything. 
Removing the label makes the code cleaner.

This commit also adds documentation to the function.

Link: https://lkml.kernel.org/r/20241018174114.2871880-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

vma-detect-infinite-loop-in-vma-tree.patch

