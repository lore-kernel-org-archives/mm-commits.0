Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527E7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+J18zpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621D6C433C8;
	Mon, 11 Dec 2023 01:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257817;
	bh=oYp2oi2VXiUbXJY6GGi1kbGEqjdtePHwHlhyR7HlLTA=;
	h=Date:To:From:Subject:From;
	b=h+J18zpLfvPxLQ91cc9JsPuWarqm8dE0cKLb7SzYiA3n2v/1Cys0qlLRl2TFISUtn
	 YXHbsmi6fcqIZEau+OEpedNrYf6Wr65jG8Z8BUX9XATOpuuIAxRwh4vEUy//bxj1iC
	 Fm9bY0bGW3vFpG5Zv2VJz0Baz0jZ+V7ZO8F761wo=
Date: Sun, 10 Dec 2023 17:23:36 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-mark-local-function-static-if-possible.patch removed from -mm tree
Message-Id: <20231211012337.621D6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: mark local function static if possible
has been removed from the -mm tree.  Its filename was
     mips-mark-local-function-static-if-possible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: mark local function static if possible
Date: Mon, 4 Dec 2023 12:56:56 +0100

These two functions are global but have no extern prototypes or other
callers, so it's best to mark them as static, avoiding these warnings:

arch/mips/kernel/mips-cm.c:204:13: error: no previous prototype for '__mips_cm_l2sync_phys_base' [-Werror=missing-prototypes]
arch/mips/mm/c-r4k.c:1827:12: error: no previous prototype for 'r4k_cache_init_pm' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-7-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-cm.c |    2 +-
 arch/mips/mm/c-r4k.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/mips-cm.c~mips-mark-local-function-static-if-possible
+++ a/arch/mips/kernel/mips-cm.c
@@ -201,7 +201,7 @@ phys_addr_t __mips_cm_phys_base(void)
 phys_addr_t mips_cm_phys_base(void)
 	__attribute__((weak, alias("__mips_cm_phys_base")));
 
-phys_addr_t __mips_cm_l2sync_phys_base(void)
+static phys_addr_t __mips_cm_l2sync_phys_base(void)
 {
 	u32 base_reg;
 
--- a/arch/mips/mm/c-r4k.c~mips-mark-local-function-static-if-possible
+++ a/arch/mips/mm/c-r4k.c
@@ -1828,7 +1828,7 @@ static struct notifier_block r4k_cache_p
 	.notifier_call = r4k_cache_pm_notifier,
 };
 
-int __init r4k_cache_init_pm(void)
+static int __init r4k_cache_init_pm(void)
 {
 	return cpu_pm_register_notifier(&r4k_cache_pm_notifier_block);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

