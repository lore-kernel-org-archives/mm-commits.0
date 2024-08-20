Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75932DDA0
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724115481; cv=none; b=HsRm1pvm9xuE+6qG2fie5A+v39AEMXw/uowmENN0MMQ4/Pfu0cTQiuP0uHIA9KOlYs4zPwyXzCYIAGXYmHj5DyOiV8Z7GVGrHYuAVfmWq7+DTfc0AwdTPitTx5PZjkU9a/C/5lLKbygi+99ZbdmxuPzHz3shwSd7wWYowWWIXn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724115481; c=relaxed/simple;
	bh=Kjh4qs9KP0iH7jSRrKnLAbAG2/0vRUYeOiIFEfvBnGs=;
	h=Date:To:From:Subject:Message-Id; b=YQpTqLJQsOQ8J4HlUHJWKrxgd1Ta7OS2lVE7ewxLA4AbLFPu3gQPfji5ZEarNRFuy8x0/dYMnZv8Tc2es77PDlGJoDUF0X+FMsILdFT2xB0MUIi1tXu6cmUdAWCy3pyGGBZijxmTF/Tyx26afb/2OGQKNDSsCXdMusxazqlnf1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zI6d48kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zI6d48kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36126C32782;
	Tue, 20 Aug 2024 00:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724115481;
	bh=Kjh4qs9KP0iH7jSRrKnLAbAG2/0vRUYeOiIFEfvBnGs=;
	h=Date:To:From:Subject:From;
	b=zI6d48kqRBIWB3BrGwIwqkPkzb4ucb207AsZRbJ+xDXPqbqYGWPg9MOKDCJCMTWXt
	 fSdsZ9XhXtmh/THAZk3mkFrFvzePSxSdGfUAQER6ZoY9xjIa73/bfDLsXHF2rV9ww8
	 p+NaBPMJ/vcsXO0FSuskMEig6dG0vCDv1fMPxiAg=
Date: Mon, 19 Aug 2024 17:58:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,cl@linux.com,42.hyeyoo@gmail.com,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch added to mm-unstable branch
Message-Id: <20240820005801.36126C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: krealloc: clarify valid usage of __GFP_ZERO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

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
Subject: mm: krealloc: clarify valid usage of __GFP_ZERO
Date: Tue, 13 Aug 2024 00:34:35 +0200

Properly document that if __GFP_ZERO logic is requested, callers must
ensure that, starting with the initial memory allocation, every subsequent
call to this API for the same memory allocation is flagged with
__GFP_ZERO.  Otherwise, it is possible that __GFP_ZERO is not fully
honored by this API.

Link: https://lkml.kernel.org/r/20240812223707.32049-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   10 ++++++++++
 mm/slab_common.c     |   20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/include/linux/slab.h~mm-krealloc-clarify-valid-usage-of-__gfp_zero
+++ a/include/linux/slab.h
@@ -733,6 +733,16 @@ static inline __alloc_size(1, 2) void *k
  * @new_n: new number of elements to alloc
  * @new_size: new size of a single member of the array
  * @flags: the type of memory to allocate (see kmalloc)
+ *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * See krealloc_noprof() for further details.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
  */
 static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(void *p,
 								       size_t new_n,
--- a/mm/slab_common.c~mm-krealloc-clarify-valid-usage-of-__gfp_zero
+++ a/mm/slab_common.c
@@ -1301,11 +1301,27 @@ __do_krealloc(const void *p, size_t new_
  * @new_size: how many bytes of memory are required.
  * @flags: the type of memory to allocate.
  *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes (__GFP_ZERO flag is effectively ignored).
  * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
  * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * This is the case, since krealloc() only knows about the bucket size of an
+ * allocation (but not the exact size it was allocated with) and hence
+ * implements the following semantics for shrinking and growing buffers with
+ * __GFP_ZERO.
+ *
+ *         new             bucket
+ * 0       size             size
+ * |--------|----------------|
+ * |  keep  |      zero      |
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
 void *krealloc_noprof(const void *p, size_t new_size, gfp_t flags)
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
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

