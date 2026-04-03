Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6493C326D73
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198490; cv=none; b=e/1ccA5mwNfzz+Otba4r/gYdsrtoxItUr/tNnoFGYdlUBkLdoYwpUtTV0tvFX/LJzjZt3MAVFTJiWMRwKhhLE3D4pYD5OiASll9xKByP4WLsKqm/pN5RJ0WR/f31DHT5MBlGuJWQAcXcvQGMsYEWjIlsPfDSw/k/PHzfAws0fkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198490; c=relaxed/simple;
	bh=r1T44YSCO2E2rpfETHGeYqsMoJgdkxDOWYT4haGprjA=;
	h=Date:To:From:Subject:Message-Id; b=HxEpxtb2arNL9IzNtSmAq5Cvguarr329Nvmo+i5MMSTULb2k7Zbod7j9+wJxY2v2xoQjz9hA8CPkPr0jnIhjAE4pqIb0OQCvroTiyUTwern/O0MOPbHoiz+4HdfFMmAmQP0qKzyTRI0jht0fdkFy1VETbrI+wCPdpjkv7hN1+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PywzaLCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PywzaLCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BBDC4CEF7;
	Fri,  3 Apr 2026 06:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198490;
	bh=r1T44YSCO2E2rpfETHGeYqsMoJgdkxDOWYT4haGprjA=;
	h=Date:To:From:Subject:From;
	b=PywzaLCfkJcaNdq6Tepgy1xMQD7+cuqcBGHLIOJy8hLwmcShe1CzOAF1sM9+A8sLg
	 6JJdg0o5r013E95ezldZ5MnqRwru535VAuAf+lqsvD7LtQzUYkzDG5NNZln4pkHVUC
	 RSs7BYhiHD/3n4PNc+cOtsnOPYFdC+907teKrHpk=
Date: Thu, 02 Apr 2026 23:41:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch removed from -mm tree
Message-Id: <20260403064130.36BBDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/xor: fix conflicting attributes for xor_block_template
has been removed from the -mm tree.  Its filename was
     arm64-xor-fix-conflicting-attributes-for-xor_block_template.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


