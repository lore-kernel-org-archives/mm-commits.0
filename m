Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106C2EC55D
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939864; cv=none; b=sufdsorYGD+fHhe07VEGd2hRuy8QLF3d1m1rlThjU5h3lvbOcnUOHhhzqv9a/Ik16T/EdcFs29BpnYZIxo/qQb5z2iFFoiuR+tzyCSwvFLNHnzJOBCbGx+ZrNzSyWHDbHqGsT25ZHSRZRKPxcZ2gc7nhh/JxpHdmKuDkcH7Aies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939864; c=relaxed/simple;
	bh=P9f77MaTWi8QoOyTyFA265JuHO73ca9u1/hL0Iag6fc=;
	h=Date:To:From:Subject:Message-Id; b=TfByQLyMQgnwDVjazhqZ+Hu/krNkMGZ5M2STH1SxLiPKfLoy6wO6wOmbw8inKRT9ptm9GNxCva1o95VsBCJnNXhRtsg72KmL+Vhn2RzdMl8y/LOjnxL7EIeHjBWEWCDC5Rvb2nuzE3V1dWlEetVw3RzPPhVcChZq4LlzMj9PX54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f15bjm9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f15bjm9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE66C4CEF7;
	Thu, 12 Feb 2026 23:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939863;
	bh=P9f77MaTWi8QoOyTyFA265JuHO73ca9u1/hL0Iag6fc=;
	h=Date:To:From:Subject:From;
	b=f15bjm9B/MjSVln9qWdsjI+KxWAfKXl2DOLvGBgpC7j3yg5guNhhIGoev2kpt7Z2v
	 gXSZn2aJuZLxao7qqzi4P0wD0yMj14eYtIm9/LKhcYNXcAMpwadbo/zC7kJ+79/W/v
	 Z5y952cgJWXftC7DOfPvSQVGhyHJ+OqjOFMx8U9g=
Date: Thu, 12 Feb 2026 15:44:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch removed from -mm tree
Message-Id: <20260212234423.BEE66C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: implement the architecture-specific clear_flush_young_ptes()
has been removed from the -mm tree.  Its filename was
     arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64: mm: implement the architecture-specific clear_flush_young_ptes()
Date: Mon, 9 Feb 2026 22:07:27 +0800

Implement the Arm64 architecture-specific clear_flush_young_ptes() to
enable batched checking of young flags and TLB flushing, improving
performance during large folio reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and
try to reclaim 8G file-backed folios via the memory.reclaim interface.  I
can observe 33% performance improvement on my Arm64 32-core server (and
10%+ improvement on my X86 machine).  Meanwhile, the hotspot
folio_check_references() dropped from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s

Link: https://lkml.kernel.org/r/ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
+}
+
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, unsigned int nr)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


