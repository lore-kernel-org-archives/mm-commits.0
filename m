Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D9812D1FF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644494; cv=none; b=p3qnfALWMBs4eLG0LlRHOXt7CdQIaTsMCGTx+R++r4cgMfTM43ZDuIoEEPTjYpQllRNZ1TzLf2sCfR6GwP0cSiXzT0UdoSM7F8VH+KYRlxO/XWbD5HyOD13VgCbNXAFxpo9UW9Q4zFO2QEexF4KUo2+OyIXvXIQ2AWwXnxMbBb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644494; c=relaxed/simple;
	bh=Kh51qtV6duaYKZm0NKRt+qajSYFdX1cDc9VSl3HkR7M=;
	h=Date:To:From:Subject:Message-Id; b=duubyB9i0l5tHGaUHz2B9xtsIjEF4pCgaOaJmqBeeaFl6IahV+0TNO4BbvERnY2NrJxWTfiQPIugAbqe6hPYfojf6OvRdEADaX+HUQkfNK5JBCcsbWnuPEPmSq2TE2oBL3GoqiSQEeAxCPZs2iSQC6uhmRisI8cl+3aKJAC3Vj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C00NbHXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C00NbHXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FCC43399;
	Thu, 22 Feb 2024 23:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644494;
	bh=Kh51qtV6duaYKZm0NKRt+qajSYFdX1cDc9VSl3HkR7M=;
	h=Date:To:From:Subject:From;
	b=C00NbHXWe/1uTFq7khq2ses96nkZffL6l23cN7COc0Mfus3feaL5J/ErqjAHGsLiw
	 /xFlQXBjwDBuq92fOLj5aAjv0ARIyB5idAiHb2IjRbpyy7lucFB+uf52jqg5ge/fYN
	 dKkh7/PVZ0x7cgwhLKqztoS9dpcdv2yk5830St2Q=
Date: Thu, 22 Feb 2024 15:28:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch removed from -mm tree
Message-Id: <20240222232814.0D2FCC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: dplit __flush_tlb_range() to elide trailing DSB
has been removed from the -mm tree.  Its filename was
     arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: dplit __flush_tlb_range() to elide trailing DSB
Date: Thu, 15 Feb 2024 10:31:58 +0000

Split __flush_tlb_range() into __flush_tlb_range_nosync() +
__flush_tlb_range(), in the same way as the existing flush_tlb_page()
arrangement.  This allows calling __flush_tlb_range_nosync() to elide the
trailing DSB.  Forthcoming "contpte" code will take advantage of this when
clearing the young bit from a contiguous range of ptes.

Ordering between dsb and mmu_notifier_arch_invalidate_secondary_tlbs() has
changed, but now aligns with the ordering of __flush_tlb_page().  It has
been discussed that __flush_tlb_page() may be wrong though.  Regardless,
both will be resolved separately if needed.

Link: https://lkml.kernel.org/r/20240215103205.2607016-12-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/tlbflush.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h~arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -422,7 +422,7 @@ do {									\
 #define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
 	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false, kvm_lpa2_is_enabled());
 
-static inline void __flush_tlb_range(struct vm_area_struct *vma,
+static inline void __flush_tlb_range_nosync(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
@@ -456,10 +456,19 @@ static inline void __flush_tlb_range(str
 		__flush_tlb_range_op(vae1is, start, pages, stride, asid,
 				     tlb_level, true, lpa2_is_enabled());
 
-	dsb(ish);
 	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
 }
 
+static inline void __flush_tlb_range(struct vm_area_struct *vma,
+				     unsigned long start, unsigned long end,
+				     unsigned long stride, bool last_level,
+				     int tlb_level)
+{
+	__flush_tlb_range_nosync(vma, start, end, stride,
+				 last_level, tlb_level);
+	dsb(ish);
+}
+
 static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


