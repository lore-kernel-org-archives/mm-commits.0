Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54622C699
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 21:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmWv78at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF872C433C8;
	Thu, 14 Dec 2023 21:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702590631;
	bh=sAKAmMxnNUXf8R7h7Tyy8vNtYbSQgYHw1Dc3bE6+gx4=;
	h=Date:To:From:Subject:From;
	b=DmWv78atKHM+9TdbhmUv+/8TDI1W50xzYaO09OZ7ToNicdvJoKLbZJt9/8rPjTlVm
	 Eq/tRp5ANq3tGxMePJ/wOBbSDQcEkZtHcY7Wy1owrNroE1j1s1CdPF280CfjwNiTpx
	 vJTBiJ4M+NEIvBHJoA6MsrE625iWUl99nF0e/GCY=
Date: Thu, 14 Dec 2023 13:50:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tsbogend@alpha.franken.de,jiaxun.yang@flygoat.com,bot@kernelci.org,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-fix-r3k_cache_init-build-regression-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20231214215030.DF872C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips-fix-r3k_cache_init-build-regression-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-fix-r3k_cache_init-build-regression-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-fix-r3k_cache_init-build-regression-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-list_lruc-remove-unused-list_lru_from_kmem.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

