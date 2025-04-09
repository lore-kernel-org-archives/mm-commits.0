Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC9F29A2
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160862; cv=none; b=kn6JVVPXNipB52VQaZeQ58ajxUgebPb9D3vJrgMduLsdW6JFVJpZMsdqtjMSePKSx8T0wKTsGnESAyVASKzakrTbpgav7MyTl37hszVQptqk9uRBIgX1LvVsuIryw85ZrlvwhEV37VtgHXPKQIRtIAkZRM8RRUr2jAxw5VXYk0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160862; c=relaxed/simple;
	bh=ww/EbL6yqIZNXGrKtpUNYRrbNRBxDPGv53Vm3Vmj1PY=;
	h=Date:To:From:Subject:Message-Id; b=u1/Vgt4lB0MKYZSiel2Tq5D7HEoHQrLUg7yHBiT+zj3w0m3opLg3KMwZPs9gQL+gWMI6v6kh2owQ/yBQgZgDJ1dGrRDIpXMCrycydCRG6GTilDWYpbTbHfPMLg78BNZ4LjL7WKLOxlsMNoHT1GM0pX6g/7ESiMLJ53VxV+8qXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LLSW8tS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LLSW8tS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3F2C4CEE5;
	Wed,  9 Apr 2025 01:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160860;
	bh=ww/EbL6yqIZNXGrKtpUNYRrbNRBxDPGv53Vm3Vmj1PY=;
	h=Date:To:From:Subject:From;
	b=LLSW8tS826x0bdOorIjk/lo5l1LeIYPPjXnw6aaKGWSYGERiNKwKff4y1ijFpOoJx
	 N2Nux9jeKps0kR8NljOED71Ct5aclKvJ1qJBkc6e/cx2DWRnhWO5jwuuMqRCXT0afj
	 ky54diilUEwl641vgS6ogpbhQEhVoTVCuF9Nvf8E=
Date: Tue, 08 Apr 2025 18:07:39 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-ptlock_init-for-kernel-pmds.patch added to mm-new branch
Message-Id: <20250409010740.9D3F2C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip ptlock_init() for kernel PMDs
has been added to the -mm mm-new branch.  Its filename is
     mm-skip-ptlock_init-for-kernel-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-ptlock_init-for-kernel-pmds.patch

This patch will later appear in the mm-new branch at
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: skip ptlock_init() for kernel PMDs
Date: Tue, 8 Apr 2025 10:52:17 +0100

Split page table locks are not used for pgtables associated to init_mm, at
any level.  pte_alloc_kernel() does not call ptlock_init() as a result. 
There is however no separate alloc/free functions for kernel PMDs, and
pmd_ptlock_init() is called unconditionally.  When ALLOC_SPLIT_PTLOCKS is
true (e.g.  32-bit architectures or if CONFIG_PREEMPT_RT is selected),
this results in unnecessary dynamic memory allocation every time a kernel
PMD is allocated.

Now that pagetable_pmd_ctor() is passed the associated mm, we can easily
remove this overhead by skipping pmd_ptlock_init() if the pgtable is
associated to init_mm.  No special-casing is needed on the dtor path, as
ptlock_free() is already called unconditionally for all levels. 
(ptlock_free() is a no-op unless a ptlock was allocated for the given
PTP.)

Link: https://lkml.kernel.org/r/20250408095222.860601-8-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-skip-ptlock_init-for-kernel-pmds
+++ a/include/linux/mm.h
@@ -3240,7 +3240,7 @@ static inline spinlock_t *pmd_lock(struc
 static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (!pmd_ptlock_init(ptdesc))
+	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
 	__pagetable_ctor(ptdesc);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-pass-mm-down-to-pagetable_ptepmd_ctor.patch
x86-pgtable-always-use-pte_free_kernel.patch
mm-call-ctor-dtor-for-kernel-ptes.patch
m68k-mm-call-ctor-dtor-for-kernel-ptes.patch
powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch
sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch
mm-skip-ptlock_init-for-kernel-pmds.patch
arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch
arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch
riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch
arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch
riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

