Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A45341A91C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525550; cv=none; b=Qe0mEnts5Z8vhSiD0iFFUYeD1G66VcabFPRtwFZxjczSzKCG4ASG6z/2+L3+LvQ+UIL98wBT4kVxJ2855FK9bv9I8sqzX0gss8J+8n+e8VMpoDgZV3ipv6enRNDWPFGmZ/ft5zhHcD3ZCkQccPAa72nf7TByJQ1RuXqkQjp9veQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525550; c=relaxed/simple;
	bh=SkUFckJDZBiGg9WIa9uXitpmUeabab9sQQg35ofzJPU=;
	h=Date:To:From:Subject:Message-Id; b=hWItFGzfZofxoE69e1YdPN6aNSN19NTt0zZ0vRIvxtTurnOll4snsDNB4CH+cPboHRt7nuDwvjNp16iEH6POqWwQemBiXjzrasrDROwQa8sduiikDyvjuJvC/Y2eiAaeB5fOABYP+mVH2HgFRZSQFCe9Dut9u1mDwfCL8ra9p5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vsYzLNJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vsYzLNJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BE91F00898;
	Fri,  9 Oct 2026 05:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525549;
	bh=lNwzZvIUdUtKzSgBUAEXLtIkGRm2kOIMo9Ngp3WYB6U=;
	h=Date:To:From:Subject;
	b=vsYzLNJmeLvNBlj6lqRHm0SSBuSTxNAHr5n9kL0Vq47ik21oOVfG/6y64L97NIxJH
	 zgynYlgO5dn6izFkV9LD1bOk6ETlQaA0sZuWhnxj/IrTRNKu6wOPJhIhkBONx9GzEM
	 tZDW3tN6fRyTFcY/o58wwugO2ik/TmatPGpj90ao=
Date: Thu, 08 Oct 2026 22:59:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch removed from -mm tree
Message-Id: <20261009055908.E1BE91F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: fix potential failure for merged VMA in guard-regions
has been removed from the -mm tree.  Its filename was
     kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: fix potential failure for merged VMA in guard-regions
Date: Fri, 11 Sep 2026 15:29:03 +0100

check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags, but
this can fail if the mapping is merged with an adjacent VMA.

To avoid this potential failure, first allocate a temporary region with
extra pages at both ends, unmap it, and then map the test region within
the temporary address range, leaving an unmapped page on each side to
prevent VMA merging.

Link: https://lore.kernel.org/20260911142904.1825452-1-yeoreum.yun@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/guard-regions.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
 	char *ptr, *ptr2;
 	int i;
 
-	/* Map a region. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	/* Map then unmap placeholder to avoid adjacent merges */
+	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ASSERT_EQ(munmap(ptr, 12 * page_size), 0);
+
+	/*
+	 * Map a region for the test. Since the preceding temporary mapping
+	 * succeeded, this mapping should also succeed without merging with
+	 * adjacent VMAs.
+	 */
+	ptr = mmap_(self, variant, ptr + page_size, 10 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/* We shouldn't yet see a guard flag. */
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

