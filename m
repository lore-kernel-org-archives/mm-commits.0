Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28774CB40
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gt4xyECJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27210C433C7;
	Wed, 20 Dec 2023 22:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113075;
	bh=TiTCCpkHLobSxj8QLpIhSnVfmLrhPwYkfdbUSH092O4=;
	h=Date:To:From:Subject:From;
	b=Gt4xyECJAOLCojvdtP23rrb2HKF2AZyUuHInIgeuSiP9FNX6yZnZOGO77fIq0Xg3r
	 fFy4TuLetbJbOGSz2ZW6CoscwbwrSA5ZcLCvJYbBF0ASv+g8dO0u+2NnAJAm9wctr5
	 eSh42pqtRptziZNqOlxgZ3N/Ghy6J3gdNCJTODR0=
Date: Wed, 20 Dec 2023 14:57:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tsbogend@alpha.franken.de,jiaxun.yang@flygoat.com,bot@kernelci.org,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mips-fix-r3k_cache_init-build-regression-fix.patch removed from -mm tree
Message-Id: <20231220225755.27210C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips-fix-r3k_cache_init-build-regression-fix
has been removed from the -mm tree.  Its filename was
     mips-fix-r3k_cache_init-build-regression-fix.patch

This patch was dropped because it was folded into mips-fix-r3k_cache_init-build-regression.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mips-fix-r3k_cache_init-build-regression-fix
Date: Thu Dec 14 01:46:21 PM PST 2023

fix whitespace while we're in there

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: kernelci.org bot <bot@kernelci.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/mips/mm/cache.c~mips-fix-r3k_cache_init-build-regression-fix
+++ a/arch/mips/mm/cache.c
@@ -205,16 +205,13 @@ static inline void setup_protection_map(
 
 void cpu_cache_init(void)
 {
-	if (IS_ENABLED(CONFIG_CPU_R3000) && cpu_has_3k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R3000) && cpu_has_3k_cache)
 		r3k_cache_init();
-	}
-	if (IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) && cpu_has_4k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) && cpu_has_4k_cache)
 		r4k_cache_init();
-	}
 
-	if (IS_ENABLED(CONFIG_CPU_CAVIUM_OCTEON) && cpu_has_octeon_cache) {
+	if (IS_ENABLED(CONFIG_CPU_CAVIUM_OCTEON) && cpu_has_octeon_cache)
 		octeon_cache_init();
-	}
 
 	setup_protection_map();
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
mips-fix-r3k_cache_init-build-regression.patch

