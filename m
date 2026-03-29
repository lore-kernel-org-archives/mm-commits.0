Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BD22E54AA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 22:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774824358; cv=none; b=RF3O5wOeNuVanIJ/RozxTudbZdT53yUhdLyJVF+ogjLxGHSFOEfHDs1Ve5g/30DaAlq8JunjdqD2BoyjF9SLU94h+0kCP0tWa3sWdhm0w789wOhnasHddPyPL/etzWQeatP1RniMRCbFm/ESt6H3XrMUBzwuRSHjh6o0lCsv2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774824358; c=relaxed/simple;
	bh=Cqtgm5/FcY0hssbZSkq1haBdPUrfVJk2pjzAUcd7e18=;
	h=Date:To:From:Subject:Message-Id; b=URlMLLsdimAr8EO89cAuZSpnYC4w2VVBpInJbL7HUeuTU95SbQEhzIp68EsXE0yi92HOlDTuWIeqD4Hio3b6jsC7KFqhY5Os/RAHYyi99WL9TFlzqGVa+hVxN54pbpDcFmtL+iSQeqq5Wvy+B+exA/jWl96ZrmWl4R/Alfz1nEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIRVF4dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIRVF4dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260E8C116C6;
	Sun, 29 Mar 2026 22:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774824358;
	bh=Cqtgm5/FcY0hssbZSkq1haBdPUrfVJk2pjzAUcd7e18=;
	h=Date:To:From:Subject:From;
	b=JIRVF4dMOY+CTzdbUDtf4qSOaT2/pB/u95ObbGJQqTTVq6wNZVl6UntHQqaTE/0wN
	 ufA4Ha+Z6LrM0CNQ4t/GX7A26disLDRldVbeAR6MmsdKgRCtfDFd42mgCSJFbw5WxO
	 ouAClCakgbimFnkNUe5ZuCJkKaL4MZ2J1dL/C4uo=
Date: Sun, 29 Mar 2026 15:45:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] xor-add-a-better-public-api-2.patch removed from -mm tree
Message-Id: <20260329224558.260E8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: add a better public API
has been removed from the -mm tree.  Its filename was
     xor-add-a-better-public-api-2.patch

This patch was dropped because it was folded into xor-add-a-better-public-api.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: add a better public API
Date: Fri, 27 Mar 2026 07:16:55 +0100

xor_blocks is very annoying to use, because it is limited to 4 + 1 sources
/ destinations, has an odd argument order and is completely undocumented.

Lift the code that loops around it from btrfs and async_tx/async_xor into
common code under the name xor_gen and properly document it.

Link: https://lkml.kernel.org/r/20260327061704.3707577-24-hch@lst.de
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

 lib/raid/xor/xor-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/raid/xor/xor-core.c~xor-add-a-better-public-api-2
+++ a/lib/raid/xor/xor-core.c
@@ -65,6 +65,8 @@ void xor_gen(void *dest, void **srcs, un
 {
 	unsigned int src_off = 0;
 
+	WARN_ON_ONCE(in_interrupt());
+	WARN_ON_ONCE(bytes == 0);
 	WARN_ON_ONCE(bytes & 511);
 
 	while (src_cnt > 0) {
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
async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

