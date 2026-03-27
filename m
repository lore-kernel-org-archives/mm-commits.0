Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F2363084
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633886; cv=none; b=ccLGC65ykTKjy3t2R0/spqhwS2vL+HT4GfqNk6f+ImtXuY/y6SPoACK0Y4/FOXNKi92bdO3ZGdDAK6VC7EK/pdJjHLVu0z9/kWxEDTXOnprJ5QV/Qf4wnvUixM8pltrz6HQVFPUecqbHsiSdW6aIRBRmgJwJMzv/N7QkdewmbqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633886; c=relaxed/simple;
	bh=qY5TXHm4pfspA8LHkKMisT5MdrC1antCujxSBcB/5NQ=;
	h=Date:To:From:Subject:Message-Id; b=KHtUKUmmkkoGiwKbgDYPiW8QzJ/o+eyHc4pCHLD6QOVkEeaqVQD8B7y8BfkyRrKomrosOSh+GAMt7iElh0x0jkWSJ7M98ooDHUlQYpJE8A/ntGMOM9YCsaJIggteQXdoHTdCrtzxlS8V/8BS5Zpme2y4vBXOwz6EnZdy7J6g4Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXnmNSkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXnmNSkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F702C19423;
	Fri, 27 Mar 2026 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774633886;
	bh=qY5TXHm4pfspA8LHkKMisT5MdrC1antCujxSBcB/5NQ=;
	h=Date:To:From:Subject:From;
	b=wXnmNSkmCLpniT8U7QKDc6nGpJ5OwVQ+Zaxg1Km2hTvQh8F335FpX6UiFLrtDvOGF
	 VcRZiuXDvoEvxuDN3mUF80wQ9nqmtHbzfoUhdoO4+nSASfoRGAg0auWdZqpFvG9Lrz
	 U3q7jDl3az6h7rXajeOFvkTtpap8IMtrSjU/Qo2M=
Date: Fri, 27 Mar 2026 10:51:25 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-add-a-better-public-api.patch added to mm-nonmm-unstable branch
Message-Id: <20260327175126.0F702C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: add a better public API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-add-a-better-public-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-add-a-better-public-api.patch

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
Subject: xor: add a better public API
Date: Fri, 27 Mar 2026 07:16:54 +0100

xor_blocks is very annoying to use, because it is limited to 4 + 1 sources
/ destinations, has an odd argument order and is completely undocumented.

Lift the code that loops around it from btrfs and async_tx/async_xor into
common code under the name xor_gen and properly document it.

Link: https://lkml.kernel.org/r/20260327061704.3707577-23-hch@lst.de
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

 include/linux/raid/xor.h |    2 ++
 lib/raid/xor/xor-core.c  |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/raid/xor.h~xor-add-a-better-public-api
+++ a/include/linux/raid/xor.h
@@ -7,4 +7,6 @@
 extern void xor_blocks(unsigned int count, unsigned int bytes,
 	void *dest, void **srcs);
 
+void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes);
+
 #endif /* _XOR_H */
--- a/lib/raid/xor/xor-core.c~xor-add-a-better-public-api
+++ a/lib/raid/xor/xor-core.c
@@ -46,6 +46,38 @@ xor_blocks(unsigned int src_count, unsig
 }
 EXPORT_SYMBOL(xor_blocks);
 
+/**
+ * xor_gen - generate RAID-style XOR information
+ * @dest:	destination vector
+ * @srcs:	source vectors
+ * @src_cnt:	number of source vectors
+ * @bytes:	length in bytes of each vector
+ *
+ * Performs bit-wise XOR operation into @dest for each of the @src_cnt vectors
+ * in @srcs for a length of @bytes bytes.  @src_cnt must be non-zero, and the
+ * memory pointed to by @dest and each member of @srcs must be at least 64-byte
+ * aligned.  @bytes must be non-zero and a multiple of 512.
+ *
+ * Note: for typical RAID uses, @dest either needs to be zeroed, or filled with
+ * the first disk, which then needs to be removed from @srcs.
+ */
+void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes)
+{
+	unsigned int src_off = 0;
+
+	WARN_ON_ONCE(bytes & 511);
+
+	while (src_cnt > 0) {
+		unsigned int this_cnt = min(src_cnt, MAX_XOR_BLOCKS);
+
+		xor_blocks(this_cnt, bytes, dest, srcs + src_off);
+
+		src_cnt -= this_cnt;
+		src_off += this_cnt;
+	}
+}
+EXPORT_SYMBOL(xor_gen);
+
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
 static bool __initdata xor_forced = false;
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

