Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049FC145348
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766514341; cv=none; b=qc/AfK0VxgbngrGfbP4Wfv9zdoAuUxPuTRxLECPcuIDeR2o4+IoXzWmTkIbOc/nXrFu61WmW45mrawHbEJttO/FY07asD9Qac35xCHMpsKTR4efr/M/Bpv4D0N/PSDZ/JmB8hYQF7s9VkiImTN+osgJGGEpQAJcO3mBYPmZ8sQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766514341; c=relaxed/simple;
	bh=9cscQioSfMHKtMa06lwByIo6/YKssPZj6j6KBb4vbj0=;
	h=Date:To:From:Subject:Message-Id; b=OkVPvm1jg4TmACvX2re7rQscmZ1eEeZamTdDkjG4KKnqrewdWa4Wj+KgkXQbwPRs9KarrH0bXEjuItO3QRsWQwS+rlsQROkU5IYfXLXP4uKb06Z1aC32gGbhyJHpVppnDzqwpnjHlZn8/aGct8TN6lyA2DrOkmKF2dDazAM102A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ak4SEfLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ak4SEfLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6866FC113D0;
	Tue, 23 Dec 2025 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766514340;
	bh=9cscQioSfMHKtMa06lwByIo6/YKssPZj6j6KBb4vbj0=;
	h=Date:To:From:Subject:From;
	b=Ak4SEfLf1hdGglR2stWkp8cpC3z4vDtR1QN2nJ3BOk4/V6tw7Mzm//Ob1r8af7JFp
	 HwjZRzyszxY9ZJddlFFIUrbk/l5YrjtTYichixMujubW0uyZ4frJwv+WV8vvPec6D9
	 x1k1ku5dffaQLLDpDGs1lhngqo5F6UuCH7d6T2s4=
Date: Tue, 23 Dec 2025 10:25:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch added to mm-new branch
Message-Id: <20251223182540.6866FC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: implement the architecture-specific clear_flush_young_ptes()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Date: Tue, 23 Dec 2025 13:48:38 +0800

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

Link: https://lkml.kernel.org/r/e1e57d89fed939e3f7ff877e4f406d807a7eebd4.1766455378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
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

