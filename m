Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7235939AF9
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714665259; cv=none; b=AK6M6S1KtgGB0Ng5TH9NWWQMiZmif59NPd9uQcTbIg+L4Gbe+5XYWN0pZqrBABKsT/6ZII2K82sZKVQyH2GJ89bEfciZMt5sHsr3sBb8f1eEWWIx29PdeoJBr8a/RPHEpe0HvnZVmGbvU7tBV3Kfy5knaTomSPIt4cMGxO62nko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714665259; c=relaxed/simple;
	bh=3pEdYiFbidsv6qh2SWZHEtsbfmGhUNt9K2gKDVgQlmk=;
	h=Date:To:From:Subject:Message-Id; b=RUhI5q9TqdJzKmevteP5f8ZsfV5lSt6+xvCHqu8ymWoMdkyHBPBrZps62lIQpVVoqhJuEJNFMMFTg4isGN/LbBS68fdBLDw4FIYiS1pzNMdWTBu+ig/zY0hPUEOwAqfqL/S6lRvMeIjw+D/tWVTe5B1XGxihoxuVTSwuzZRtkZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pq8iSyRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pq8iSyRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B360EC113CC;
	Thu,  2 May 2024 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714665258;
	bh=3pEdYiFbidsv6qh2SWZHEtsbfmGhUNt9K2gKDVgQlmk=;
	h=Date:To:From:Subject:From;
	b=Pq8iSyRsmUWxP4nP5SOviqsW3qRnbIQ7dPMOAGYsOsaBp8Kl80rpYlo6x3qMuXzU9
	 1Q6D9cbmRK1exLOtDgjJEsWxK3zMAgu3pv+wnWviWE+PWYkrYWx+veJB3YOQjz+RNg
	 0ddMOIIVJSNXg21QGA4/3AOFnONdvHenY2KqPqDw=
Date: Thu, 02 May 2024 08:54:17 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch added to mm-unstable branch
Message-Id: <20240502155418.B360EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: test pmd_leaf() behavior with pmd_mkinvalid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/debug_vm_pgtable: test pmd_leaf() behavior with pmd_mkinvalid()
Date: Wed, 1 May 2024 15:44:39 +0100

An invalidated pmd should still cause pmd_leaf() to return true.  Let's
test for that to ensure all arches remain consistent.

Link: https://lkml.kernel.org/r/20240501144439.1389048-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid
+++ a/mm/debug_vm_pgtable.c
@@ -982,6 +982,7 @@ static void __init pmd_thp_tests(struct
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
 	WARN_ON(!pmd_trans_huge(pmd_mkinvalid(pmd_mkhuge(pmd))));
 	WARN_ON(!pmd_present(pmd_mkinvalid(pmd_mkhuge(pmd))));
+	WARN_ON(!pmd_leaf(pmd_mkinvalid(pmd_mkhuge(pmd))));
 #endif /* __HAVE_ARCH_PMDP_INVALIDATE */
 }
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

fs-proc-task_mmu-fix-loss-of-young-dirty-bits-during-pagemap-scan.patch
fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch
selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch
mm-debug_vm_pgtable-test-pmd_leaf-behavior-with-pmd_mkinvalid.patch

