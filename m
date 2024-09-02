Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E391A1388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248770; cv=none; b=kLcGYiijZ/ywHzJUFaR8B/XWEwr+NccOKt7BE4INfQyvvnWcJ+Uf4D5GBMg5mGI2Rkz5LFQrCmcMW8I9slcLygnqwsHO+g74KDgGQjvsvxfkVAANbaEkozPakf/Q9nCCPdmPy5qFDoAPsZl8GWGoy+4X/GuDb4y0vl2pNwippBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248770; c=relaxed/simple;
	bh=dEyV8R7BEMZz7uj7971DMvYu9MqlXZJNahC9oQwxy0s=;
	h=Date:To:From:Subject:Message-Id; b=DNhmmNGU0h7dVnQfIk3xZYvyPzpnuQrIcCcuqG1QDAbUhsO9mVfifVYCmpqc9sKDT8ObIuL0znLx3B8gbmX6nxJbZSnIVXYOpv7lDUJWKlAsKs6xAdKYH5TbwEuEBJLRQMRx92C5LvIJ+80qV/Imh3092k2wl0JYKm1DBKGRvHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1GN9mKw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1GN9mKw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5D0C4CEC2;
	Mon,  2 Sep 2024 03:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248769;
	bh=dEyV8R7BEMZz7uj7971DMvYu9MqlXZJNahC9oQwxy0s=;
	h=Date:To:From:Subject:From;
	b=1GN9mKw1CKY62ttE4JckGyD0HeHCOGlfYxBjOS56/0wBLI4+MvGDmK3xJOhFhDm+X
	 ri8m4qtYifqjp2VnAu9qP8ltEYRK5ArjEC04bVrtktSx445J105lAdxdQOmG670IDR
	 rKqqJ5WF/5hBf2XGO27T1swqCkNKqGHVlSkHAqiI=
Date: Sun, 01 Sep 2024 20:46:09 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch removed from -mm tree
Message-Id: <20240902034609.AE5D0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: optimize for-loop conditions in the BCJ decoders
has been removed from the -mm tree.  Its filename was
     xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: optimize for-loop conditions in the BCJ decoders
Date: Sun, 21 Jul 2024 16:36:25 +0300

Compilers cannot optimize the addition "i + 4" away since theoretically it
could overflow.

Link: https://lkml.kernel.org/r/20240721133633.47721-11-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Sam James <sam@gentoo.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Cc: Jules Maselbas <jmaselbas@zdiv.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rui Li <me@lirui.org>
Cc: Simon Glass <sjg@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_bcj.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/lib/xz/xz_dec_bcj.c~xz-optimize-for-loop-conditions-in-the-bcj-decoders
+++ a/lib/xz/xz_dec_bcj.c
@@ -161,7 +161,9 @@ static size_t bcj_powerpc(struct xz_dec_
 	size_t i;
 	uint32_t instr;
 
-	for (i = 0; i + 4 <= size; i += 4) {
+	size &= ~(size_t)3;
+
+	for (i = 0; i < size; i += 4) {
 		instr = get_unaligned_be32(buf + i);
 		if ((instr & 0xFC000003) == 0x48000001) {
 			instr &= 0x03FFFFFC;
@@ -218,7 +220,9 @@ static size_t bcj_ia64(struct xz_dec_bcj
 	/* Instruction normalized with bit_res for easier manipulation */
 	uint64_t norm;
 
-	for (i = 0; i + 16 <= size; i += 16) {
+	size &= ~(size_t)15;
+
+	for (i = 0; i < size; i += 16) {
 		mask = branch_table[buf[i] & 0x1F];
 		for (slot = 0, bit_pos = 5; slot < 3; ++slot, bit_pos += 41) {
 			if (((mask >> slot) & 1) == 0)
@@ -266,7 +270,9 @@ static size_t bcj_arm(struct xz_dec_bcj
 	size_t i;
 	uint32_t addr;
 
-	for (i = 0; i + 4 <= size; i += 4) {
+	size &= ~(size_t)3;
+
+	for (i = 0; i < size; i += 4) {
 		if (buf[i + 3] == 0xEB) {
 			addr = (uint32_t)buf[i] | ((uint32_t)buf[i + 1] << 8)
 					| ((uint32_t)buf[i + 2] << 16);
@@ -289,7 +295,12 @@ static size_t bcj_armthumb(struct xz_dec
 	size_t i;
 	uint32_t addr;
 
-	for (i = 0; i + 4 <= size; i += 2) {
+	if (size < 4)
+		return 0;
+
+	size -= 4;
+
+	for (i = 0; i <= size; i += 2) {
 		if ((buf[i + 1] & 0xF8) == 0xF0
 				&& (buf[i + 3] & 0xF8) == 0xF8) {
 			addr = (((uint32_t)buf[i + 1] & 0x07) << 19)
@@ -317,7 +328,9 @@ static size_t bcj_sparc(struct xz_dec_bc
 	size_t i;
 	uint32_t instr;
 
-	for (i = 0; i + 4 <= size; i += 4) {
+	size &= ~(size_t)3;
+
+	for (i = 0; i < size; i += 4) {
 		instr = get_unaligned_be32(buf + i);
 		if ((instr >> 22) == 0x100 || (instr >> 22) == 0x1FF) {
 			instr <<= 2;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are


