Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0F1369BE
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060183; cv=none; b=pkZ+A1K4evmMs+9/cGSo288cNOFxqjFLlJnu0Zeg+VbtJd+EqobkFMQ9PiqeMycZOHY/URnZUWMsorCpi/fyQY3gXW0Db6lEBMK2DjfCIXSYK0FaWIovKQ3uilt4gEBOXUl02Omn5J0nBT/lBUHe2T85fJ4wRKvn+m7XIfdDeY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060183; c=relaxed/simple;
	bh=vWwato2MNQ5NXfBPTeY+775vHW02i7U5oqKQ9isttrA=;
	h=Date:To:From:Subject:Message-Id; b=ZYHXmyO7QXPU4BSYeLcVV/0N2jaL4xbJ9wlA5jhF3c4L8oyPLAGOhVzELjjTANeVKEt9hpTALyuM5sdQQKbDIUk/4fP9J1FT5TDii5+PLLooq8xmbM8ZJbXNNFXdM5kpkaaY6G9tJF/FsL9WJtsvG0qYlF9OSlWCytlDQpYTZy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLMrsMvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLMrsMvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B319FC433C7;
	Thu, 21 Mar 2024 22:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060182;
	bh=vWwato2MNQ5NXfBPTeY+775vHW02i7U5oqKQ9isttrA=;
	h=Date:To:From:Subject:From;
	b=tLMrsMvpYuIxiqkjgw6XWGVviJ7vHzKSKrOHwXT+TDL6Bss6qli2VNGdgQsghwd3t
	 d+J1TeznmD0bN5C9KBbgGQiekjg+XUzSflyG/1onY3/qmcfwiB2HNxq/S0bO2n0SEf
	 b+poKDwob5lCX328nfHhJx/H6vLReI+4sPerZZXo=
Date: Thu, 21 Mar 2024 15:29:42 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222942.B319FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: optimize for-loop conditions in the BCJ decoders
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: optimize for-loop conditions in the BCJ decoders
Date: Wed, 20 Mar 2024 20:38:40 +0200

Compilers cannot optimize the addition "i + 4" away since theoretically
it could overflow.

Link: https://lkml.kernel.org/r/20240320183846.19475-8-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
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

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch

