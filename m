Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9406224EE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644480; cv=none; b=rbaKKpBrj+4K+UQOsPJJRMi5WV33zrj/uGH7m3/jHQWTrJx8eHRYNM1XBq+nI8iGrj0/eRdLMOP+1OM0gZdDeg357nhgQTb32H3TnmQTrRqYEUEwLWLmD6rilr4SBsgW9dn7fTS0TBStLh09BsLMD9k99RQnOqmBI5mSmNRrNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644480; c=relaxed/simple;
	bh=dmBHRqinw9Hp5F3HgUVlCx1At9vFgZ+aKn2LEGsRx3Q=;
	h=Date:To:From:Subject:Message-Id; b=ncoUmlD2W59Ly1kxuyLG29chy3/lZx8/P09pql8wdYTES8YljVs2eZ6ahKZU2c51K2DkHOJ/xjGW0zFxnlxUaQGhvG83nFVr9Sfpgk7sFiIjGkiqx36in1Xo2yeJg5hrZFW+3fnD+9l7QAo4nW4wlzgSBZEr8i805qxqjScsdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUbI1Eob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUbI1Eob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A7EC43399;
	Thu, 22 Feb 2024 23:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644479;
	bh=dmBHRqinw9Hp5F3HgUVlCx1At9vFgZ+aKn2LEGsRx3Q=;
	h=Date:To:From:Subject:From;
	b=vUbI1EoboxZAJT0uo7lHat9M4+SC9D28LqoodzB6u8nVBMCFkfIX6gxlqVWI49VyV
	 tq+OBKOvsyaQ5PtGC+yXInxnv+n24cafayJheCwyYsVJkM26LLXoQfW89hqwrSZYOU
	 0P/zRA74TDo7G2cyJEZfIGl1K9liR/3IIJ7EL0wI=
Date: Thu, 22 Feb 2024 15:27:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,fengwei.yin@intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,arnd@arndb.de,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-add-tlb_remove_tlb_entries.patch removed from -mm tree
Message-Id: <20240222232759.B3A7EC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: add tlb_remove_tlb_entries()
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-add-tlb_remove_tlb_entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mmu_gather: add tlb_remove_tlb_entries()
Date: Wed, 14 Feb 2024 21:44:32 +0100

Let's add a helper that lets us batch-process multiple consecutive PTEs.

Note that the loop will get optimized out on all architectures except on
powerpc.  We have to add an early define of __tlb_remove_tlb_entry() on
ppc to make the compiler happy (and avoid making tlb_remove_tlb_entries()
a macro).

[arnd@kernel.org: change __tlb_remove_tlb_entry() to an inline function]
  Link: https://lkml.kernel.org/r/20240221154549.2026073-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20240214204435.167852-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/tlb.h |    2 ++
 include/asm-generic/tlb.h      |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/tlb.h~mm-mmu_gather-add-tlb_remove_tlb_entries
+++ a/arch/powerpc/include/asm/tlb.h
@@ -19,6 +19,8 @@
 
 #include <linux/pagemap.h>
 
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
+					  unsigned long address);
 #define __tlb_remove_tlb_entry	__tlb_remove_tlb_entry
 
 #define tlb_flush tlb_flush
--- a/include/asm-generic/tlb.h~mm-mmu_gather-add-tlb_remove_tlb_entries
+++ a/include/asm-generic/tlb.h
@@ -592,7 +592,9 @@ static inline void tlb_flush_p4d_range(s
 }
 
 #ifndef __tlb_remove_tlb_entry
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long address)
+{
+}
 #endif
 
 /**
@@ -608,6 +610,26 @@ static inline void tlb_flush_p4d_range(s
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
+/**
+ * tlb_remove_tlb_entries - remember unmapping of multiple consecutive ptes for
+ *			    later tlb invalidation.
+ *
+ * Similar to tlb_remove_tlb_entry(), but remember unmapping of multiple
+ * consecutive ptes instead of only a single one.
+ */
+static inline void tlb_remove_tlb_entries(struct mmu_gather *tlb,
+		pte_t *ptep, unsigned int nr, unsigned long address)
+{
+	tlb_flush_pte_range(tlb, address, PAGE_SIZE * nr);
+	for (;;) {
+		__tlb_remove_tlb_entry(tlb, ptep, address);
+		if (--nr == 0)
+			break;
+		ptep++;
+		address += PAGE_SIZE;
+	}
+}
+
 #define tlb_remove_huge_tlb_entry(h, tlb, ptep, address)	\
 	do {							\
 		unsigned long _sz = huge_page_size(h);		\
_

Patches currently in -mm which might be from david@redhat.com are


