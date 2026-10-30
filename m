Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343383;
	b=WA15HUC2snCb6AY6JH5mYqDY/KfIn/SJfmXMibbPuO0uvmFUOZs0eq8mHva0VP+sq+1j
	 qVSkAv8mvLuZElfiswenCpEnStO5sFU7dX7/EUWLo8JrflbrmCTnsHwIcKVolOQ/NTnv4
	 MSgFgRBDw5DbICRSD4CQV/nINy1oMGFGN4FL0SaDUkdbnPTHTwv53V2mdRS0rn77ZXaLJ
	 1lWMyRxiRq2UOUa9hl5XUh3hBcpu9VpemhcBXP0fPTKYNRzjx+9Q6yVzy0K2ecFnNXCZC
	 93S01hMRn0RR0P4nmlHMyqcFuhvLPbIk05RCVvtHMMMCTuzsmIxZi6J+OhnktaumGcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343383;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8rSfKDpNGP1keA4MNCrxJnsJP8eKl3cl3n+3Y3olPj4=;
	b=1UkLQh2X31a1f25qbuQsDce67/UoiKU/3nti7ixthl2C0x3OWNh39yfzMBnS4C08iHyR
	 Xkj0mUISN7t9WlxjVNDLFozwv22xyINcblTOAnjmLFhISmHps671zULtUKoWyFDhleqoK
	 Ic496EJF3GF55YWqOl7nmkuuNy3WluRqP5wV5ABL4Vy4Kyjg9cwKUI4msNdmgPrEhQjJt
	 KqPyHJ985j+mmKS60MSHM/0qJwMjoqGmD4Lokk9sj9fGORHlDqGogVatyZRPkUOeQtTdz
	 aoYmUKBToW8FWWsopErAoQ3KxfbrrKTKdaRi/Cpg0UKkcbzj9EDD3Ceu8V12QNwhV1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JTpn5rdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FC9606A32D;
	Fri, 30 Oct 2026 06:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JTpn5rdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E96F1F00A18;
	Fri, 30 Oct 2026 06:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793343383;
	bh=8rSfKDpNGP1keA4MNCrxJnsJP8eKl3cl3n+3Y3olPj4=;
	h=Date:To:From:Subject;
	b=JTpn5rdciwy5gvUNKpfZx9Jvm9Ono67GVqUThSRHYH8UBX5VfcV4Mpa5Tk/SutWkg
	 7j2XHWKC1yxrxj0UZIrKgrx/rZEUsuatMXR5yQ5o9eevLScjJu2HjWdNv3l5Nf7UQf
	 RWn5lYj3R+Xump4u1Ey4f4XJ6sQwD6nbajwWd0s4=
Date: Thu, 29 Oct 2026 23:56:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pjw@kernel.org,
	muchun.song@linux.dev,lkp@intel.com,glider@google.com,elver@google.com,
	dvyukov@google.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuyun01@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] riscv-keep-booting-if-kfence-pool-reservation-fails.patch removed from -mm tree
Message-Id: <20261030065623.2E96F1F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: riscv: keep booting if KFENCE pool reservation fails
has been removed from the -mm tree.  Its filename was
     riscv-keep-booting-if-kfence-pool-reservation-fails.patch

This patch was dropped because an updated version will be issued

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

