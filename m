Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6839FC1D
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260021; cv=none; b=TzaZOgfBMzkCCSPF+y71Z5Pfu2Y/MhuGKp8FrZ7Wxqa/yUKvCJuvCgpQoWLEu55cw4f+ReVfeVbANp3uz3vH1oyQ6fz1EMvdwLMkJiTwB3peiYdA8BLiMGRWEVQiU+C86DZTipu0W9R6paS+xiFCU44czXnQqfy/Nts4PZhtRbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260021; c=relaxed/simple;
	bh=V22wilH169laziA+0TpLmBw5/3+BlRcfEKrcAneNOFw=;
	h=Date:To:From:Subject:Message-Id; b=IgyvMbTLDM+CC2P4zkE5k2lU2DyaaUa71P8fJMJAMZQeyxOCuTmPi3WGuymZgO3ZFAaVqPI7ZSDu1MRgn4XKJJG6Jf2ohqWQjDB9DCJNb1gQWHdBdLRupf4YyyrrwD9AeATU1i7z5rMKfWQyE6wpQBRG1CxgXx8vy+BEtnGhE74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TEipjGMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TEipjGMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4EDC4CEF1;
	Wed, 27 Aug 2025 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756260020;
	bh=V22wilH169laziA+0TpLmBw5/3+BlRcfEKrcAneNOFw=;
	h=Date:To:From:Subject:From;
	b=TEipjGMYcfT5qaRqU33LI1PYihKZrT53JqPqZ9kbErEz1S8AY53nEKoNx2BSsfpbD
	 riqNB3H0xyaWo63IUBC9dHQPjS/bbuhsYy4LQwMu8IMatHPnc4YXjpNgY6Irq7jdq7
	 sjpr+Ji/1Y9CjronxrGx2OQ/hp06GOdibcTYuFN0=
Date: Tue, 26 Aug 2025 19:00:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-stop-calling-page_address-in-free_pages.patch added to mm-new branch
Message-Id: <20250827020020.6E4EDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: stop calling page_address() in free_pages()
has been added to the -mm mm-new branch.  Its filename is
     powerpc-stop-calling-page_address-in-free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-stop-calling-page_address-in-free_pages.patch

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
Subject: powerpc: stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:15 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250826205617.1032945-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-stop-calling-page_address-in-free_pages
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages
 		while (nr_pages--)
 			free_reserved_page(page++);
 	} else
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 }
 
 static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
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

