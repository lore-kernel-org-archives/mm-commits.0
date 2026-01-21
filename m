Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0010D356A32
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966128; cv=none; b=k0+7HpdawORHdn95ngxz4phNKuAD+mYmKJmeNG3IjoqPu221y0AoE48arQztIKMU9tNTtoEFjLjVsQO25WKmWDIxHuk0Gg9hEfG+qDZdEJcPxhF+CK+WjsyiVBMs1H7BGoRT11HM+e9M1locXmSORSEKUyN/pfsE7hH17KIzrGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966128; c=relaxed/simple;
	bh=d5kwIgNcOSXvCt30vMEctXZdSjbN3M0kxN1r2xaAN2Q=;
	h=Date:To:From:Subject:Message-Id; b=rPa+XRhM95DK0bhJR1jdOQYw2ouR87++Qej2V5C7Ifih7R6bBrPCNTizxNMf3p+8FJHnYGQU/OZDMvtLU++FJi9mRIr8cFbPOuTtXs0iZPZ6j3etZ5rF8RKndRXp5QQX7/z5t7WGieG3XMJ7JMBJl/zIGjIaDzEQMEC8mYC6Vtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZf0PHv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZf0PHv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90DCC16AAE;
	Wed, 21 Jan 2026 03:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966127;
	bh=d5kwIgNcOSXvCt30vMEctXZdSjbN3M0kxN1r2xaAN2Q=;
	h=Date:To:From:Subject:From;
	b=IZf0PHv4qAjj41LX1+4jjT0/oZDvnHbf2S1MQn5bIDFV1mi/cTg8vb8HTX9jNJKXr
	 avnXvthvJlH9Rkw4Y86fPGlOpXjoJ7q5cqDbjn+KlxEo2l7GMcWcdcMvvYbKCFrhDN
	 llRdPl7WbTenKslr61/7xkCWL28gUKFJZJ2zalyo=
Date: Tue, 20 Jan 2026 19:28:47 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,sj@kernel.org,peterz@infradead.org,npiggin@gmail.com,hca@linux.ibm.com,gor@linux.ibm.com,david@kernel.org,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@kernel.org,agordeev@linux.ibm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch removed from -mm tree
Message-Id: <20260121032847.C90DCC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
Date: Wed, 31 Dec 2025 03:00:26 +0000

__tlb_remove_page_size() is only used in tlb_remove_page_size() with
@delay_remap set to false and it is passed directly to
__tlb_remove_folio_pages_size().

Remove @delay_remap of __tlb_remove_page_size() and call
__tlb_remove_folio_pages_size() with false @delay_remap.

Link: https://lkml.kernel.org/r/20251231030026.15938-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com> # s390
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |    6 ++----
 include/asm-generic/tlb.h   |    5 ++---
 mm/mmu_gather.c             |    5 ++---
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/arch/s390/include/asm/tlb.h
@@ -24,7 +24,7 @@
 
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size);
+		struct page *page, int page_size);
 static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 		struct page *page, unsigned int nr_pages, bool delay_rmap);
 
@@ -46,10 +46,8 @@ static inline bool __tlb_remove_folio_pa
  * s390 doesn't delay rmap removal.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap, int page_size)
+		struct page *page, int page_size)
 {
-	VM_WARN_ON_ONCE(delay_rmap);
-
 	free_folio_and_swap_cache(page_folio(page));
 	return false;
 }
--- a/include/asm-generic/tlb.h~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/include/asm-generic/tlb.h
@@ -287,8 +287,7 @@ struct mmu_gather_batch {
  */
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
-extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size);
+extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size);
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
@@ -510,7 +509,7 @@ static inline void tlb_flush_mmu_tlbonly
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, false, page_size))
+	if (__tlb_remove_page_size(tlb, page, page_size))
 		tlb_flush_mmu(tlb);
 }
 
--- a/mm/mmu_gather.c~mm-mmu_gather-remove-delay_remap-of-__tlb_remove_page_size
+++ a/mm/mmu_gather.c
@@ -210,10 +210,9 @@ bool __tlb_remove_folio_pages(struct mmu
 					     PAGE_SIZE);
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
-		bool delay_rmap, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
 {
-	return __tlb_remove_folio_pages_size(tlb, page, 1, delay_rmap, page_size);
+	return __tlb_remove_folio_pages_size(tlb, page, 1, false, page_size);
 }
 
 #endif /* MMU_GATHER_NO_GATHER */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


