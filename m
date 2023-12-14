Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C36671FF
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 21:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cN5SPVSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF8CC433C9;
	Thu, 14 Dec 2023 21:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702590629;
	bh=1Fphm+pWW56QJYId+dISDi7d9v/WiwF4J+SLKXg2Ovs=;
	h=Date:To:From:Subject:From;
	b=cN5SPVSNNlGq4HzmnbkL41VBzQ7GSWfTh8vgtq0RixjMZDIUO9nfEbbF6dSPMOKZG
	 jXn1TU7W0q1XRKQf86fLF+aAVkohxsSdWKkB3ffUc7Cuxia98KUHwxqRmxU0pq/6zd
	 w1mQcEVNtSrvE94n7CC+FxWAM3z+Kt+SFkPGAxp8=
Date: Thu, 14 Dec 2023 13:50:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tsbogend@alpha.franken.de,jiaxun.yang@flygoat.com,bot@kernelci.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-fix-r3k_cache_init-build-regression.patch added to mm-nonmm-unstable branch
Message-Id: <20231214215029.AAF8CC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips: fix r3k_cache_init build regression
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mips-fix-r3k_cache_init-build-regression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-fix-r3k_cache_init-build-regression.patch

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

Link: https://lkml.kernel.org/r/20231214205506.310402-1-arnd@kernel.org
Fixes: 66445677f01e ("mips: move cache declarations into header")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernelci.org bot <bot@kernelci.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/mm/cache.c~mips-fix-r3k_cache_init-build-regression
+++ a/arch/mips/mm/cache.c
@@ -205,14 +205,14 @@ static inline void setup_protection_map(
 
 void cpu_cache_init(void)
 {
-	if (cpu_has_3k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R3000) && cpu_has_3k_cache) {
 		r3k_cache_init();
 	}
-	if (cpu_has_4k_cache) {
+	if (IS_ENABLED(CONFIG_CPU_R4K_CACHE_TLB) && cpu_has_4k_cache) {
 		r4k_cache_init();
 	}
 
-	if (cpu_has_octeon_cache) {
+	if (IS_ENABLED(CONFIG_CPU_CAVIUM_OCTEON) && cpu_has_octeon_cache) {
 		octeon_cache_init();
 	}
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
mips-fix-r3k_cache_init-build-regression.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

