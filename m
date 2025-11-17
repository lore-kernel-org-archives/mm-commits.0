Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E32D235C1E
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343225; cv=none; b=ub1ujZ3y6FVwvVQqxiR8Lnncn3u6tHh+dq30+zBbSgugGn5YvSWjCcFq2Z/DWS8rwdaaagpBZN5gcYPtpmExQFlq1wbcjVKTRTcLO7wFIra4lzv8ZP1A/30yeFdcrQF7OVtUM4c+PP2MN4IdzVl1jg7rsaPUxD+nZBwPXzk2/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343225; c=relaxed/simple;
	bh=twXQFcWBpmveCJURc1vvpqAdKf70HSbCrlIQUHQDulM=;
	h=Date:To:From:Subject:Message-Id; b=JZBo+KFbIrLO7kd6WFGK1ThpMPihFT1q88aHRaN3woZjzbqFdcHnWy+8FwpAT6MLK/NdtGXr5SVZJgHUGeumqMozHw9IAKzJVGt4LTiG26T7Analx0Fff6R10AU8s316b3bwPbFZHBalLRLdHUgPcvS7sm9RHC3FM0wfQFcypr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Jir5ihn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Jir5ihn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3286DC4CEF1;
	Mon, 17 Nov 2025 01:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343225;
	bh=twXQFcWBpmveCJURc1vvpqAdKf70HSbCrlIQUHQDulM=;
	h=Date:To:From:Subject:From;
	b=1Jir5ihnTei5UWT6CkHIOvss/7ZRqaW6QOoUEA45krv95GoB1eXUeTQS7dousutka
	 fo5kpObIEHaX3gCWJGg5IDeiXgJrcmzfcHdc+ASi9vFRUklxzoda+NFfi+ebett1M2
	 n0AQ4F8oLDMnko7oFMhaWn4BiPbLnM6e9MSn7+M4=
Date: Sun, 16 Nov 2025 17:33:44 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch removed from -mm tree
Message-Id: <20251117013345.3286DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_vm_pgtable: add [pte|pmd]_mkwrite_novma() tests
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: add [pte|pmd]_mkwrite_novma() tests
Date: Wed, 22 Oct 2025 04:29:51 +0100

Add some [pte|pmd]_mkwrite_novma() relevant tests.

[anshuman.khandual@arm.com: add a new test combination per Huang Ying]
  Link: https://lkml.kernel.org/r/20251024013137.136926-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20251022032951.3498553-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-_mkwrite_novma-tests
+++ a/mm/debug_vm_pgtable.c
@@ -102,6 +102,12 @@ static void __init pte_basic_tests(struc
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +201,13 @@ static void __init pmd_basic_tests(struc
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+	WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pmd))));
+	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
+	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
+
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


