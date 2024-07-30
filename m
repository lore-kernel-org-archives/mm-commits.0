Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D0A18CC1E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380175; cv=none; b=Uf4Y+u0PZu9b95Yxxg0b+FbnaXASKYYevdCFsVaYBgSVAaXdlhiE6WqWOOQue9xo3Tf2NnE+TJy8U+R1pUPzGZJLlQJrwf6XRGR3YHcbpyTjYblViLPlRkM8XsnynTVTuBOzs/KQv1lkPYO2agHCwrN56J9freTinzJkwksk0Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380175; c=relaxed/simple;
	bh=sEuigucXkRxET1SOA8INM5LXjbg8BZhh9Z1mcasuv9U=;
	h=Date:To:From:Subject:Message-Id; b=Y0HloglfaMOchiBp7ZSeW3iA3pSy/qg1k3jy1z8WQIqdduyl+71KnwmoerIkh5mR05vAPuClLzHGfchBlz5dj7KNuOzuxsmEjkQryoRuxNlXcnpWbibFvjrjJCiWUyONEvi44mQapBTFdGIKrUYlLmKEj5eEbRocxWj3kM8HMMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HTGj0h3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HTGj0h3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07ADC4AF09;
	Tue, 30 Jul 2024 22:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722380174;
	bh=sEuigucXkRxET1SOA8INM5LXjbg8BZhh9Z1mcasuv9U=;
	h=Date:To:From:Subject:From;
	b=HTGj0h3ifMxBxPyEmUBS4VI/hflhZb9NC5EuiGz3Rb4XJTY7M5DXRi6h1gkhmly/e
	 qfNOps+x5Qd/ZBb4Q7Yp6oETvdV9slY1NPOgpUHoGpxzXHz4FbzT/D+G+AYA3Zbtkj
	 Fcj0S5yKlnDP1vDaQ3GxrKd6vg9pY5fy01wg+dY0=
Date: Tue, 30 Jul 2024 15:56:14 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-implement-vrealloc-fix-4.patch added to mm-unstable branch
Message-Id: <20240730225614.B07ADC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vrealloc: properly document __GFP_ZERO behavior
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-implement-vrealloc-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-implement-vrealloc-fix-4.patch

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
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vrealloc: properly document __GFP_ZERO behavior
Date: Tue, 30 Jul 2024 20:49:43 +0200

Properly document that if __GFP_ZERO logic is requested, callers must
ensure that, starting with the initial memory allocation, every subsequent
call to this API for the same memory allocation is flagged with
__GFP_ZERO.  Otherwise, it is possible that __GFP_ZERO is not fully
honored by this API.

Link: https://lkml.kernel.org/r/20240730185049.6244-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc-fix-4
+++ a/mm/vmalloc.c
@@ -4043,12 +4043,17 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * @size: the size to reallocate
  * @flags: the flags for the page level allocator
  *
- * The contents of the object pointed to are preserved up to the lesser of the
- * new and old size (__GFP_ZERO flag is effectively ignored).
- *
  * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
  * @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
  * This function must not be called concurrently with itself or vfree() for the
  * same memory allocation.
  *
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-vmalloc-implement-vrealloc-fix-3.patch
mm-vmalloc-implement-vrealloc-fix-4.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch

