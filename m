Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DDA29D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489896; cv=none; b=i9oyM3gMqY3ZW6eIzhrEgEapekyQjpyy1yJD6Yh/gSAKX0BSBn1KYvF5XEOGrSPC9N5DYZILNNJAOjbMstV0bIsWUDP1uqC4KTcWc8jSiXPcSAfiayiiECzeCqZXZrFNegNBWPbT7hUHOTEUuqwQDdAg44rRsFurUHq9ioQENu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489896; c=relaxed/simple;
	bh=sXLLHQ9coyyf2Lyv28p9d92rS7drcc05CmUN+tz3Tus=;
	h=Date:To:From:Subject:Message-Id; b=nNnsTzvN5odlRFVDDSi8854S2mNJ5M6rs879zIZ4cl4IDHK6m+Yv1W9N+Z0SE++RNUnoFtAyAenAFuZiYemHShIZo6tA9+Vywid7mU8yfeESBYzAMbLZpDEjnhyKae4GxiCzOUxetkL7SJRy35Kkh3UnBr6qG02Vbx5zSXwXCdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nUo3U9cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nUo3U9cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6ADC4CEE7;
	Sun, 21 Sep 2025 21:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489896;
	bh=sXLLHQ9coyyf2Lyv28p9d92rS7drcc05CmUN+tz3Tus=;
	h=Date:To:From:Subject:From;
	b=nUo3U9cTkRcu2/x0FOiSFsVuv61hH3LQc1WQc3RGsj3+GnnyIVghBeUK35B0+TWI3
	 avFYhPj+XlUswdK6FVbUBKdjATDL3NRfZpBFec6zSWXyV5JJRyLcuBNTKSi4ka3pOw
	 PhbTIfv4wqv38pysKXwEZCb3TrVHAgXA0UvzfgK4=
Date: Sun, 21 Sep 2025 14:24:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-kernel-docs-for-free_pages.patch removed from -mm tree
Message-Id: <20250921212456.3A6ADC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add kernel-docs for free_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-kernel-docs-for-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/page_alloc: add kernel-docs for free_pages()
Date: Wed, 3 Sep 2025 11:59:15 -0700

Patch series "Cleanup free_pages() misuse", v3.

free_pages() is supposed to be called when we only have a virtual address.
__free_pages() is supposed to be called when we have a page.

There are a number of callers that use page_address() to get a page's
virtual address then call free_pages() on it when they should just call
__free_pages() directly.

Add kernel-docs for free_pages() to help callers better understand which
function they should be calling, and replace the obvious cases of misuse.


This patch (of 7):

Add kernel-docs to free_pages().  This will help callers understand when
to use it instead of __free_pages().

Link: https://lkml.kernel.org/r/20250903185921.1785167-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20250903185921.1785167-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-kernel-docs-for-free_pages
+++ a/mm/page_alloc.c
@@ -5275,6 +5275,15 @@ void free_pages_nolock(struct page *page
 	___free_pages(page, order, FPI_TRYLOCK);
 }
 
+/**
+ * free_pages - Free pages allocated with __get_free_pages().
+ * @addr: The virtual address tied to a page returned from __get_free_pages().
+ * @order: The order of the allocation.
+ *
+ * This function behaves the same as __free_pages(). Use this function
+ * to free pages when you only have a valid virtual address. If you have
+ * the page, call __free_pages() instead.
+ */
 void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


