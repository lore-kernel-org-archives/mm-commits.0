Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AE3783C4
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633768; cv=none; b=jffKrnRdY02PVjbw+u0I3K5bxCFaub+Ni46qjKG4QkRWT5Dx4HK2NKCBb9oK9hec35MhF9mssFVUFFHfbLkjOAfkkRcGrg7K6rHZs56jgtsHD08Qc+WLLg2Ga4VOwO1HgIvaXZRiXKbuEv4LwpCU2i1D3bv3pcw2umY9NWXWlNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633768; c=relaxed/simple;
	bh=z9aZqFX2iFuzdkxMr/kZ2hZBaW/4gWJT/KHvsv0XJXE=;
	h=Date:To:From:Subject:Message-Id; b=FUD6marbNv+NzMAsa8jVO3xlLoHGpA8snrJlyMzd1+SvxK/wQ83zcYiIL4aS+U3ahtpvdgCSJIpnrjtdlH5FJuONi1YtdO0jAviq6/n7D/ceLFA1toUFNAEBDBTIso0Ya+eUTlldhDdJmzvh4d7SrIXDbb7nPv6l3HaC0l/bABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r09DzrGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r09DzrGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D093C19423;
	Fri, 27 Mar 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633768;
	bh=z9aZqFX2iFuzdkxMr/kZ2hZBaW/4gWJT/KHvsv0XJXE=;
	h=Date:To:From:Subject:From;
	b=r09DzrGPlXlPG8AKacSfTcDx9qz8gCYmF6/P1tPntRwYfvoC73kLdyW1PDN1O3ptc
	 bhHi0gEF8ueVuAXv6d0/Ydg4zR171UBuxCWWlqphj7LcI7riVT11ACjGWaAEl27vvw
	 8PjNuYNplh73Bq/O+skHvmMMYh5t/EVj5Du12Vx4=
Date: Fri, 27 Mar 2026 10:49:27 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch added to mm-nonmm-unstable branch
Message-Id: <20260327174928.4D093C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/xor: fix conflicting attributes for xor_block_template
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: arm64/xor: fix conflicting attributes for xor_block_template
Date: Fri, 27 Mar 2026 07:16:35 +0100

Commit 2c54b423cf85 ("arm64/xor: use EOR3 instructions when available")
changes the definition to __ro_after_init instead of const, but failed to
update the external declaration in xor.h.  This was not found because
xor-neon.c doesn't include <asm/xor.h>, and can't easily do that due to
current architecture of the XOR code.

Link: https://lkml.kernel.org/r/20260327061704.3707577-4-hch@lst.de
Fixes: 2c54b423cf85 ("arm64/xor: use EOR3 instructions when available")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Sterba <dsterba@suse.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/xor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/xor.h~arm64-xor-fix-conflicting-attributes-for-xor_block_template
+++ a/arch/arm64/include/asm/xor.h
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 
-extern struct xor_block_template const xor_block_inner_neon;
+extern struct xor_block_template xor_block_inner_neon __ro_after_init;
 
 static void
 xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
_

Patches currently in -mm which might be from hch@lst.de are

xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch
arm-xor-remove-in_interrupt-handling.patch
arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch
um-xor-cleanup-xorh.patch
xor-move-to-lib-raid.patch
xor-small-cleanups.patch
xor-cleanup-registration-and-probing.patch
xor-split-xorh.patch
xor-remove-macro-abuse-for-xor-implementation-registrations.patch
xor-move-generic-implementations-out-of-asm-generic-xorh.patch
alpha-move-the-xor-code-to-lib-raid.patch
arm-move-the-xor-code-to-lib-raid.patch
arm64-move-the-xor-code-to-lib-raid.patch
loongarch-move-the-xor-code-to-lib-raid.patch
powerpc-move-the-xor-code-to-lib-raid.patch
riscv-move-the-xor-code-to-lib-raid.patch
sparc-move-the-xor-code-to-lib-raid.patch
s390-move-the-xor-code-to-lib-raid.patch
x86-move-the-xor-code-to-lib-raid.patch
xor-avoid-indirect-calls-for-arm64-optimized-ops.patch
xor-make-xorko-self-contained-in-lib-raid.patch
xor-add-a-better-public-api.patch
xor-add-a-better-public-api-2.patch
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

