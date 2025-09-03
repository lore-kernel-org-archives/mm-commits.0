Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD4E2DECCB
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 20:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756932690; cv=none; b=Ht+d16Z/MfvFhDUEzEw2QiVRcLBg6wDJIJhntwPGhDsDTeU/UAvui5Y6RsEs/+n5MD/ccuMKaHfZD7rOyNbhE7ye436SFyvJ9IPnQZymeQYr0MRdeBMgh65eUE6teZjfvX9KM1jDymBF+pNVlifB3CgOpcXEppvqjMi6vpHj1bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756932690; c=relaxed/simple;
	bh=EDvpxstpTSH8qxjfyP2Zqh/6O4crlap0PQmPYYH6YUw=;
	h=Date:To:From:Subject:Message-Id; b=mSA0zZTBF6O7J7cNlO1vhnI92N6iU2Vk/EiRPfZWPdfMkJDUpxAoRxXOfu+7HQ0Prx++S9H+IWr7xUw/Be0kWU2hJE+eAOqmsaqy8vI4e1rRPUv8vLlqsrD7BVx2IyZA554B+IDxDAJDzAW2nPphJYeZAnLviTOpFqGpr0jK86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JgTIuvdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JgTIuvdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F3CC4CEF4;
	Wed,  3 Sep 2025 20:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756932689;
	bh=EDvpxstpTSH8qxjfyP2Zqh/6O4crlap0PQmPYYH6YUw=;
	h=Date:To:From:Subject:From;
	b=JgTIuvdfiOclpjohJ2NV5ht4c4zrAPUAqby1WbMZEuf7Qb3uUtv0xndbzWma9nfDd
	 K3fXFfW59at4pgxou27pkOyz128WX5jXuLzwPQa/t0c1hI4gzl1TwZTXuvQSSKX7h7
	 Ufm2llRLgtl0VUzsQnE+m1Hq/toEDMmwPrlBPO9U=
Date: Wed, 03 Sep 2025 13:51:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-kernel-docs-for-free_pages.patch added to mm-new branch
Message-Id: <20250903205129.A5F3CC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add kernel-docs for free_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-kernel-docs-for-free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-kernel-docs-for-free_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-tag-kernel-stack-pages.patch
mm-page_alloc-add-kernel-docs-for-free_pages.patch
aoe-stop-calling-page_address-in-free_page.patch
x86-stop-calling-page_address-in-free_pages.patch
riscv-stop-calling-page_address-in-free_pages.patch
powerpc-stop-calling-page_address-in-free_pages.patch
arm64-stop-calling-page_address-in-free_pages.patch
virtio_balloon-stop-calling-page_address-in-free_pages.patch

