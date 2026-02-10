Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C2B26ED35
	for <mm-commits@vger.kernel.org>; Tue, 10 Feb 2026 01:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770688433; cv=none; b=hHeZ1qM+DuKZ9PJBfak3xVWFo/fTKZfHHqC5st1r15magUWCHDTN+9x6CNnzLrMhNQi0ejDhn8T4cVMWaTtxYcHtMXBa0OnybmSb2HTBb2AGIEi/VzNf7PVeHM3HRu2U/JH+Wn1sUW/k7BoQ+1BliOt4yCM/NMFdo0S9v9exhVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770688433; c=relaxed/simple;
	bh=6LOOvLC8LS9n81uDFd+L5D7L4hY9papuYOuiZjLMMzI=;
	h=Date:To:From:Subject:Message-Id; b=WGvHvHdsyIlZtVX+S6Jr6I4bn66qdOw7QaTDtcPkBwF5ttHCBQFqNTBMYeliZ5K8vPcYTTss/zkhReHM852uP3bBAGxxonq0SMQNXHuQtuO3U4NE2KQY60jcuwK2btd1hZh6w0k71D8h5+ZQCghFiv/vJ/97pMKaUNySjKRJeg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njZFIb/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njZFIb/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A27EC116C6;
	Tue, 10 Feb 2026 01:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770688432;
	bh=6LOOvLC8LS9n81uDFd+L5D7L4hY9papuYOuiZjLMMzI=;
	h=Date:To:From:Subject:From;
	b=njZFIb/C+5fkXekrdNLcYRsDV3UQY/gGpANHizjmAzMYw7Ry8N2Q8If8+Z8VT0QTQ
	 OYYQUDGv5E16JGXqvGlNjFqhkItGGoh2H/kHZnMY9aAj7gjcLdfFwMhOUmQzF0R/G1
	 aJ8Fa5jhCDyFNqi/WRKDlKu34QTHUaMC3Xk9PpTs=
Date: Mon, 09 Feb 2026 17:53:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch added to mm-unstable branch
Message-Id: <20260210015352.8A27EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: implement the architecture-specific clear_flush_young_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch

