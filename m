Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D644130AC8
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701767; cv=none; b=rupH8fyEgx92ygIMJdRIFOkraqyRC95nnbtqRINPuqe/022SH45oQSG1+/UPnBz5QmXK6jaX590smDZ1TnjV5J+pIR89SLBxKHQKDno2qTT/Omgm735ElLl6hEpnqNByZsvE/f35I9u8+VwsfZXuZ++0rzaVbzqMKbJisxtF5P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701767; c=relaxed/simple;
	bh=hM5PWkPuTL35R4aLtPGD/qRWTFw/g8JORyyPHCU1+5w=;
	h=Date:To:From:Subject:Message-Id; b=HH8sc88W06yqegrlfJJzL0sWlwNjtAxIryiGqpW82hk4+25pXIgobrq3bnHAk6m+8v/vFJRI9/QoKmfzpg+HjQ+tDVuHS3TMvxqXinSQIxhWgN1ck5wAgr0YnBhCqlldO2obXlQ3oNftq+/qBCEE6rzA4cYXcPzWuefV16yyJVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nu+txHvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nu+txHvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3B5C116B1;
	Tue, 23 Jul 2024 02:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701767;
	bh=hM5PWkPuTL35R4aLtPGD/qRWTFw/g8JORyyPHCU1+5w=;
	h=Date:To:From:Subject:From;
	b=Nu+txHvQO91smjITGSPuZuT6qBJpIqAFAUTEN5UpTborAFZLRYVEyfJan1QUnEXSf
	 LYY+PiqDlWWHtufLnc5QRgjKqiX3BBwt+m85t1YusuaUQR9GJMrjATJfsz2IzZdB8W
	 wiMhBP0Jt20os5bX/bzvMwZdjPXMnZOxndhLHpn0=
Date: Mon, 22 Jul 2024 19:29:26 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-add-arm64-bcj-filter.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022927.2C3B5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: Add ARM64 BCJ filter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-add-arm64-bcj-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-add-arm64-bcj-filter.patch

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
Subject: xz: Add ARM64 BCJ filter
Date: Sun, 21 Jul 2024 16:36:26 +0300

Also omit a duplicated check for XZ_DEC_ARM in xz_private.h.

A later commit updates lib/decompress_unxz.c to enable this filter for
kernel decompression.  lib/decompress_unxz.c is already used if
CONFIG_EFI_ZBOOT=y && CONFIG_KERNEL_XZ=y.

This filter can be used by Squashfs without modifications to the Squashfs
kernel code (only needs support in userspace Squashfs-tools).

Link: https://lkml.kernel.org/r/20240721133633.47721-12-lasse.collin@tukaani.org
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

 lib/xz/Kconfig      |    5 ++++
 lib/xz/xz_dec_bcj.c |   52 +++++++++++++++++++++++++++++++++++++++++-
 lib/xz/xz_private.h |    7 ++++-
 3 files changed, 61 insertions(+), 3 deletions(-)

--- a/lib/xz/Kconfig~xz-add-arm64-bcj-filter
+++ a/lib/xz/Kconfig
@@ -30,6 +30,11 @@ config XZ_DEC_ARMTHUMB
 	default y
 	select XZ_DEC_BCJ
 
+config XZ_DEC_ARM64
+	bool "ARM64 BCJ filter decoder" if EXPERT
+	default y
+	select XZ_DEC_BCJ
+
 config XZ_DEC_SPARC
 	bool "SPARC BCJ filter decoder" if EXPERT
 	default y
--- a/lib/xz/xz_dec_bcj.c~xz-add-arm64-bcj-filter
+++ a/lib/xz/xz_dec_bcj.c
@@ -23,7 +23,8 @@ struct xz_dec_bcj {
 		BCJ_IA64 = 6,       /* Big or little endian */
 		BCJ_ARM = 7,        /* Little endian only */
 		BCJ_ARMTHUMB = 8,   /* Little endian only */
-		BCJ_SPARC = 9       /* Big or little endian */
+		BCJ_SPARC = 9,      /* Big or little endian */
+		BCJ_ARM64 = 10      /* AArch64 */
 	} type;
 
 	/*
@@ -346,6 +347,47 @@ static size_t bcj_sparc(struct xz_dec_bc
 }
 #endif
 
+#ifdef XZ_DEC_ARM64
+static size_t bcj_arm64(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
+{
+	size_t i;
+	uint32_t instr;
+	uint32_t addr;
+
+	size &= ~(size_t)3;
+
+	for (i = 0; i < size; i += 4) {
+		instr = get_unaligned_le32(buf + i);
+
+		if ((instr >> 26) == 0x25) {
+			/* BL instruction */
+			addr = instr - ((s->pos + (uint32_t)i) >> 2);
+			instr = 0x94000000 | (addr & 0x03FFFFFF);
+			put_unaligned_le32(instr, buf + i);
+
+		} else if ((instr & 0x9F000000) == 0x90000000) {
+			/* ADRP instruction */
+			addr = ((instr >> 29) & 3) | ((instr >> 3) & 0x1FFFFC);
+
+			/* Only convert values in the range +/-512 MiB. */
+			if ((addr + 0x020000) & 0x1C0000)
+				continue;
+
+			addr -= (s->pos + (uint32_t)i) >> 12;
+
+			instr &= 0x9000001F;
+			instr |= (addr & 3) << 29;
+			instr |= (addr & 0x03FFFC) << 3;
+			instr |= (0U - (addr & 0x020000)) & 0xE00000;
+
+			put_unaligned_le32(instr, buf + i);
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
@@ -393,6 +435,11 @@ static void bcj_apply(struct xz_dec_bcj
 		filtered = bcj_sparc(s, buf, size);
 		break;
 #endif
+#ifdef XZ_DEC_ARM64
+	case BCJ_ARM64:
+		filtered = bcj_arm64(s, buf, size);
+		break;
+#endif
 	default:
 		/* Never reached but silence compiler warnings. */
 		filtered = 0;
@@ -566,6 +613,9 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_reset(s
 #ifdef XZ_DEC_SPARC
 	case BCJ_SPARC:
 #endif
+#ifdef XZ_DEC_ARM64
+	case BCJ_ARM64:
+#endif
 		break;
 
 	default:
--- a/lib/xz/xz_private.h~xz-add-arm64-bcj-filter
+++ a/lib/xz/xz_private.h
@@ -36,6 +36,9 @@
 #		ifdef CONFIG_XZ_DEC_SPARC
 #			define XZ_DEC_SPARC
 #		endif
+#		ifdef CONFIG_XZ_DEC_ARM64
+#			define XZ_DEC_ARM64
+#		endif
 #		ifdef CONFIG_XZ_DEC_MICROLZMA
 #			define XZ_DEC_MICROLZMA
 #		endif
@@ -97,9 +100,9 @@
  */
 #ifndef XZ_DEC_BCJ
 #	if defined(XZ_DEC_X86) || defined(XZ_DEC_POWERPC) \
-			|| defined(XZ_DEC_IA64) || defined(XZ_DEC_ARM) \
+			|| defined(XZ_DEC_IA64) \
 			|| defined(XZ_DEC_ARM) || defined(XZ_DEC_ARMTHUMB) \
-			|| defined(XZ_DEC_SPARC)
+			|| defined(XZ_DEC_SPARC) || defined(XZ_DEC_ARM64)
 #		define XZ_DEC_BCJ
 #	endif
 #endif
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainer.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-fix-comments-and-coding-style.patch
xz-fix-kernel-doc-formatting-errors-in-xzh.patch
xz-improve-the-microlzma-kernel-doc-in-xzh.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
docs-add-xz_extern-to-c_id_attributes.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch
arm64-boot-add-imagexz-support.patch
riscv-boot-add-imagexz-support.patch

