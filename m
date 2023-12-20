Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39A481C3
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PDQVLdp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490FCC433C7;
	Wed, 20 Dec 2023 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108831;
	bh=crZumqYTt7qVmVRwP+tlguVwuP8+/edxkqbKusdb1OQ=;
	h=Date:To:From:Subject:From;
	b=PDQVLdp9Mc3Y+tPNcGLqTgk4AA7XrUF2TvwfIOYJbkm0/Sj82mN468wljoG14eh5D
	 tuyhKN069CA5DTc0a8unt+xQe+yRKmib1vu42MYCypN1amMrhsJISFKmwhfa+bNaw1
	 vLmvxBiENnfr2ZfTRWEu/J0V5oKT6UnA0lb+Rqb4=
Date: Wed, 20 Dec 2023 13:47:10 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,svens@linux.ibm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,eric_devolder@yahoo.com,davem@davemloft.net,dave.hansen@linux.intel.com,conor@kernel.org,christophe.leroy@csgroup.eu,bp@alien8.de,borntraeger@linux.ibm.com,bhe@redhat.com,ardb@kernel.org,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch removed from -mm tree
Message-Id: <20231220214711.490FCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: select CRYPTO from KEXEC_FILE instead of depending on it
has been removed from the -mm tree.  Its filename was
     kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kexec: select CRYPTO from KEXEC_FILE instead of depending on it
Date: Mon, 23 Oct 2023 13:01:55 +0200

All other users of crypto code use 'select' instead of 'depends on', so do
the same thing with KEXEC_FILE for consistency.

In practice this makes very little difference as kernels with kexec
support are very likely to also include some other feature that already
selects both crypto and crypto_sha256, but being consistent here helps for
usability as well as to avoid potential circular dependencies.

This reverts the dependency back to what it was originally before commit
74ca317c26a3f ("kexec: create a new config option CONFIG_KEXEC_FILE for
new syscall"), which changed changed it with the comment "This should be
safer as "select" is not recursive", but that appears to have been done in
error, as "select" is indeed recursive, and there are no other
dependencies that prevent CRYPTO_SHA256 from being selected here.

Link: https://lkml.kernel.org/r/20231023110308.1202042-2-arnd@kernel.org
Fixes: 74ca317c26a3f ("kexec: create a new config option CONFIG_KEXEC_FILE for new syscall")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/Kconfig.kexec~kexec-select-crypto-from-kexec_file-instead-of-depending-on-it
+++ a/kernel/Kconfig.kexec
@@ -36,7 +36,8 @@ config KEXEC
 config KEXEC_FILE
 	bool "Enable kexec file based system call"
 	depends on ARCH_SUPPORTS_KEXEC_FILE
-	depends on CRYPTO_SHA256=y || !ARCH_SUPPORTS_KEXEC_PURGATORY
+	select CRYPTO
+	select CRYPTO_SHA256
 	select KEXEC_CORE
 	help
 	  This is new version of kexec system call. This system call is
_

Patches currently in -mm which might be from arnd@arndb.de are

mips-fix-r3k_cache_init-build-regression.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

