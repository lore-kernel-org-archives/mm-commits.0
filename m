Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAD755E48
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 10:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726829535; cv=none; b=VWpQhA3IlCJGziJbieoShK6PqMWQQWy91Lkj1ldxP1gM50WolSTNwNCH0EFJABeZgfWXRnQ3E9jDmFRRt6sd9264qcrW1Y/pMsZQnCyWhemvrA/RU34ZzM2VNZxdu9HMBNOWKeY0TwGUt4B3SJe/Gft7YW/aimSyJEmkDLWFFp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726829535; c=relaxed/simple;
	bh=RoYofDB2hNO8hiLGK8L8VL3Tpas6nCrK+DG86GuC7rM=;
	h=Date:To:From:Subject:Message-Id; b=ejcz1U3+wz3ai0sLYH7p/UctrJUUw9XZX0WIEadq6ULEr7YaPRL8FvqPI3wYp3ggzSXfOwF+wxvtU7f01mBU+dyGuZXm6DSqHENR3m8YfDUMQYtAg6fy5LoTe89yepDnrQvkrQj/GDvwGS8M7szxZ+0CiSuGOVsypOAKLoZVIDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AU748hZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AU748hZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8FFC4CECD;
	Fri, 20 Sep 2024 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726829534;
	bh=RoYofDB2hNO8hiLGK8L8VL3Tpas6nCrK+DG86GuC7rM=;
	h=Date:To:From:Subject:From;
	b=AU748hZL/J71NloXrh9qpC8B4CYbkrc5GzQ+i1z5Omt3ap0qZSJMswrv4UCShUlVi
	 BNonjOQh4798I1qgQrNamdz8VCis/K97Bm3DLHWgjPA9Q5VtXF/W4XCmrtxps0CtwZ
	 29JABsNpq9t/pkgZWVE1mzb0/nVrwaPVx2wH55AI=
Date: Fri, 20 Sep 2024 03:52:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,lkp@intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch removed from -mm tree
Message-Id: <20240920105214.DA8FFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
Date: Fri Sep 20 03:19:14 AM PDT 2024

fix the fix

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-khugepaged-activation-policy-for-shmem-fix-fix
+++ a/mm/shmem.c
@@ -1652,7 +1652,7 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 	return result;
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(SHMEM)
 bool shmem_hpage_pmd_enabled(void)
 {
 	if (shmem_huge == SHMEM_HUGE_DENY)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


