Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A974F372B32
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633763; cv=none; b=C3Rb+bZecd204KaOYZaQYfLjbSQidkjVVETThdytsimxwt8ZX/onjd6FdIebryUPrjHKdGk285uzZ0vGScNEspJbMcTrJOWLSTP62EvfzfAuSyn4leG11Zy6PPcNPd3ZIAUYQCsmiz+OJcN8DzPyZecGGOb8nYoVE+BRRPC6q4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633763; c=relaxed/simple;
	bh=jpzofBPIfLdgTByKHjuNzA9cbbAURHCcE3t5wlxCPeI=;
	h=Date:To:From:Subject:Message-Id; b=PtYpXpg4yYlo6dD7qlsrrebTcsPER4LFijoYiRQeOlG8rPpYDo45dNy2P9GkVBqL0SZ6ODmNvxcLWb5ayTkT6OmjEkrNoADu29P4OtFIpYmGfY6yGA1RI4BsNNkKxauSDhFhqdkzP6uD/kXYTJwh8B6XSXOJdD3zyW63CeHJMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6TxIHx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6TxIHx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48806C19423;
	Fri, 27 Mar 2026 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633763;
	bh=jpzofBPIfLdgTByKHjuNzA9cbbAURHCcE3t5wlxCPeI=;
	h=Date:To:From:Subject:From;
	b=E6TxIHx3C61el8A+v43Vbm/l/4zbMHOCy2M5e655uHq7AT0k6Ae23PcJVguXWQ3LH
	 5Hr3mx8cRrlwGWcnjmUi4DHo5Yfc6DSUSoNJF/oL8ySI33jAI+bNTwF2uAt5Rjje/1
	 fIPIDrbw58Z22mjFcplGwHfkynE/QYi858UMSzr0=
Date: Fri, 27 Mar 2026 10:49:22 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch added to mm-nonmm-unstable branch
Message-Id: <20260327174923.48806C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: assert that xor_blocks is not call from interrupt context
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch

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
Subject: xor: assert that xor_blocks is not call from interrupt context
Date: Fri, 27 Mar 2026 07:16:33 +0100

Patch series "cleanup the RAID5 XOR library", v4.

The XOR library used for the RAID5 parity is a bit of a mess right now. 
The main file sits in crypto/ despite not being cryptography and not using
the crypto API, with the generic implementations sitting in
include/asm-generic and the arch implementations sitting in an asm/ header
in theory.  The latter doesn't work for many cases, so architectures often
build the code directly into the core kernel, or create another module for
the architecture code.

Change this to a single module in lib/ that also contains the architecture
optimizations, similar to the library work Eric Biggers has done for the
CRC and crypto libraries later.  After that it changes to better calling
conventions that allow for smarter architecture implementations (although
none is contained here yet), and uses static_call to avoid indirection
function call overhead.


This patch (of 28):

Most of the optimized xor_blocks versions require FPU/vector registers,
which generally are not supported in interrupt context.

Both callers already are in user context, so enforce this at the highest
level.

Link: https://lkml.kernel.org/r/20260327061704.3707577-1-hch@lst.de
Link: https://lkml.kernel.org/r/20260327061704.3707577-2-hch@lst.de
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

 crypto/xor.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/xor.c~xor-assert-that-xor_blocks-is-not-call-from-interrupt-context
+++ a/crypto/xor.c
@@ -28,6 +28,8 @@ xor_blocks(unsigned int src_count, unsig
 {
 	unsigned long *p1, *p2, *p3, *p4;
 
+	WARN_ON_ONCE(!in_task() || irqs_disabled() || softirq_count());
+
 	p1 = (unsigned long *) srcs[0];
 	if (src_count == 1) {
 		active_template->do_2(bytes, dest, p1);
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

