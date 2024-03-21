Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E6D134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060187; cv=none; b=njrm9uMngr9hqnG7aaZ5PrwzKNXJDw9NE17auKWAOzvY38+BK1gU6l8D6YNL3oIWle6dNX6gNIbg4u7pBbo8GILHKtKwbnr+RSfzO0BkBXDfgkPAWB8w1dnzyjTXOuBzzPGFB8Y6JCKVkX9CyaT/EStPPQQZBmt4f5VWe4n2PRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060187; c=relaxed/simple;
	bh=BKXzciNHpV4aqJzNutA/q/UIpVvqnSNaABym8KREQkg=;
	h=Date:To:From:Subject:Message-Id; b=T0QiqLvXhOBiARvF6ZhO0iym6NtzLVLjCzyipAJtR8dL1H24nrIztULlnHk78RmCD9P+59dTJIj5qyQMi3NOvy2qxzQK3SLqYpjVwFIQo/zeAnoV191V2SmLs27/Jxh+c5AiXzw3h1MgLWxMwEWllYLHLOdvvIWmlOPdRkeGHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQ14K+ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQ14K+ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056EAC433F1;
	Thu, 21 Mar 2024 22:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060187;
	bh=BKXzciNHpV4aqJzNutA/q/UIpVvqnSNaABym8KREQkg=;
	h=Date:To:From:Subject:From;
	b=ZQ14K+mlJFGZq4NhsG4izNHr1uOAKuRkAdWAybPx25Dj8JEWbggCo4bJV5zsoxibk
	 sYrL2kM5wSxAU+xocNKbFl9qTh/FSv8bZywURWSru0wN+LzrOLsTSMQxda60yVoL/K
	 g5XxXO+QZPIkeaKJYegASKW7ghLB5VdMRdDJOoUE=
Date: Thu, 21 Mar 2024 15:29:46 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-add-risc-v-bcj-filter.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222947.056EAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: add RISC-V BCJ filter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-add-risc-v-bcj-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-add-risc-v-bcj-filter.patch

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
Subject: xz: add RISC-V BCJ filter
Date: Wed, 20 Mar 2024 20:38:42 +0200

This filter can be used by Squashfs without modifications to the Squashfs
kernel code (only needs support in userspace Squashfs-tools).

Link: https://lkml.kernel.org/r/20240320183846.19475-10-lasse.collin@tukaani.org
Co-developed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig       |    5 +
 lib/xz/xz_dec_bcj.c  |  105 ++++++++++++++++++++++++++++++++++++++++-
 lib/xz/xz_dec_syms.c |    4 -
 lib/xz/xz_private.h  |    6 +-
 4 files changed, 116 insertions(+), 4 deletions(-)

--- a/lib/xz/Kconfig~xz-add-risc-v-bcj-filter
+++ a/lib/xz/Kconfig
@@ -40,6 +40,11 @@ config XZ_DEC_SPARC
 	default y
 	select XZ_DEC_BCJ
 
+config XZ_DEC_RISCV
+	bool "RISC-V BCJ filter decoder" if EXPERT
+	default y
+	select XZ_DEC_BCJ
+
 config XZ_DEC_MICROLZMA
 	bool "MicroLZMA decoder"
 	default n
--- a/lib/xz/xz_dec_bcj.c~xz-add-risc-v-bcj-filter
+++ a/lib/xz/xz_dec_bcj.c
@@ -5,6 +5,7 @@
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
  *          Igor Pavlov <https://7-zip.org/>
+ *          Jia Tan <jiat0218@gmail.com>
  */
 
 #include "xz_private.h"
@@ -24,7 +25,8 @@ struct xz_dec_bcj {
 		BCJ_ARM = 7,        /* Little endian only */
 		BCJ_ARMTHUMB = 8,   /* Little endian only */
 		BCJ_SPARC = 9,      /* Big or little endian */
-		BCJ_ARM64 = 10      /* AArch64 */
+		BCJ_ARM64 = 10,     /* AArch64 */
+		BCJ_RISCV = 11      /* RV32GQC_Zfh, RV64GQC_Zfh */
 	} type;
 
 	/*
@@ -388,6 +390,99 @@ static size_t bcj_arm64(struct xz_dec_bc
 }
 #endif
 
+#ifdef XZ_DEC_RISCV
+static size_t bcj_riscv(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
+{
+	size_t i;
+	uint32_t b1;
+	uint32_t b2;
+	uint32_t b3;
+	uint32_t instr;
+	uint32_t instr2;
+	uint32_t instr2_rs1;
+	uint32_t addr;
+
+	if (size < 8)
+		return 0;
+
+	size -= 8;
+
+	for (i = 0; i <= size; i += 2) {
+		instr = buf[i];
+
+		if (instr == 0xEF) {
+			/* JAL */
+			b1 = buf[i + 1];
+			if ((b1 & 0x0D) != 0)
+				continue;
+
+			b2 = buf[i + 2];
+			b3 = buf[i + 3];
+
+			addr = ((b1 & 0xF0) << 13) | (b2 << 9) | (b3 << 1);
+			addr -= s->pos + (uint32_t)i;
+
+			buf[i + 1] = (uint8_t)((b1 & 0x0F)
+					| ((addr >> 8) & 0xF0));
+
+			buf[i + 2] = (uint8_t)(((addr >> 16) & 0x0F)
+					| ((addr >> 7) & 0x10)
+					| ((addr << 4) & 0xE0));
+
+			buf[i + 3] = (uint8_t)(((addr >> 4) & 0x7F)
+					| ((addr >> 13) & 0x80));
+
+			i += 4 - 2;
+
+		} else if ((instr & 0x7F) == 0x17) {
+			/* AUIPC */
+			instr |= (uint32_t)buf[i + 1] << 8;
+			instr |= (uint32_t)buf[i + 2] << 16;
+			instr |= (uint32_t)buf[i + 3] << 24;
+
+			if (instr & 0xE80) {
+				/* AUIPC's rd doesn't equal x0 or x2. */
+				instr2 = get_unaligned_le32(buf + i + 4);
+
+				if (((instr << 8) ^ (instr2 - 3)) & 0xF8003) {
+					i += 6 - 2;
+					continue;
+				}
+
+				addr = (instr & 0xFFFFF000) + (instr2 >> 20);
+
+				instr = 0x17 | (2 << 7) | (instr2 << 12);
+				instr2 = addr;
+			} else {
+				/* AUIPC's rd equals x0 or x2. */
+				instr2_rs1 = instr >> 27;
+
+				if ((uint32_t)((instr - 0x3117) << 18)
+						>= (instr2_rs1 & 0x1D)) {
+					i += 4 - 2;
+					continue;
+				}
+
+				addr = get_unaligned_be32(buf + i + 4);
+				addr -= s->pos + (uint32_t)i;
+
+				instr2 = (instr >> 12) | (addr << 20);
+
+				instr = 0x17 | (instr2_rs1 << 7)
+					| ((addr + 0x800) & 0xFFFFF000);
+			}
+
+			put_unaligned_le32(instr, buf + i);
+			put_unaligned_le32(instr2, buf + i + 4);
+
+			i += 8 - 2;
+		}
+	}
+
+	return i;
+}
+#endif
+
 /*
  * Apply the selected BCJ filter. Update *pos and s->pos to match the amount
  * of data that got filtered.
@@ -440,6 +535,11 @@ static void bcj_apply(struct xz_dec_bcj
 		filtered = bcj_arm64(s, buf, size);
 		break;
 #endif
+#ifdef XZ_DEC_RISCV
+	case BCJ_RISCV:
+		filtered = bcj_riscv(s, buf, size);
+		break;
+#endif
 	default:
 		/* Never reached but silence compiler warnings. */
 		filtered = 0;
@@ -616,6 +716,9 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_reset(s
 #ifdef XZ_DEC_ARM64
 	case BCJ_ARM64:
 #endif
+#ifdef XZ_DEC_RISCV
+	case BCJ_RISCV:
+#endif
 		break;
 
 	default:
--- a/lib/xz/xz_dec_syms.c~xz-add-risc-v-bcj-filter
+++ a/lib/xz/xz_dec_syms.c
@@ -22,6 +22,6 @@ EXPORT_SYMBOL(xz_dec_microlzma_end);
 #endif
 
 MODULE_DESCRIPTION("XZ decompressor");
-MODULE_VERSION("1.1");
-MODULE_AUTHOR("Lasse Collin <lasse.collin@tukaani.org> and Igor Pavlov");
+MODULE_VERSION("1.2");
+MODULE_AUTHOR("Lasse Collin, Igor Pavlov, Jia Tan");
 MODULE_LICENSE("Dual BSD/GPL");
--- a/lib/xz/xz_private.h~xz-add-risc-v-bcj-filter
+++ a/lib/xz/xz_private.h
@@ -39,6 +39,9 @@
 #		ifdef CONFIG_XZ_DEC_ARM64
 #			define XZ_DEC_ARM64
 #		endif
+#		ifdef CONFIG_XZ_DEC_RISCV
+#			define XZ_DEC_RISCV
+#		endif
 #		ifdef CONFIG_XZ_DEC_MICROLZMA
 #			define XZ_DEC_MICROLZMA
 #		endif
@@ -102,7 +105,8 @@
 #	if defined(XZ_DEC_X86) || defined(XZ_DEC_POWERPC) \
 			|| defined(XZ_DEC_IA64) \
 			|| defined(XZ_DEC_ARM) || defined(XZ_DEC_ARMTHUMB) \
-			|| defined(XZ_DEC_SPARC) || defined(XZ_DEC_ARM64)
+			|| defined(XZ_DEC_SPARC) || defined(XZ_DEC_ARM64) \
+			|| defined(XZ_DEC_RISCV)
 #		define XZ_DEC_BCJ
 #	endif
 #endif
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

