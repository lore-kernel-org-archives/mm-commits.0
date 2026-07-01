Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E79312832
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884021; cv=none; b=sj/5xDhB3n3SXgBCPMDIJTLfkouFoenVTyEzpncrNqsJTBHMImPMEuE1pBrouF9oiCCiqFLlUcygCKCHlM5DBQEZcZf49G/jTeIAbHT08FK9+fDvlvhstP5E6KTQY3yQ9mEsCvH4CqqRD8Skq1AemcZogD8HuSMOO8syEDdkobk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884021; c=relaxed/simple;
	bh=/EIlocr3EX+Ts4HGvgxIfT1aEU3rY+iTJLxI5J3w52A=;
	h=Date:To:From:Subject:Message-Id; b=EMg+6VuADMu/ZyvuoMHqy5a3KIF0iox0MzisdM+1QFPc6WdrOarEbyFgkvgHapNX1JQgsr9RSiKLetXkDk18VV/INsHV1fy89/N1SNdMnrWYMfOLFe1nvGApZfW8A54UeK0ln+vicUtyJyZiuUr5SR2DVo78MdtYOlzljhz1VcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jMOEGEvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jMOEGEvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E71F00A3A;
	Wed,  1 Jul 2026 05:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782884019;
	bh=KgJHOBWT2aW30JCfveS85z62zITj+NXzg9OoTezg2v4=;
	h=Date:To:From:Subject;
	b=jMOEGEvdvayMON0RMPhIYROZ76FY1LwUgVgm7ZG5VavWt8GBozSRVJiEsRt4uijHu
	 eC6YXniV4KmOlqJIlTYLEGw3ZaE1eStJBwX8jbmCZBUkL+sYPIG4HgAjtg59Zs3rxW
	 L9p1NV4b096ZzA3QLyFqLHVKvEVD9ZxSHRIWSGeM=
Date: Tue, 30 Jun 2026 22:33:39 -0700
To: mm-commits@vger.kernel.org,palmer@dabbelt.com,guoyaxing@bosc.ac.cn,david@kernel.org,alex@ghiti.fr,wangruikang@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-fix-concurrency-in-mark_new_valid_map.patch added to mm-nonmm-unstable branch
Message-Id: <20260701053339.AC5E71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: mm: fix concurrency in mark_new_valid_map()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-mm-fix-concurrency-in-mark_new_valid_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-fix-concurrency-in-mark_new_valid_map.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: riscv: mm: fix concurrency in mark_new_valid_map()
Date: Mon, 29 Jun 2026 17:25:45 +0800

Turns out, the concurrency concerns [1] were justified - BOSC reported a
spurious fault in KFENCE that still triggers despite previous fixes, which
KFENCE reports as a false-positive.

Fix the concurrency problems in mark_new_valid_map():

- Add smp_wmb() before filling the bitmap, to make sure page table
  writes are "received".
- Use WRITE_ONCE() to fill the bitmap.

This fixes the KFENCE false positives in internal testing.

Also update comments in the assembly exception handler code to match.

Link: https://lore.kernel.org/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn
Fixes: 26c171fc4853 ("riscv: mm: Use the bitmap API for new_valid_map_cpus")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Reported-by: Yaxing Guo <guoyaxing@bosc.ac.cn>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/linux-riscv/da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org/ # [1]
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand <david@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/cacheflush.h |   15 ++++++++++++++-
 arch/riscv/kernel/entry.S           |   11 ++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/arch/riscv/include/asm/cacheflush.h~riscv-mm-fix-concurrency-in-mark_new_valid_map
+++ a/arch/riscv/include/asm/cacheflush.h
@@ -6,7 +6,9 @@
 #ifndef _ASM_RISCV_CACHEFLUSH_H
 #define _ASM_RISCV_CACHEFLUSH_H
 
+#include <linux/array_size.h>
 #include <linux/mm.h>
+#include <asm/barrier.h>
 
 static inline void local_flush_icache_all(void)
 {
@@ -47,11 +49,22 @@ extern char _end[];
 static inline void mark_new_valid_map(void)
 {
 	/*
+	 * Orders any previous page table writes before setting bits in
+	 * new_valid_map_cpus. Pairs with the sfence.vma in
+	 * new_valid_map_cpus_check.
+	 */
+	smp_wmb();
+
+	/*
 	 * We don't care if concurrently a cpu resets this value since
 	 * the only place this can happen is in handle_exception() where
 	 * an sfence.vma is emitted.
+	 *
+	 * Not memset() or bitmap_fill() to avoid any possible compiler
+	 * shenanigans.
 	 */
-	bitmap_fill(new_valid_map_cpus, NR_CPUS);
+	for (size_t i = 0; i < ARRAY_SIZE(new_valid_map_cpus); i++)
+		WRITE_ONCE(new_valid_map_cpus[i], -1UL);
 }
 #define flush_cache_vmap flush_cache_vmap
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
--- a/arch/riscv/kernel/entry.S~riscv-mm-fix-concurrency-in-mark_new_valid_map
+++ a/arch/riscv/kernel/entry.S
@@ -76,6 +76,8 @@
 	amoxor.d	a0, a1, (a0)
 
 	/*
+	 * Pairs with the smp_wmb() in mark_new_valid_map()
+	 *
 	 * A sfence.vma is required here. Even if we had Svvptc, there's no
 	 * guarantee that after returning we wouldn't just fault again.
 	 */
@@ -141,13 +143,8 @@ SYM_CODE_START(handle_exception)
 	/*
 	 * The RISC-V kernel does not flush TLBs on all CPUS after each new
 	 * vmalloc mapping or kfence_unprotect(), which may result in
-	 * exceptions:
-	 *
-	 * - if the uarch caches invalid entries, the new mapping would not be
-	 *   observed by the page table walker and an invalidation is needed.
-	 * - if the uarch does not cache invalid entries, a reordered access
-	 *   could "miss" the new mapping and traps: in that case, we only need
-	 *   to retry the access, no sfence.vma is required.
+	 * exceptions. In that case, we need to sfence.vma to "receive" the new
+	 * mappings and retry, whether or not we have Svvptc.
 	 */
 	new_valid_map_cpus_check
 #endif
_

Patches currently in -mm which might be from wangruikang@iscas.ac.cn are

riscv-mm-fix-concurrency-in-mark_new_valid_map.patch
riscv-mm-avoid-spurious-fault-after-hotplugging-vmemmap.patch

