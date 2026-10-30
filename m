Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793323819;
	b=PF+XrRqgKBSsxQsB8TY2BMDfd1y9rG80+MydvW+Dlm+a/orzuqZk4mdM7jHxKIizhRhq
	 GmAA18GZuwvJa+EodllTZXEb5IIp1gJBD+zrqbwvGXgQRCuyXKNDSzrBoB0z/GYj8nPF9
	 7g5riw9U+E9MQVOphaSzIlvB3TzDex2RWSTyTbJE9t+K65u8nnIOT52T8724mn1nZVjXn
	 jnSHt6CN2bVfg1ysg+dlAw0pvYF+YIx7ZuX+xKJ9gCVoAsFQ5q8qidnGLf5J4euWSIIO5
	 Wz/e/oCc/Mvwl9G0Za8oKct4zKxdGCzhzyXzNZ73xK7fMVGAVFtWrE9kZLvdVBrdkaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793323819;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lyVxOx4Cc690NR+JFoHWdijlJAiWdzd6CPYTAYfA9iU=;
	b=jW05tWba14nhpiXidgEUhwPnwwlrKxvWUaBx5mZFsw80liwiDKdFnX3UYPI/NBGEeOQK
	 PbiSkaGLCRfz6NCGOc4vYvpNvPHFWFOC0LNus/gOK31onzq6XjYRgm5nDm3LG4u0W3Sas
	 JhEEO6dKz0s3fmsv/XuJ80IXo+1zV33Z47QCAMDz+jScoaMqotBFcnWXts9ETgMf+luje
	 tKvDPz8FQG1xb+dE2i09+CwdXAjE4fULDR9J8t9A7x5wy17fBz+nVngKxYoq/REZ3RuoX
	 RKpw70othuHsQb/rmKfDwU3FgWRaIBNIB8eQmn1cv3lbCPVWUwUnZaMQDunmfLsQ8mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qO0f3sIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4F4606A320;
	Fri, 30 Oct 2026 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qO0f3sIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0141F000C1;
	Fri, 30 Oct 2026 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793323818;
	bh=lyVxOx4Cc690NR+JFoHWdijlJAiWdzd6CPYTAYfA9iU=;
	h=Date:To:From:Subject;
	b=qO0f3sIS3MVkrGjI/v2lLF60G1fMXuesR3h7WNXVO9n6Wxz16BDP0jEjmYiH0VRom
	 haZL7nkiGzsQff5EfnVwelk3CSYJpqQNEMp1m7p6fSbmYntnCtOdPOOILhyK1XbrZr
	 o1ky89pTxpj0kfS/PplzQ2VVEDxD1r4C2xkpEeF8=
Date: Thu, 29 Oct 2026 18:30:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,
	pjw@kernel.org,muchun.song@linux.dev,lkp@intel.com,glider@google.com,
	elver@google.com,dvyukov@google.com,aou@eecs.berkeley.edu,alex@ghiti.fr,
	liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-keep-booting-if-kfence-pool-reservation-fails.patch added to mm-new branch
Message-Id: <20261030013018.1D0141F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: riscv: keep booting if KFENCE pool reservation fails
has been added to the -mm mm-new branch.  Its filename is
     riscv-keep-booting-if-kfence-pool-reservation-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-keep-booting-if-kfence-pool-reservation-fails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: riscv: keep booting if KFENCE pool reservation fails
Date: Thu, 29 Oct 2026 10:57:43 +0800

A failed KFENCE pool reservation hits BUG_ON() and stops boot. Continue
building the linear map and disable KFENCE if the reservation fails.

Reject later pool initialization as well, since a replacement pool may
have huge-page mappings that kfence_protect_page() cannot handle.

Link: https://lore.kernel.org/44fbd039a5cd78bfe7355ccbafb197775dede29c.1793242457.git.liuyun01@kylinos.cn
Fixes: 25abe0db9243 ("riscv: Fix kfence now that the linear mapping can be backed by PUD/P4D/PGD")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1793017073.git.liuyun01@kylinos.cn?part=3
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290904.wbrEL97y-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: AlexandreGhiti <alex@ghiti.fr>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
---

 arch/riscv/include/asm/kfence.h |    4 +++-
 arch/riscv/mm/init.c            |   18 ++++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- a/arch/riscv/include/asm/kfence.h~riscv-keep-booting-if-kfence-pool-reservation-fails
+++ a/arch/riscv/include/asm/kfence.h
@@ -9,9 +9,11 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
+extern bool kfence_disabled;
+
 static inline bool arch_kfence_init_pool(void)
 {
-	return true;
+	return !kfence_disabled;
 }
 
 static inline bool kfence_protect_page(unsigned long addr, bool protect)
--- a/arch/riscv/mm/init.c~riscv-keep-booting-if-kfence-pool-reservation-fails
+++ a/arch/riscv/mm/init.c
@@ -45,6 +45,10 @@ DECLARE_BITMAP(new_valid_map_cpus, NR_CP
 struct kernel_mapping kernel_map __ro_after_init;
 EXPORT_SYMBOL(kernel_map);
 
+#ifdef CONFIG_KFENCE
+bool kfence_disabled __ro_after_init;
+#endif
+
 #ifdef CONFIG_64BIT
 u64 satp_mode __ro_after_init = SATP_MODE_57;
 #else
@@ -1230,10 +1234,13 @@ static void __init create_linear_mapping
 	 *  for this region.
 	 */
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
-	BUG_ON(!kfence_pool);
-
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-	__kfence_pool = __va(kfence_pool);
+	if (kfence_pool) {
+		memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
+		__kfence_pool = __va(kfence_pool);
+	} else {
+		pr_err("failed to allocate kfence pool\n");
+		kfence_disabled = true;
+	}
 #endif
 
 	/* Map all memory banks in the linear mapping */
@@ -1254,6 +1261,9 @@ static void __init create_linear_mapping
 #endif
 
 #ifdef CONFIG_KFENCE
+	if (!kfence_pool)
+		return;
+
 	create_linear_mapping_range(kfence_pool, kfence_pool + KFENCE_POOL_SIZE, PAGE_SIZE, NULL);
 
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

kfence-fix-pool-cleanup-on-metadata-allocation-failure.patch
kfence-clear-the-pool-pointer-before-freeing-pages.patch
riscv-keep-booting-if-kfence-pool-reservation-fails.patch

