Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02AB17BB6
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746934970; cv=none; b=AwgLNVInpQnJiQmNFaYl0Pf9ux+WlUWGZkZmHmpKM+2cJq2VeYr4lMs394cU5lWktlWu8vXXtHrqlUwW0wwii93JhPkmI33lggffWhR/7VQCkAHUgNPQQ76K5wRwJ3h6KevIJDEd1tRa8i6+BMTky+V8mPMNfCNMXwrP+i43SJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746934970; c=relaxed/simple;
	bh=bCL1KEcoduIrMZ18O+nF5fWMRuU50JpTP8JC+1Qhc/w=;
	h=Date:To:From:Subject:Message-Id; b=CSdfKnBBTyIXK1/D+Z8fdaCGh3bEesDBe+Q4oFfYPxk416uHogrvquFoqL2EdHNeg6StQHqmfLXLXR5j68ItCkBrTVVx8gP+xT7IajN+dBDgOJBJSBb4RkBxiH9pH0xR2K+4Yd0WABurXMWaByZY/AS0wY5eSXJfRWL5I6w0bE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQk8t6ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQk8t6ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0966C4CEE4;
	Sun, 11 May 2025 03:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746934970;
	bh=bCL1KEcoduIrMZ18O+nF5fWMRuU50JpTP8JC+1Qhc/w=;
	h=Date:To:From:Subject:From;
	b=WQk8t6ffz/rBc9xIaV3MykfrZuZBiPQpTsd4F3R91vsQcl3f2xx0bEgKGgko+qZqu
	 FAd0vCyYfcmMyACaXywnnizJSJdKdx9E6pIwazyUz0GwiFP06MQxEE6mFk4Dh8CInH
	 x3yQsrFLAUIuo+dS2Vf9kK6EHLZtNDxGAIJ9fYHs=
Date: Sat, 10 May 2025 20:42:49 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch removed from -mm tree
Message-Id: <20250511034249.F0966C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
has been removed from the -mm tree.  Its filename was
     mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch

This patch was dropped because it was folded into mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
Date: Sun, 13 Apr 2025 10:04:47 +0800

address minor concerns from David

Link: https://lkml.kernel.org/r/Z/sbv3EmLXWgEE7+@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/gup.c~mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5
+++ a/mm/gup.c
@@ -2115,18 +2115,16 @@ size_t fault_in_writeable(char __user *u
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 
 	if (unlikely(size == 0))
 		return 0;
-
 	if (!user_write_access_begin(uaddr, size))
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_put_user(0, (char __user *)cur, out);
-
 out:
 	user_write_access_end();
 	if (size > cur - start)
@@ -2186,7 +2184,7 @@ size_t fault_in_safe_writeable(const cha
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 	struct mm_struct *mm = current->mm;
 	bool unlocked = false;
 
@@ -2195,7 +2193,7 @@ size_t fault_in_safe_writeable(const cha
 
 	mmap_read_lock(mm);
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		if (fixup_user_fault(mm, cur, FAULT_FLAG_WRITE, &unlocked))
 			break;
 	mmap_read_unlock(mm);
@@ -2218,15 +2216,16 @@ size_t fault_in_readable(const char __us
 {
 	const unsigned long start = (unsigned long)uaddr;
 	const unsigned long end = start + size;
-	unsigned long cur = start;
+	unsigned long cur;
 	volatile char c;
 
 	if (unlikely(size == 0))
 		return 0;
 	if (!user_read_access_begin(uaddr, size))
 		return size;
+
 	/* Stop once we overflow to 0. */
-	for (; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_get_user(c, (const char __user *)cur, out);
 out:
 	user_read_access_end();
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

