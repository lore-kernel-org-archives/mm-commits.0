Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B691A282F33
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198486; cv=none; b=WnSDr6s8M2/h+2qIMCgzSQdfJQKdvC0YGNoWe2tx8BvhkR5CyDWRi36y9pqrZIPSa0pN3FsRdFOMVy2n2jzMTlptfTqob3qJsvQGyULGBmtZukURiuDJLJS0YG9o9IOkGSfGjfGxTOAh4o8/qgysISBtu7WMyk8q42ByXjIjg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198486; c=relaxed/simple;
	bh=mN4gVU8+R8tlIS69yGiNV9PiuVa4FnDSalobD934cL8=;
	h=Date:To:From:Subject:Message-Id; b=u3iAAcHz7JoLkztLsI3ABZzj1c2s4xMTzCn1JzwUN1fX+06iSYimfkEjNeVW/TO+cxPxonTGFVZ1KViq+h4H/9f+Kq4hqsOWcNJrLrFiUddd+LDz+lXiCMnjA51XT1LIFYnz/2NAqykIvEEXf5u2oBkH5qbQkNeJ/bbLENjGIdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iUwje+5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iUwje+5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C115C4CEF7;
	Fri,  3 Apr 2026 06:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198486;
	bh=mN4gVU8+R8tlIS69yGiNV9PiuVa4FnDSalobD934cL8=;
	h=Date:To:From:Subject:From;
	b=iUwje+5Gr1/5DaL7vTkhIcT3HjGFd1Rm0VWwNas6DbDW9Go5xlgjLgsjjm4xQt0l/
	 WSzZzdyBEvZzQS/VhO92Jjshesdr+ttimTMpjjmARWxaewF4td2SzNGZ+/f1eE9x3+
	 Egolvhow4CCEuucSrd/DtAp7tAvBQzR1BQQPZCSA=
Date: Thu, 02 Apr 2026 23:41:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch removed from -mm tree
Message-Id: <20260403064126.6C115C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: assert that xor_blocks is not call from interrupt context
has been removed from the -mm tree.  Its filename was
     xor-assert-that-xor_blocks-is-not-call-from-interrupt-context.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


This patch (of 27):

Most of the optimized xor_blocks versions require FPU/vector registers,
which generally are not supported in interrupt context.

Both callers already are in user context, so enforce this at the highest
level.

Link: https://lkml.kernel.org/r/20260327061704.3707577-1-hch@lst.de
Link: https://lkml.kernel.org/r/20260327061704.3707577-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
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


