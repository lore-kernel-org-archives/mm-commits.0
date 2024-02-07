Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC36128833
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707342894; cv=none; b=hL6Zv/F5rxdMkHN0i5rO93U63SAsKLeBQxhQGjGR0p7Actlq/U5MSlZhDjT3dl2xWh92m1XKpgHKrHZcxi5jawG95s1nwEB93tVPQQC4LsUE+TIgLVjMuAefu42844jfwxgO4EGqIBAdPif/ZUjE2TugsrKLnudJk6s1p//jNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707342894; c=relaxed/simple;
	bh=sX9y3j8AYCnkikBDEqpFVKdWwtRJxUGqVOj9cASRP8I=;
	h=Date:To:From:Subject:Message-Id; b=gnSGlwA+KlZh7OC3qdRwiXrHG8le2DiLrOVTtd62rr+5pLLcGe2wc37QD+A7tRTTnqJANEM3TY/kR/f7K1JouRgVj7+5tmnS2QxHNz7GDgnU8S9JDjemNc4rGrZOoKt71a3dAKL7lzUMS+DhPmaA4NYTb8cb3BbzD83Inm3RByE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2qgCAem5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2qgCAem5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6ADC43390;
	Wed,  7 Feb 2024 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707342893;
	bh=sX9y3j8AYCnkikBDEqpFVKdWwtRJxUGqVOj9cASRP8I=;
	h=Date:To:From:Subject:From;
	b=2qgCAem5NsC78cMTHHxjRuydqhx7M/poCvTqJMskb0An0AZwrhiC+8oMEnW2TlOeR
	 9r6+tZULwOL6GwQisc/rlWfj6Pnf4kpNuSznAP9qq9pLCYbHWmDirOBPPHn/8LLeBt
	 3b1Kx1wwvMA0pWC5Pprge0197S03jBsAOmiW2dks=
Date: Wed, 07 Feb 2024 13:54:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,mike.kravetz@oracle.com,mark.rutland@arm.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch removed from -mm tree
Message-Id: <20240207215453.AC6ADC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: re-enable OPTIMIZE_HUGETLB_VMEMMAP
has been removed from the -mm tree.  Its filename was
     arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

This patch was dropped because an updated version will be merged

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
Cc: Mark Rutland <mark.rutland@arm.com>
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


