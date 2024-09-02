Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB34E143888
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248773; cv=none; b=Z8CdsvWOlbGa7U8QQcdhk0a/XV9IaDMe02IL+631zWdW6d2rxnLqyxE7mFTouDyj9wZs4XQKdgluYe3rtSNtIvUXInE48bGb8GqQDDiBE0LXzuYlUEemMZgUE86NO8I4kf5FGxksyHV4um3ce0+jn8/KfccygAPqez4iD+xpYmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248773; c=relaxed/simple;
	bh=AI00Y3KbonnyoDcHDBW6316kJz4XQnuNgEk/w86nvp4=;
	h=Date:To:From:Subject:Message-Id; b=pWURBlTQG3r+HtEVW93ghGmq1XHllRe3EkVH5eoq8kF0wLsGu4zpuyO8X0l5MQ0LF3d1ZspoVZRTtjMY5hjlOvabM2X8okM6uthIsLfbjUZQahYqqyxXXWPEb84/mj+NWUZimFIDA7kVLGfUHYHrZewM3HerGWRCT5BMwbNjvZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PabNJH4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PabNJH4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADCAC4CEC2;
	Mon,  2 Sep 2024 03:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248772;
	bh=AI00Y3KbonnyoDcHDBW6316kJz4XQnuNgEk/w86nvp4=;
	h=Date:To:From:Subject:From;
	b=PabNJH4KBaI6OJDSBXAw1+yHXjUtTlC4TTJxEEbWEcGm99PjiMH2LjbuHiKaG9apd
	 UbgqtQEMdII4f37RpqEXgk8xczqusTx8SZuI9z2RuMCfVEfWsdweo46XzXwk6RFNa/
	 PE6dPrHxSWN62gT2TCiBUSJUYAqCDRy3CJfzNY44=
Date: Sun, 01 Sep 2024 20:46:12 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-add-risc-v-bcj-filter.patch removed from -mm tree
Message-Id: <20240902034612.AADCAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: add RISC-V BCJ filter
has been removed from the -mm tree.  Its filename was
     xz-add-risc-v-bcj-filter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: add RISC-V BCJ filter
Date: Sun, 21 Jul 2024 16:36:27 +0300

A later commit updates lib/decompress_unxz.c to enable this filter for
kernel decompression.  lib/decompress_unxz.c is already used if
CONFIG_EFI_ZBOOT=y && CONFIG_KERNEL_XZ=y.

This filter can be used by Squashfs without modifications to the Squashfs
kernel code (only needs support in userspace Squashfs-tools).

Link: https://lkml.kernel.org/r/20240721133633.47721-13-lasse.collin@tukaani.org
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

 lib/xz/Kconfig       |    5 +
 lib/xz/xz_dec_bcj.c  |  104 ++++++++++++++++++++++++++++++++++++++++-
 lib/xz/xz_dec_syms.c |    2 
 lib/xz/xz_private.h  |    6 +-
 4 files changed, 114 insertions(+), 3 deletions(-)

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
@@ -24,7 +24,8 @@ struct xz_dec_bcj {
 		BCJ_ARM = 7,        /* Little endian only */
 		BCJ_ARMTHUMB = 8,   /* Little endian only */
 		BCJ_SPARC = 9,      /* Big or little endian */
-		BCJ_ARM64 = 10      /* AArch64 */
+		BCJ_ARM64 = 10,     /* AArch64 */
+		BCJ_RISCV = 11      /* RV32GQC_Zfh, RV64GQC_Zfh */
 	} type;
 
 	/*
@@ -388,6 +389,99 @@ static size_t bcj_arm64(struct xz_dec_bc
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
@@ -440,6 +534,11 @@ static void bcj_apply(struct xz_dec_bcj
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
@@ -616,6 +715,9 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_reset(s
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
+MODULE_VERSION("1.2");
 MODULE_AUTHOR("Lasse Collin <lasse.collin@tukaani.org> and Igor Pavlov");
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


