Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D01388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238978; cv=none; b=MeW/Fa007nuGg88KqcAwU/jnwZvlFUoRHEzMdE/LOV+PPxaSqzQpRMauZuHym06w9FaoJSlerVhYu5e8g5dmgw0V21+gJ0ZwfOflUpeVpsreSoURyRcfkrPw+5QaWROR+J6Ahfij3AETqyRZJ5jruwCj8jv2+nVR8jjl08wT4sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238978; c=relaxed/simple;
	bh=H0DxhmIcMKncynCtt0PlqadqVPA7msg1V4RPHEB4kCs=;
	h=Date:To:From:Subject:Message-Id; b=M8c/rimFO8C0Bx1BBKz/Otg7eMcP8qvL24jhK7cQRYFC41OX1x1k0LjZiyhuBKyU/0aLqX3INarnajp91ZBoHhRfglvjTthD+JWxfRd8Vvq1W8Ud/9JZ+EHt+8PuB3JrThwDVO9oCUjbCkc0pDa5fjoNdneNadfwGqlKpMYNFSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EgQKvEOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EgQKvEOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98575C4CEC3;
	Mon,  2 Sep 2024 01:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238978;
	bh=H0DxhmIcMKncynCtt0PlqadqVPA7msg1V4RPHEB4kCs=;
	h=Date:To:From:Subject:From;
	b=EgQKvEOs4TbMzYeXD8r7YgaP78k5/OWPzMsBoYFvREFSJq7dAuUqwYowW8msrIGZm
	 N6bVRNNOn+dqxIypG5TjXYiR7lYjZN7ay59D7w1DNE4j0ergh6b3FMQopLVqXcHDXD
	 G1TMqKHrDmut3r4WXyJ6Fb/EOGcq6gmdZtQFT6T0=
Date: Sun, 01 Sep 2024 18:02:58 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch removed from -mm tree
Message-Id: <20240902010258.98575C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kvrealloc: properly document __GFP_ZERO behavior
has been removed from the -mm tree.  Its filename was
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch

This patch was dropped because it was folded into mm-kvmalloc-align-kvrealloc-with-krealloc.patch

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
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

