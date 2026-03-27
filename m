Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06726364E9C
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632699; cv=none; b=Sar/gb7Us2iq7c868RvNBUzT5VFO3zrDvPpIOuAqvefX+RqG8ac9zEmHI25u4ZBnIseqxdY+shK/gC8uWS5o/1mupT63yWz81idy0dwcHvct7VbOE/WR5nL7nyBh6tKAQpRJEhGnCBCyqIDWLAxqRMOy8YstgFfJPiPtYR1LwsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632699; c=relaxed/simple;
	bh=cVzejXKywjuUlHr3YRyV4rSCkUzqlG0r4q2rZInTnhU=;
	h=Date:To:From:Subject:Message-Id; b=IwvzDcLRLj24njHnKOP8M9pV+3wvmsmPNS0YUD/Zf6I6IovfVZ2vTtyqfARmzOmgFKfpQ0AYIUgQxofLmA6yfPY4QFXwOmS06f3/CW4DGLim2rtHIFhnyw/zdCIkTTTyutPRV3nXZpY+rpvkv9rGhsh4lc7E4dPUxzTDG3XikKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RwvTRuKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RwvTRuKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FA9C19423;
	Fri, 27 Mar 2026 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632698;
	bh=cVzejXKywjuUlHr3YRyV4rSCkUzqlG0r4q2rZInTnhU=;
	h=Date:To:From:Subject:From;
	b=RwvTRuKJT5PN508RxgucPRrjLuJ8s1lE7dmvojTfro5CZ87riik8w4LWMAaJW9UTQ
	 1h1V8xPVjF2oDQRzckY4uIo0HvUADQHuh1EFWi99gqKKG9GfObTINarERuS18H3p+5
	 HWuR1bhFKaZpc3Stsc2l7vBxMKhd4rFo7Aimm0M0=
Date: Fri, 27 Mar 2026 10:31:37 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-assert-that-xor_blocks-is-not-from-preemptible-user-context.patch removed from -mm tree
Message-Id: <20260327173138.58FA9C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: assert that xor_blocks is not from preemptible user context
has been removed from the -mm tree.  Its filename was
     xor-assert-that-xor_blocks-is-not-from-preemptible-user-context.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: assert that xor_blocks is not from preemptible user context
Date: Tue, 24 Mar 2026 07:21:37 +0100

Patch series "cleanup the RAID5 XOR library", v3.

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


This patch (of 26):

Most of the optimized xor_blocks versions require FPU/vector registers,
which generally are not supported in interrupt context.

Both callers already are in user context, so enforce this at the highest
level.

Link: https://lkml.kernel.org/r/20260324062211.3216301-1-hch@lst.de
Link: https://lkml.kernel.org/r/20260324062211.3216301-2-hch@lst.de
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

--- a/crypto/xor.c~xor-assert-that-xor_blocks-is-not-from-preemptible-user-context
+++ a/crypto/xor.c
@@ -28,6 +28,8 @@ xor_blocks(unsigned int src_count, unsig
 {
 	unsigned long *p1, *p2, *p3, *p4;
 
+	lockdep_assert_preemption_enabled();
+
 	p1 = (unsigned long *) srcs[0];
 	if (src_count == 1) {
 		active_template->do_2(bytes, dest, p1);
_

Patches currently in -mm which might be from hch@lst.de are

arm-xor-remove-in_interrupt-handling.patch
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
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

