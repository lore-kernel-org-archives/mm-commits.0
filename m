Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906CD1C5F1B
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744778; cv=none; b=l0BsLBoTDABLeXRR97+SkZtG8Spm5nXKybVFTXHu+PMhdX3IJZ7/we2FqOWmsz1V3PAHFMtSZEHsuBn8njxTosw5XsJEC8owT0PYLe7wd3fXL4JdusL4burN7IH3gyPqB2MadDn/sSZpr32g5tpQkDMzO5g/qc0W/pKK4E35aQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744778; c=relaxed/simple;
	bh=uXjSlEPAG3hYpWxmc68O+lEm5cy+1AFFKdEGWWR2wPg=;
	h=Date:To:From:Subject:Message-Id; b=GUx++jFOF0dnGSg3QFxP5AFoA88yH1lZEuR/KfSBptYJH5TUy+Q5mCcwim3lNer5AJooZuBjzu6DX+ELsqHK+uAZwuk0Q5Y05L2cYy+aO0mwo4aFuTpNsGfcvXvIxD9S34aEjAREQSBg5xeDIZ46Y4ecPk5qMH5j7POVcgo3aRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OzJhe/XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OzJhe/XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D779C4CEF7;
	Sun, 29 Mar 2026 00:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744778;
	bh=uXjSlEPAG3hYpWxmc68O+lEm5cy+1AFFKdEGWWR2wPg=;
	h=Date:To:From:Subject:From;
	b=OzJhe/XIOFIoEw62SHJIt5L3ZqhsiL4XzGV0wzFIj0MmG1jZatrgr1XYxeYE4nnWB
	 rwdUwVALeZKOfswsqSgvt+AJhX01O6qCqBAu6LzDSuGn7oK6MW2Z9GzjuLB+zVA8r6
	 rdvAXS3ke/8EjqbaboYvoZuJLknuAQFqnXolp6hM=
Date: Sat, 28 Mar 2026 17:39:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch removed from -mm tree
Message-Id: <20260329003938.5D779C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: implement the architecture-specific test_and_clear_young_ptes()
has been removed from the -mm tree.  Its filename was
     arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64: mm: implement the architecture-specific test_and_clear_young_ptes()
Date: Fri, 6 Mar 2026 14:43:42 +0800

Implement the Arm64 architecture-specific test_and_clear_young_ptes() to
enable batched checking of young flags, improving performance during large
folio reclamation when MGLRU is enabled.

While we're at it, simplify ptep_test_and_clear_young() by calling
test_and_clear_young_ptes().  Since callers guarantee that PTEs are
present before calling these functions, we can use pte_cont() to check the
CONT_PTE flag instead of pte_valid_cont().

Performance testing:

Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a
memory cgroup, and try to reclaim 8G file-backed folios via the
memory.reclaim interface.  I can observe 60%+ performance improvement on
my Arm64 32-core server (and about 15% improvement on my X86 machine).

W/o patchset:
real	0m0.470s
user	0m0.000s
sys	0m0.470s

W/ patchset:
real	0m0.180s
user	0m0.001s
sys	0m0.179s

Link: https://lkml.kernel.org/r/7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1812,16 +1812,22 @@ static inline pte_t ptep_get_and_clear(s
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+#define test_and_clear_young_ptes test_and_clear_young_ptes
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		return __ptep_test_and_clear_young(vma, addr, ptep);
+
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep)
 {
-	pte_t orig_pte = __ptep_get(ptep);
-
-	if (likely(!pte_valid_cont(orig_pte)))
-		return __ptep_test_and_clear_young(vma, addr, ptep);
-
-	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
+	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

