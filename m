Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F6F6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423494; cv=none; b=cOAnyUQ2NJkgSi+I1vjILJM0XEblhSNOm7UbT4qKy8LrTm/1Ny5ItIva6CoTnHzK9cSQLHwhSPYyOrpcxlYWiktDGJoBtAjnLHdpycUD5vY8faCNQq6y3tk7g8h5ihDArEGjYC3QYSQNzwQVuuB6/ZpupF3OoPQmI9TwLDM2vh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423494; c=relaxed/simple;
	bh=drlR0TguEbXAfE3s+O7iR30RPIMGld1DAG23bnlMREI=;
	h=Date:To:From:Subject:Message-Id; b=m2sfVLeWqUqULZCT/3PlHP4Kknn4Gah8IA/LUtC7FgRxeugvuXin7GAYpMMiPr7WpuDLdDVPU/x0sDc3UKyPePQkoYNp8x6JZBirMoKj+USJK35Ju15KdfaurkRIhObpzqGVG9SApJPMbIICtkYzTFI7pzayIuZ2xlZeI6LVvpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBHj/h8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBHj/h8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E76C4CEC2;
	Wed,  4 Sep 2024 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423494;
	bh=drlR0TguEbXAfE3s+O7iR30RPIMGld1DAG23bnlMREI=;
	h=Date:To:From:Subject:From;
	b=IBHj/h8fP9Uj5w4vj0hW3/p8eGDSX6+iVTWN9UkA0aVPN5zPmbeTNPBJwgIoUcVwt
	 KTx6hR9PsgSrM+kvY+y5RibNE4WumBgTt+ZZ8GD9Y2WC/5cIc8x+e/AkPebL7K6N/h
	 NjX1fF0/9mmC261M7Cadipe5cSIZ6+7YkI1PenW4=
Date: Tue, 03 Sep 2024 21:18:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,cl@linux.com,42.hyeyoo@gmail.com,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch removed from -mm tree
Message-Id: <20240904041814.07E76C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: krealloc: clarify valid usage of __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


