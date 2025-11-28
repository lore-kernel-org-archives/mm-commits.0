Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2821FC8;
	Fri, 28 Nov 2025 19:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764356433; cv=none; b=EzwBmur3T1SkUUumWydBFjbnhQZRqLQzMSbkNpzd0j3fSzQjQrZZ6Z4DrD1nIPN0OZK3uqfnqGkS6zwcAATA71nQX/Ntw2UIy6McZvq3GhMIdJ1PwCAHOEwSl1AQya/6GdglyQwZ+R+ShJUNxAgVcDUATHsBnKqTTv1cyZJYZs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764356433; c=relaxed/simple;
	bh=r9vl59nidftiwOySsqW4gTCs7uMftqG/Lb4SoYrf3EI=;
	h=Date:To:From:Subject:Message-Id; b=nzL9KmdmBfXJWFynE6nK3adV/qhDFD2l4y/8CjEu3PBifCCzcJ+KaN6No/MmRuMQ9bGmhzMOjgakjt5VVM6iN9wHVhHB5ZB8NLJopAnAJEyO+ugI0Jjg0dkYLLNi+r/dFktX5tZb7r9zA2IvQifOJ5AmmStXVRzxx1WST5GjcgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0nL/TT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0nL/TT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D3AC4CEF1;
	Fri, 28 Nov 2025 19:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764356433;
	bh=r9vl59nidftiwOySsqW4gTCs7uMftqG/Lb4SoYrf3EI=;
	h=Date:To:From:Subject:From;
	b=b0nL/TT3nCCe1ckrRZmp3D78nDuzBzDUw6KCq83zf5o2tjPKVFMLjutfJgEu1+lCW
	 YLfChevKwtfhhqu/Bv+aOnHc6Vzc4cE3/QUjV3UqYxEyWRs3/klIqEZ8sgJFOL5rWh
	 GzO9qzi5/wqvAmtUYmaIp/hDj6BactsRavnPr4ms=
Date: Fri, 28 Nov 2025 11:00:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jan.sokolowski@intel.com,christian.koenig@amd.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + idr-fix-idr_alloc-returning-an-id-out-of-range.patch added to mm-hotfixes-unstable branch
Message-Id: <20251128190032.E9D3AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: idr: fix idr_alloc() returning an ID out of range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     idr-fix-idr_alloc-returning-an-id-out-of-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/idr-fix-idr_alloc-returning-an-id-out-of-range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: idr: fix idr_alloc() returning an ID out of range
Date: Fri, 28 Nov 2025 16:18:32 +0000

If you use an IDR with a non-zero base, and specify a range that lies
entirely below the base, 'max - base' becomes very large and
idr_get_free() can return an ID that lies outside of the requested range.

Link: https://lkml.kernel.org/r/20251128161853.3200058-1-willy@infradead.org
Fixes: 6ce711f27500 (idr: Make 1-based IDRs more efficient)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jan Sokolowski <jan.sokolowski@intel.com>
Reported-by: Koen Koning koen.koning@intel.com
Reported-by: Peter Senna Tschudin peter.senna@linux.intel.com
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6449
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c                           |    2 ++
 tools/testing/radix-tree/idr-test.c |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/lib/idr.c~idr-fix-idr_alloc-returning-an-id-out-of-range
+++ a/lib/idr.c
@@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void
 
 	if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
 		idr->idr_rt.xa_flags |= IDR_RT_MARKER;
+	if (max < base)
+		return -ENOSPC;
 
 	id = (id < base) ? 0 : id - base;
 	radix_tree_iter_init(&iter, id);
--- a/tools/testing/radix-tree/idr-test.c~idr-fix-idr_alloc-returning-an-id-out-of-range
+++ a/tools/testing/radix-tree/idr-test.c
@@ -57,6 +57,26 @@ void idr_alloc_test(void)
 	idr_destroy(&idr);
 }
 
+void idr_alloc2_test(void)
+{
+	int id;
+	struct idr idr = IDR_INIT_BASE(idr, 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
+	assert(id == 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	idr_destroy(&idr);
+}
+
 void idr_replace_test(void)
 {
 	DEFINE_IDR(idr);
@@ -409,6 +429,7 @@ void idr_checks(void)
 
 	idr_replace_test();
 	idr_alloc_test();
+	idr_alloc2_test();
 	idr_null_test();
 	idr_nowait_test();
 	idr_get_next_test(0);
_

Patches currently in -mm which might be from willy@infradead.org are

idr-fix-idr_alloc-returning-an-id-out-of-range.patch
mm-fix-vma_start_write_killable-signal-handling.patch

