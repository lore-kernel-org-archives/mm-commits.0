Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E9C14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908584; cv=none; b=iOQLz6GaAMLvNsRhE66Mo1wXhRnGaE7GNDb59uPrw4oGi4qmQJRms5I9UvL1m0O8/L1FxE8Kh/m8IkGyDKWs2UK1hdzfnEhjHN1b8Qo2ScZ3g4yJ1TcsLjPXaZTZpPotny24berBfRkcwgON+bRJl3+GY/Z37RsP28gAG5ZUg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908584; c=relaxed/simple;
	bh=n4OtmTLZ5k1JLtzFUgG+FBYJ7na0wGm/FrT8+7dJZIc=;
	h=Date:To:From:Subject:Message-Id; b=J6wrlbbcToaK0ZqjtQrR2vBPNGwNDT5bmgDJENf263ObZK2Ai0wZzKM+cSzT/o2mrqOoMy9V5c2IdrrdsEKMcyy1gFP3ECbGgnjPuadr+r1a9quFvJ/oySuNIiv1CooU5Rh/yhhfOgZKojfa5nF7IIAj9EOlZNi9BjKbFWDlLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwKTHgdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwKTHgdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A70C4CEFB;
	Wed, 12 Nov 2025 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908584;
	bh=n4OtmTLZ5k1JLtzFUgG+FBYJ7na0wGm/FrT8+7dJZIc=;
	h=Date:To:From:Subject:From;
	b=DwKTHgdyNceD28OWRTHn7vStxMegSacKGSeMAIyu0nOZgcy+K3CvRfOALyL/wjP08
	 x/iLM5W3c3L9sPFVHt0eiQek0bvg6JOqL8uo4oz9v+N+N/Hn7OMi43sk+yucgRwpzH
	 Hlqp4jbkak186THRizAuPG6rlz7eksv5wRcKAusE=
Date: Tue, 11 Nov 2025 16:49:43 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,skhan@linuxfoundation.org,lasse.collin@tukaani.org,khalid@kernel.org,david.hunter.linux@gmail.com,spyjetfayed@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-xz-remove-dead-ia-64-itanium-support-code.patch removed from -mm tree
Message-Id: <20251112004944.52A70C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/xz: remove dead IA-64 (Itanium) support code
has been removed from the -mm tree.  Its filename was
     lib-xz-remove-dead-ia-64-itanium-support-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankan Biswas <spyjetfayed@gmail.com>
Subject: lib/xz: remove dead IA-64 (Itanium) support code
Date: Tue, 14 Oct 2025 10:54:36 +0530

Support for the IA-64 (Itanium) architecture was removed in commit
cf8e8658100d ("arch: Remove Itanium (IA-64) architecture").

This patch drops the IA-64 specific decompression code from lib/xz, which
was conditionally compiled with the now-obsolete CONFIG_XZ_DEC_IA64
option.

Link: https://lkml.kernel.org/r/20251014052738.31185-1-spyjetfayed@gmail.com
Signed-off-by: Ankan Biswas <spyjetfayed@gmail.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Khalid Aziz <khalid@kernel.org>
Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_bcj.c |   95 ------------------------------------------
 lib/xz/xz_private.h |    4 -
 2 files changed, 99 deletions(-)

--- a/lib/xz/xz_dec_bcj.c~lib-xz-remove-dead-ia-64-itanium-support-code
+++ a/lib/xz/xz_dec_bcj.c
@@ -20,7 +20,6 @@ struct xz_dec_bcj {
 	enum {
 		BCJ_X86 = 4,        /* x86 or x86-64 */
 		BCJ_POWERPC = 5,    /* Big endian only */
-		BCJ_IA64 = 6,       /* Big or little endian */
 		BCJ_ARM = 7,        /* Little endian only */
 		BCJ_ARMTHUMB = 8,   /* Little endian only */
 		BCJ_SPARC = 9,      /* Big or little endian */
@@ -180,92 +179,6 @@ static size_t bcj_powerpc(struct xz_dec_
 }
 #endif
 
-#ifdef XZ_DEC_IA64
-static size_t bcj_ia64(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
-{
-	static const uint8_t branch_table[32] = {
-		0, 0, 0, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0,
-		4, 4, 6, 6, 0, 0, 7, 7,
-		4, 4, 0, 0, 4, 4, 0, 0
-	};
-
-	/*
-	 * The local variables take a little bit stack space, but it's less
-	 * than what LZMA2 decoder takes, so it doesn't make sense to reduce
-	 * stack usage here without doing that for the LZMA2 decoder too.
-	 */
-
-	/* Loop counters */
-	size_t i;
-	size_t j;
-
-	/* Instruction slot (0, 1, or 2) in the 128-bit instruction word */
-	uint32_t slot;
-
-	/* Bitwise offset of the instruction indicated by slot */
-	uint32_t bit_pos;
-
-	/* bit_pos split into byte and bit parts */
-	uint32_t byte_pos;
-	uint32_t bit_res;
-
-	/* Address part of an instruction */
-	uint32_t addr;
-
-	/* Mask used to detect which instructions to convert */
-	uint32_t mask;
-
-	/* 41-bit instruction stored somewhere in the lowest 48 bits */
-	uint64_t instr;
-
-	/* Instruction normalized with bit_res for easier manipulation */
-	uint64_t norm;
-
-	size &= ~(size_t)15;
-
-	for (i = 0; i < size; i += 16) {
-		mask = branch_table[buf[i] & 0x1F];
-		for (slot = 0, bit_pos = 5; slot < 3; ++slot, bit_pos += 41) {
-			if (((mask >> slot) & 1) == 0)
-				continue;
-
-			byte_pos = bit_pos >> 3;
-			bit_res = bit_pos & 7;
-			instr = 0;
-			for (j = 0; j < 6; ++j)
-				instr |= (uint64_t)(buf[i + j + byte_pos])
-						<< (8 * j);
-
-			norm = instr >> bit_res;
-
-			if (((norm >> 37) & 0x0F) == 0x05
-					&& ((norm >> 9) & 0x07) == 0) {
-				addr = (norm >> 13) & 0x0FFFFF;
-				addr |= ((uint32_t)(norm >> 36) & 1) << 20;
-				addr <<= 4;
-				addr -= s->pos + (uint32_t)i;
-				addr >>= 4;
-
-				norm &= ~((uint64_t)0x8FFFFF << 13);
-				norm |= (uint64_t)(addr & 0x0FFFFF) << 13;
-				norm |= (uint64_t)(addr & 0x100000)
-						<< (36 - 20);
-
-				instr &= (1 << bit_res) - 1;
-				instr |= norm << bit_res;
-
-				for (j = 0; j < 6; j++)
-					buf[i + j + byte_pos]
-						= (uint8_t)(instr >> (8 * j));
-			}
-		}
-	}
-
-	return i;
-}
-#endif
-
 #ifdef XZ_DEC_ARM
 static size_t bcj_arm(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
@@ -509,11 +422,6 @@ static void bcj_apply(struct xz_dec_bcj
 		filtered = bcj_powerpc(s, buf, size);
 		break;
 #endif
-#ifdef XZ_DEC_IA64
-	case BCJ_IA64:
-		filtered = bcj_ia64(s, buf, size);
-		break;
-#endif
 #ifdef XZ_DEC_ARM
 	case BCJ_ARM:
 		filtered = bcj_arm(s, buf, size);
@@ -699,9 +607,6 @@ enum xz_ret xz_dec_bcj_reset(struct xz_d
 #ifdef XZ_DEC_POWERPC
 	case BCJ_POWERPC:
 #endif
-#ifdef XZ_DEC_IA64
-	case BCJ_IA64:
-#endif
 #ifdef XZ_DEC_ARM
 	case BCJ_ARM:
 #endif
--- a/lib/xz/xz_private.h~lib-xz-remove-dead-ia-64-itanium-support-code
+++ a/lib/xz/xz_private.h
@@ -24,9 +24,6 @@
 #		ifdef CONFIG_XZ_DEC_POWERPC
 #			define XZ_DEC_POWERPC
 #		endif
-#		ifdef CONFIG_XZ_DEC_IA64
-#			define XZ_DEC_IA64
-#		endif
 #		ifdef CONFIG_XZ_DEC_ARM
 #			define XZ_DEC_ARM
 #		endif
@@ -103,7 +100,6 @@
  */
 #ifndef XZ_DEC_BCJ
 #	if defined(XZ_DEC_X86) || defined(XZ_DEC_POWERPC) \
-			|| defined(XZ_DEC_IA64) \
 			|| defined(XZ_DEC_ARM) || defined(XZ_DEC_ARMTHUMB) \
 			|| defined(XZ_DEC_SPARC) || defined(XZ_DEC_ARM64) \
 			|| defined(XZ_DEC_RISCV)
_

Patches currently in -mm which might be from spyjetfayed@gmail.com are


