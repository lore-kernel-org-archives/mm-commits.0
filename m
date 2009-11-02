From: akpm@linux-foundation.org
Subject: [merged] crypto-add-pclmulqdq-accelerated-ghash-implementation-fix.patch removed from -mm tree
Date: Mon, 02 Nov 2009 12:45:30 -0800
Message-ID: <200911022045.nA2KjUfG001697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357AbZKBUqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 15:46:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     crypto: Add PCLMULQDQ accelerated GHASH implementation (fix)
has been removed from the -mm tree.  Its filename was
     crypto-add-pclmulqdq-accelerated-ghash-implementation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto: Add PCLMULQDQ accelerated GHASH implementation (fix)
From: Herbert Xu <herbert@gondor.apana.org.au>

On Sat, Oct 31, 2009 at 05:30:15PM -0700, Andrew Morton wrote:
>
> x86_64 allmodconfig, GNU assembler 2.16.1:
>
> arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
> arch/x86/crypto/ghash-clmulni-intel_asm.S:103: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:105: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:119: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:123: Error: no such instruction: `pshufb %xmm5,%xmm6'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:130: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:143: Error: no such instruction: `pshufb %xmm5,%xmm0'

This patch should fix it.

commit 2d06ef7f42ed8c9969c9aa84e95df5d5c6378327
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Nov 1 12:49:44 2009 -0500

    crypto: ghash-intel - Hard-code pshufb

    Old gases don't have a clue what pshufb stands for so we have
    to hard-code it for now.

    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

index b9e787a..71768d5 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/crypto/ghash-clmulni-intel_asm.S |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/x86/crypto/ghash-clmulni-intel_asm.S~crypto-add-pclmulqdq-accelerated-ghash-implementation-fix arch/x86/crypto/ghash-clmulni-intel_asm.S
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S~crypto-add-pclmulqdq-accelerated-ghash-implementation-fix
+++ a/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -100,9 +100,11 @@ ENTRY(clmul_ghash_mul)
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	call __clmul_gf128mul_ble
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movups DATA, (%rdi)
 	ret
 
@@ -116,18 +118,21 @@ ENTRY(clmul_ghash_update)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 .align 4
 .Lupdate_loop:
 	movups (%rsi), IN1
-	pshufb BSWAP, IN1
+	# pshufb BSWAP, IN1
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xf5
 	pxor IN1, DATA
 	call __clmul_gf128mul_ble
 	sub $16, %rdx
 	add $16, %rsi
 	cmp $16, %rdx
 	jge .Lupdate_loop
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
@@ -140,7 +145,8 @@ ENTRY(clmul_ghash_update)
 ENTRY(clmul_ghash_setkey)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rsi), %xmm0
-	pshufb BSWAP, %xmm0
+	# pshufb BSWAP, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movaps %xmm0, %xmm1
 	psllq $1, %xmm0
 	psrlq $63, %xmm1
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

