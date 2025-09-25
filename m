Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6078A38DDB
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 23:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841296; cv=none; b=KpDSCg1Tgyw4vihXcDYS2GcxLd6PjOI91g2FuqzRkTxZWyn97oOQc+cMAlP52/SmSVqYIict3gageJDKsLIWpm9RnQi1OQ3SAkqeFHhUxPjqfTD+P/DPFmFBpiaRA3R+uD0jTKExw8mnLcWgQSQguSsl0jFEGOXv/lBDFh93/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841296; c=relaxed/simple;
	bh=dc4D8c+nYT2bF/NiTy17EUaysNIy+uQxVkGZGV6BvEU=;
	h=Date:To:From:Subject:Message-Id; b=bCd/VFL6aPkVabvVHaBvTWLelET1cAUIjMXzApJO0x6ePNssLf8Dmmu1qlqnFzoNWA6hviNvQifNo+hHVzkF4rZabzA3pm1oNQqFiG2LHrM2TW3Z4UBxRJMhlL+39pFGLJXi5o8qZhmTH8Y461q0aDFJ1cKGoP58VkT/e7GN430=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hg0g2Q5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hg0g2Q5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AA0C4CEF0;
	Thu, 25 Sep 2025 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841296;
	bh=dc4D8c+nYT2bF/NiTy17EUaysNIy+uQxVkGZGV6BvEU=;
	h=Date:To:From:Subject:From;
	b=Hg0g2Q5S8Kna80h1rqWiNlsjT8ppJsG2y/wYKB1mjUVLQC0vl/hKsnajUt0wyeJA2
	 CfAoYu8TE65QGzbBas4FQYkUgmoVVYLESYBTc33xKIL1LE4UmqjWa1jA7SIe4JyApr
	 qSHIrtfQvSe8ZPp61vu4uOpDhCINNtRsvq9qaKtM=
Date: Thu, 25 Sep 2025 16:01:35 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,agordeev@linux.ibm.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch removed from -mm tree
Message-Id: <20250925230135.E1AA0C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix warnings caused by use of arch_enter_lazy_mmu_mode()
has been removed from the -mm tree.  Its filename was
     kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: kasan: fix warnings caused by use of arch_enter_lazy_mmu_mode()
Date: Sat, 13 Sep 2025 09:55:15 +1000

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function `kasan_populate_vmalloc_pte':
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro `arch_enter_lazy_mmu_mode'
  322 |         arch_enter_lazy_mmu_mode();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~

Fix the issue by explicitly casting the use of the function to void,
since the returned state is not forwarded/retained

Link: https://lkml.kernel.org/r/20250912235515.367061-1-balbirs@nvidia.com
Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards")
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode
+++ a/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
_

Patches currently in -mm which might be from balbirs@nvidia.com are


