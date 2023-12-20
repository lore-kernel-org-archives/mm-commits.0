Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A544F1FE
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lq5BBXtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F2C433C7;
	Wed, 20 Dec 2023 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113406;
	bh=3jiVINJ7m6+LrKTLgKc9qwOaM23j7L++UiESa8kqyy8=;
	h=Date:To:From:Subject:From;
	b=Lq5BBXtve1dM6N4cjej4x3XNXPQVj8xjQN5aY3wkI3d08seSwpXG4465ooCHI/D9x
	 8SxaP9bA63ZJwmNp05OuKd+f64DUFkPt7E5cBZS53CYHIsSqhZjiyH6N8ojQAFGCTX
	 JjuXtj6UmTzTO0XMWq72w9eXyrPUk2VKhtVGzPQ4=
Date: Wed, 20 Dec 2023 15:03:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tsbogend@alpha.franken.de,jiaxun.yang@flygoat.com,bot@kernelci.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-fix-r3k_cache_init-build-regression.patch removed from -mm tree
Message-Id: <20231220230326.C04F2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: fix r3k_cache_init build regression
has been removed from the -mm tree.  Its filename was
     mips-fix-r3k_cache_init-build-regression.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: fix r3k_cache_init build regression
Date: Thu, 14 Dec 2023 20:54:47 +0000

My earlier patch removed __weak function declarations that used to be
turned into wild branches by the linker, instead causing a link failure
when the called functions are unavailable:

mips-linux-ld: arch/mips/mm/cache.o: in function `cpu_cache_init':
cache.c:(.text+0x670): undefined reference to `r3k_cache_init'

The __weak method seems suboptimal, so rather than putting that back, make
the function calls conditional on the Kconfig symbol that controls the
compilation.

[akpm@linux-foundation.org: fix whitespace while we're in there]
Link: https://lkml.kernel.org/r/20231214205506.310402-1-arnd@kernel.org
Fixes: 66445677f01e ("mips: move cache declarations into header")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernelci.org bot <bot@kernelci.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/mips/mm/cache.c~mips-fix-r3k_cache_init-build-regression
+++ a/arch/mips/mm/cache.c
@@ -205,16 +205,13 @@ static inline void setup_protection_map(
 
 void cpu_cache_init(void)
 {
-	if (cpu_has_3k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R3000) && cpu_has_3k_cache)
 		r3k_cache_init();
-	}
-	if (cpu_has_4k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) && cpu_has_4k_cache)
 		r4k_cache_init();
-	}
 
-	if (cpu_has_octeon_cache) {
+	if (IS_ENABLED(CONFIG_CPU_CAVIUM_OCTEON) && cpu_has_octeon_cache)
 		octeon_cache_init();
-	}
 
 	setup_protection_map();
 }
_

Patches currently in -mm which might be from arnd@arndb.de are


