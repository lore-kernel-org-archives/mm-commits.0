Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DCA4AF80
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 21:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2IKeuNzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D3AC433C7;
	Wed, 20 Dec 2023 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108498;
	bh=3AlHt8tF3p3xDZHILBG6fhyX+1LLd0AhQnRI3yxERUc=;
	h=Date:To:From:Subject:From;
	b=2IKeuNzFo5+PS0k+r/8KU1BaNxFEu3pGBedCiU+h79iY1Xfe9YeBxEx+P7RROSoCf
	 cndWClmpZ2xTQ/knFHBl1NrwP9tBKx0/29CTmzO8bhMg5s9vnmuUONb1hSk3Tb6yDw
	 5qsEKj8hJerVj69YORVZmSIb1xC+Lr8O7++Wlv48=
Date: Wed, 20 Dec 2023 13:41:37 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,svens@linux.ibm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,eric_devolder@yahoo.com,davem@davemloft.net,dave.hansen@linux.intel.com,conor@kernel.org,christophe.leroy@csgroup.eu,bp@alien8.de,borntraeger@linux.ibm.com,ardb@kernel.org,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec-fix-kexec_file-dependencies-fix.patch removed from -mm tree
Message-Id: <20231220214138.21D3AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec-fix-kexec_file-dependencies-fix
has been removed from the -mm tree.  Its filename was
     kexec-fix-kexec_file-dependencies-fix.patch

This patch was dropped because it was folded into kexec-fix-kexec_file-dependencies.patch

------------------------------------------------------
From: "Arnd Bergmann" <arnd@arndb.de>
Subject: kexec-fix-kexec_file-dependencies-fix
Date: Mon, 23 Oct 2023 18:04:06 +0200

fix riscv build

Link: https://lkml.kernel.org/r/67ddd260-d424-4229-a815-e3fcfb864a77@app.fastmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
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

 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig~kexec-fix-kexec_file-dependencies-fix
+++ a/arch/riscv/Kconfig
@@ -702,7 +702,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select KEXEC_ELF
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool y
+	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
mips-fix-r3k_cache_init-build-regression.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

