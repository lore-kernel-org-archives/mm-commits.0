Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAAD1D53F
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644499; cv=none; b=cCi9D1cVAmZdyYARBILcQECOg0/YfGBfgheB5A8sJb40U2dCGnIkPvJiTLbmfYUGGh3WFf7W0ovZm771VAPZ5MLzbh7gaZa4ryAdBjxM2yA57mNQattdX+orG6udQt4xg9+FYCzhdzB9AJh4v71jzRbHPsjlImqzdW9ayqeJJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644499; c=relaxed/simple;
	bh=Dprh/IbuOLl0Rdk/W0S0S5od5ldW/NvrLbUg2j6iKJA=;
	h=Date:To:From:Subject:Message-Id; b=mXQnBhKhp8PHh8kJ+/idloJ76I8mbGSgoNXptAnTrW/FT1HDx9lcZRNmfju0wg+FrtcwJZ+pp9vZaxp3Aku2kVVJPSV7oOjGGXHL/3xs52MfPZikqvCap4/w7pWfQigrWXgBUl3ijY28yZXAF0NbBVQqR2ZDajyMBgu9rSCn7HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8Ho4PXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8Ho4PXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32164C433C7;
	Thu, 22 Feb 2024 23:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644499;
	bh=Dprh/IbuOLl0Rdk/W0S0S5od5ldW/NvrLbUg2j6iKJA=;
	h=Date:To:From:Subject:From;
	b=a8Ho4PXTg1f5d6J7063sg1vZ+tYvBEI/wzJqu/mg31HM9DORUAaISuutYqHTQav1q
	 0/h8QaDNQEO3Y1Po0/QDB5+KEsKZUKteTuK1K0LI7F2xp8j0MZjTfrUWdCVSECbX4o
	 f6T60Jw9e8AkGCnYiEAtuUJ4ds12elUllllo/stM=
Date: Thu, 22 Feb 2024 15:28:18 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-implement-pte_batch_hint.patch removed from -mm tree
Message-Id: <20240222232819.32164C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: implement pte_batch_hint()
has been removed from the -mm tree.  Its filename was
     arm64-mm-implement-pte_batch_hint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: implement pte_batch_hint()
Date: Thu, 15 Feb 2024 10:32:03 +0000

When core code iterates over a range of ptes and calls ptep_get() for each
of them, if the range happens to cover contpte mappings, the number of pte
reads becomes amplified by a factor of the number of PTEs in a contpte
block.  This is because for each call to ptep_get(), the implementation
must read all of the ptes in the contpte block to which it belongs to
gather the access and dirty bits.

This causes a hotspot for fork(), as well as operations that unmap memory
such as munmap(), exit and madvise(MADV_DONTNEED).  Fortunately we can fix
this by implementing pte_batch_hint() which allows their iterators to skip
getting the contpte tail ptes when gathering the batch of ptes to operate
on.  This results in the number of PTE reads returning to 1 per pte.

Link: https://lkml.kernel.org/r/20240215103205.2607016-17-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
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

 arch/arm64/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-pte_batch_hint
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1213,6 +1213,15 @@ static inline void contpte_try_unfold(st
 		__contpte_try_unfold(mm, addr, ptep, pte);
 }
 
+#define pte_batch_hint pte_batch_hint
+static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+{
+	if (!pte_valid_cont(pte))
+		return 1;
+
+	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
+}
+
 /*
  * The below functions constitute the public API that arm64 presents to the
  * core-mm to manipulate PTE entries within their page tables (or at least this
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


