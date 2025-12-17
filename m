Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D0288C96
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995899; cv=none; b=KYC+v++ISfVMH4K3MhnpVfM/nu73q1I+JbkmE8IdjJeniIdMhy8I7zkGQ6Y/PUx+HBM2R4/19PpyC9b/YYEK1o134p3r0YlLdxMr+Wg4gPPdI1U4byBa8p/ZLgMvIoyR2Mvidyt4xlm4kQh2XaNOM0hrDJWE83ks14qfUkRPYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995899; c=relaxed/simple;
	bh=HSn6YsybmbDm8Fag79AYwfx64mw1a24+1QNiXc9aN8Y=;
	h=Date:To:From:Subject:Message-Id; b=SF6NAheCjw0m/RUWKJ67Yp+Po6OwuqRB0ULopIRDNaRZdkyQdNmu1ddTHMsQzey3tf1s16Dh0OMekxuSr8aEnGilX/Mr5wVfKtAJ50MNNm+au2pE5N6JleP/RL4B+7YR56Jtz9BVCNq2GlWS5UfJCfh81DVDZ/L/T1BATIxGSHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lo/jetVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lo/jetVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DE9C4CEF5;
	Wed, 17 Dec 2025 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995899;
	bh=HSn6YsybmbDm8Fag79AYwfx64mw1a24+1QNiXc9aN8Y=;
	h=Date:To:From:Subject:From;
	b=lo/jetVGRYMfVJQ98qwSLd5DWp29L1gFK4DI2MvRUy+6hFGcHhwpFtb2lhPwZ1N0Q
	 q5zBA8B7lHUE98FHTolSmsgaeWIXlPQxbvml7/S2dOVOBu/acOIkR+cGPCmn1LdBTQ
	 j4mLTRGi4ZrFRly+aW9+QNgF4E9MdQV4I6AnYM8U=
Date: Wed, 17 Dec 2025 10:24:58 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tsbogend@alpha.franken.de,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mattst88@gmail.com,linmag7@gmail.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,chenhuacai@kernel.org,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch added to mm-new branch
Message-Id: <20251217182459.44DE9C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
has been added to the -mm mm-new branch.  Its filename is
     mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:48 +0800

PT_RECLAIM can work on all architectures that support
MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
MMU_GATHER_RCU_TABLE_FREE.

BTW, change PT_RECLAIM to be enabled by default, since nobody should want
to turn it off.

Link: https://lkml.kernel.org/r/ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 mm/Kconfig       |    9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/x86/Kconfig~mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free
+++ a/arch/x86/Kconfig
@@ -331,7 +331,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
--- a/mm/Kconfig~mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free
+++ a/mm/Kconfig
@@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
-	bool "reclaim empty user page table pages"
-	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
-	select MMU_GATHER_RCU_TABLE_FREE
+	def_bool y
+	depends on MMU_GATHER_RCU_TABLE_FREE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

