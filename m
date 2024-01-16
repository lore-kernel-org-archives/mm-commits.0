Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FD57317
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435764; cv=none; b=pu1x9IFjkXFEBBZNEx9Yz2LVqCrq2ZOozmYO+y/GNCko9VmOJkFnwxtJ50Ve0Ywd2Vl63AddsC7E5iRq9VpW/BFIETOK+IQZ4fbab9PNSg4+CyR2Tnc1RCa940DHQhTpqCohCjGsYM6cTjJ8ie8eSF6y/hQFjX2cTLDEDyk/MNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435764; c=relaxed/simple;
	bh=00WhDvYaJrIbFs8+f5/LaRWKsh+shDJzmPm/CrBosgI=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=P8wz3kWSX0dqr+UCvQtELEKLTV+MRYK66ndj6mMbNyXVqHXGMFhRC1US2yPxS6HT9K485/Y75IipCCbUOX3hyQBwIaD5/YHnw/vp/3omJ6sAKtN1Ia81rkQi3jfnF7qMhfKeFabIku1MZzUBKfvhN/u9XTRWrF0qWDr1/7TR1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vigz2fF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vigz2fF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3498C433C7;
	Tue, 16 Jan 2024 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435764;
	bh=00WhDvYaJrIbFs8+f5/LaRWKsh+shDJzmPm/CrBosgI=;
	h=Date:To:From:Subject:From;
	b=vigz2fF0Ub33lTjqWGax3tFlMyl6LJWxaB+SdA86vxELnzNrT42cCSposdydzxnfk
	 zBxUXJkY1/BF0hxAg2a8Z14nByO9iaT4wJnVtw5hgjc6LThmI3hKWTOfk9cVJCQL8v
	 32VkWvvNEsgW5/VpsqZbQrbw37Szk90rqucwAEGI=
Date: Tue, 16 Jan 2024 12:09:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,mike.kravetz@oracle.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch added to mm-unstable branch
Message-Id: <20240116200923.A3498C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: re-enable OPTIMIZE_HUGETLB_VMEMMAP
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

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
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: arm64: mm: re-enable OPTIMIZE_HUGETLB_VMEMMAP
Date: Sat, 13 Jan 2024 17:44:36 +0800

Now update of vmemmap page table can follow the rule of break-before-make
safely for arm64 architecture, re-enable HVO on arm64.

Link: https://lkml.kernel.org/r/20240113094436.2506396-4-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig~arm64-mm-re-enable-optimize_hugetlb_vmemmap
+++ a/arch/arm64/Kconfig
@@ -104,6 +104,7 @@ config ARM64
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

mm-hvo-introduce-helper-function-to-update-and-flush-pgtable.patch
arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch
arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

