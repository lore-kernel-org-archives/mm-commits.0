Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31E5215788
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188284; cv=none; b=NXfIaTIWaArTa+Cb501AHujauPxaQziYgISnZF8LNdgybLLU97eLj21tUEgGyGzD1gosWd3dEVAiQ8Rg3z7hmexHDjyuWUxyva+Qc0cy9sx/cJxfD7FczsVnz6JVJHy69+mJbsfDbu0gRJRGbIoAYyvu3x6pPAmkdX6LbYWmEc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188284; c=relaxed/simple;
	bh=nJr6XXSrBW+UdZScuWHKnBxIkAHQIe2SJWemm3xAd/Y=;
	h=Date:To:From:Subject:Message-Id; b=D2NdhlXIzUeblX+fR11HuSw9FUPBSFJuZytlCY6B8Zs6bvEsj1euyua7Qab7NkBkOFtGssNWOUDzRwUAD/8PD7tJnU44xj1NSPgPsBeIHixOsj1AvZK7kxU+znPUvZLzmt45d75pF7IoJgM1X9C+V6/JjsnU9j/o3W8a936yrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbP0raAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbP0raAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBA6C4CEEC;
	Mon, 17 Mar 2025 05:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188283;
	bh=nJr6XXSrBW+UdZScuWHKnBxIkAHQIe2SJWemm3xAd/Y=;
	h=Date:To:From:Subject:From;
	b=tbP0raAAd66zDNEMQC4Mg8wSPaYBi7grDi4mprNS5iWiguNafF6LUcGh/CR+/eKpA
	 1uED5EzVC+2J/kuJVuUECoEKLrtVe/2LTuiTxlqLdpbcNQLCXYfSsHR869GKRPfesv
	 yYKPBcxQGGrcAtHXoLRoR9msKMu5/uNItMBJlKPs=
Date: Sun, 16 Mar 2025 22:11:22 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-clean-up-the-stale-code-comment.patch removed from -mm tree
Message-Id: <20250317051123.6DBA6C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: clean up the stale code comment
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-clean-up-the-stale-code-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mmu_gather: clean up the stale code comment
Date: Tue, 11 Feb 2025 11:43:48 +0800

In commit d7f861b9c43a ("mm/mmu_gather: add __tlb_remove_folio_pages()"),
helper function __tlb_remove_folio_pages_size() was added.  And based on
the helper, wrapper functions __tlb_remove_folio_pages() and
__tlb_remove_page_size() are created and used by upper level functions.

So let's update the code comment to reflect the current code about
tlb_remove_page()/tlb_remove_page_size(), etc.

Link: https://lkml.kernel.org/r/20250211034348.39531-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-clean-up-the-stale-code-comment
+++ a/include/asm-generic/tlb.h
@@ -67,22 +67,21 @@
  *
  *    See also MMU_GATHER_TABLE_FREE and MMU_GATHER_RCU_TABLE_FREE.
  *
- *  - tlb_remove_page() / __tlb_remove_page()
- *  - tlb_remove_page_size() / __tlb_remove_page_size()
- *  - __tlb_remove_folio_pages()
- *
- *    __tlb_remove_page_size() is the basic primitive that queues a page for
- *    freeing. __tlb_remove_page() assumes PAGE_SIZE. Both will return a
- *    boolean indicating if the queue is (now) full and a call to
- *    tlb_flush_mmu() is required.
+ *  - tlb_remove_page() / tlb_remove_page_size()
+ *  - __tlb_remove_folio_pages() / __tlb_remove_page_size()
+ *  - __tlb_remove_folio_pages_size()
+ *
+ *    __tlb_remove_folio_pages_size() is the basic primitive that queues pages
+ *    for freeing. It will return a boolean indicating if the queue is (now)
+ *    full and a call to tlb_flush_mmu() is required.
  *
  *    tlb_remove_page() and tlb_remove_page_size() imply the call to
  *    tlb_flush_mmu() when required and has no return value.
  *
- *    __tlb_remove_folio_pages() is similar to __tlb_remove_page(), however,
- *    instead of removing a single page, remove the given number of consecutive
- *    pages that are all part of the same (large) folio: just like calling
- *    __tlb_remove_page() on each page individually.
+ *    __tlb_remove_folio_pages() is similar to __tlb_remove_page_size(),
+ *    however, instead of removing a single page, assume PAGE_SIZE and remove
+ *    the given number of consecutive pages that are all part of the
+ *    same (large) folio.
  *
  *  - tlb_change_page_size()
  *
_

Patches currently in -mm which might be from bhe@redhat.com are


