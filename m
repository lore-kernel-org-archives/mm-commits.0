Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B731388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238889; cv=none; b=DlE0wPUjCCxQXP4LO2/0qPf6WMZuqKWsqKjI91zrpCF7BGIDOySE2dZQq0FnMP+MWxirkqzi4hJlrDZcwQtSxCLDfxvqBbChQp9K9ZUGRHKO22t7SjJNEHiUNMGSgr9V4isBdmVE6iBUrJNYsMN6cbKXtPkZh9TYHndFCCSrkuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238889; c=relaxed/simple;
	bh=1SG1W8OmYn185cjEGYEkzPInF6L8cjeofqYnroqr2iM=;
	h=Date:To:From:Subject:Message-Id; b=N2A7zWoeZBxE8p76/y5tttisVqoPrPChd6CpENRxguwapMP0O57U64XTxrB727hv9gW3Mr7LWRyicrjfp2XybM8RCG7QfWQwy6lvgbhAQi5ClyUsH30pIwmH+rGr3ITkh8EYvAUjUxJLw4JVSjuYHTXx1aFwGg7wDaa5s1ury4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpXla8nJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpXla8nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAE6C4CEC3;
	Mon,  2 Sep 2024 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238889;
	bh=1SG1W8OmYn185cjEGYEkzPInF6L8cjeofqYnroqr2iM=;
	h=Date:To:From:Subject:From;
	b=OpXla8nJeAyzOxk/pIvd/EMH/q6niH6Wj43IPZCzQgZJpxO+ul9KzppgmbRTpc6e6
	 uu7/4WVSybX02+jGJhuqHpzfvPw9/94FTuQCifteIlclXjJNj2K0dldMQrvxodl+zB
	 ziHNezguPex6KNUi+6iDKIB+660FLO7tZhAmMhZE=
Date: Sun, 01 Sep 2024 18:01:28 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-implement-vrealloc-fix-4.patch removed from -mm tree
Message-Id: <20240902010129.5CAE6C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vrealloc: properly document __GFP_ZERO behavior
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-implement-vrealloc-fix-4.patch

This patch was dropped because it was folded into mm-vmalloc-implement-vrealloc.patch

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
@@ -4039,12 +4039,17 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
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
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

