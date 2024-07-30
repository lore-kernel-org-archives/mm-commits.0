Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2A18CC1E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380222; cv=none; b=QZ/G4RTTjctpNGsZ2VzfngmTgeBqM6faRaQ/jlC0VBpC1rL+FY8vAhok3qZnpg3t/A6Z/74PDloLKBCQKSlow4k05nJrv7m8pi8dSkbpwsoVJSsag8B4d10iEWl8Ga4hIu0xZpoPnw/zPGjf75IluAKjlyHnuG2q9BaqgA1czb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380222; c=relaxed/simple;
	bh=Dl7zAsvNqfjJTiME69Or/o9dgYhie0D4NQHvgtr4nnI=;
	h=Date:To:From:Subject:Message-Id; b=nmWLwOcLene2pkJ53U0sSed6kYjoQ29u0Q32H+uXFcH804iBhN8tDvAU4XMimAIozXVjChfD1w5jushgy8i0VwvV5Bat4+tNtLVY62XuICU2JmL9kPCQ8LYuNWv0j/dVpbLkvFYXjh2rR5x9g45S2ia2Bt1y/dWj38aIzunC/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKEdCxWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKEdCxWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DED8C32782;
	Tue, 30 Jul 2024 22:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722380222;
	bh=Dl7zAsvNqfjJTiME69Or/o9dgYhie0D4NQHvgtr4nnI=;
	h=Date:To:From:Subject:From;
	b=tKEdCxWlgmtaQT3NWiNx9If3HyQAMOvbp2NHPJzSZaJrdZ7leGD91pj4H4zgTTV0O
	 2QX2m8QNQKrmlyurR5A/d+0zSwT6SNFevXiSZzSS9HzNt4554bI9AyXiwc5rww7iiL
	 DObkzrmH3KWhikOHUAx8Kuh+u1RUhCgC5iY6ylOw=
Date: Tue, 30 Jul 2024 15:57:01 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch added to mm-unstable branch
Message-Id: <20240730225702.3DED8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kvrealloc: properly document __GFP_ZERO behavior
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch

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
Subject: mm: kvrealloc: properly document __GFP_ZERO behavior
Date: Tue, 30 Jul 2024 20:49:44 +0200

Properly document that if __GFP_ZERO logic is requested, callers must
ensure that, starting with the initial memory allocation, every subsequent
call to this API for the same memory allocation is flagged with
__GFP_ZERO.  Otherwise, it is possible that __GFP_ZERO is not fully
honored by this API.

Link: https://lkml.kernel.org/r/20240730185049.6244-5-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/util.c~mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3
+++ a/mm/util.c
@@ -726,12 +726,17 @@ EXPORT_SYMBOL(kvfree_sensitive);
  * @size: the size to reallocate
  * @flags: the flags for the page level allocator
  *
- * The contents of the object pointed to are preserved up to the lesser of the
- * new and old size (__GFP_ZERO flag is effectively ignored).
- *
  * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
  * and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
  * This function must not be called concurrently with itself or kvfree() for the
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
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch

