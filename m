Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F114F221FB6
	for <mm-commits@vger.kernel.org>; Thu, 29 Jan 2026 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769728677; cv=none; b=O79NZzxseiswsxWQ8wfv/jtyaqU0rsAw1DobGxq+eNDGFncmeB+HzIm/yQyBVCPCfcloCTeJHQq1Shw7wqLAAv1D+o9pEQXw+ULycCqSTaiL3N+2Od8buGVilShIZUZyboJm9YySsTyri8j4Z+fGm7rKnvJvVElm3GiPew3xeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769728677; c=relaxed/simple;
	bh=+vKU9ed8BvgXHD2f0LgH84ZWqJX7Nz4i7VvNtqGlrCw=;
	h=Date:To:From:Subject:Message-Id; b=CH1RHeUILeK7qlw7E3bFeen1R7+nNbyBpxkpFGepiXOYI3DatmYuLbwMNiGtfCxPipA7AFMeALd8bz6DjpZj4ke/rEDb1YpWIQQwdDIwxwds3wI/VjWFSDcLK7ONpuc9tkm9SZw3Y4zRmmgAKeqvbEnPEjwsbSI3qoghmwjOIlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLIGjYWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLIGjYWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CBEC4CEF7;
	Thu, 29 Jan 2026 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769728676;
	bh=+vKU9ed8BvgXHD2f0LgH84ZWqJX7Nz4i7VvNtqGlrCw=;
	h=Date:To:From:Subject:From;
	b=OLIGjYWIO+Umobl4I7OfDxL7eGy9iStmU7DpXxx1DQbYCFZUwPSwdxgsFa3zo3+lv
	 4I5vI0Flf66J7sULAFjE1hMg8tTNTOoH5/peY0g4RfjKWi8xaudnfzql0VNEy8Wh+W
	 I6nAJDqQJzHNxPM23XeECLwmOM1PYwpNPVuDaixs=
Date: Thu, 29 Jan 2026 15:17:55 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,clm@meta.com,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix.patch added to mm-unstable branch
Message-Id: <20260129231756.67CBEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix.patch

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
Subject: arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix
Date: Thu, 29 Jan 2026 09:42:12 +0800

s/pte_cont/pte_valid_cont/, per Chris

Link: https://lkml.kernel.org/r/de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@meta.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1843,7 +1843,7 @@ static inline int clear_flush_young_ptes
 					 unsigned long addr, pte_t *ptep,
 					 unsigned int nr)
 {
-	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+	if (likely(nr == 1 && !pte_valid_cont(__ptep_get(ptep))))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch
mm-rmap-support-batched-unmapping-for-file-large-folios-fix.patch

