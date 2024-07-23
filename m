Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA32E13A253
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701756; cv=none; b=f4hd3ZptHIiGcXx6OGijLiZao1Y/4mmFNEcCWdbu053uE3bxovXCmO6uxxDsLJnWM6pSotnuSsXkEDqltFCu/C6lsQzYHpxNU5TLiMDRxWp9PiRLUR3wSSzh9H1VA9DMkqYR8dm5LaYRvU2tCtCNAdEepJgS7C6bogSa5TD+zDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701756; c=relaxed/simple;
	bh=JzmI+c6Mn+oxU+oOblcr5QqnJ1lQx06hG0Nn5sYMKzw=;
	h=Date:To:From:Subject:Message-Id; b=bQkyzAIoLmlbozbo3n6pDK1C/kCd4hrtlB4FBACvI/Nv3hihQqYDPMrh71T2Omc9KTMmDtz74+sHj5nXyXkmgxYlqa2OfFiIoNhI+PwBRW8Jg4dMrr6FR+fA4HdyE0EON0VPpTTu9IMnvzQDqSkWFV8FuPnvp2E2AOJsRNUIhY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWsKdlSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWsKdlSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1E3C116B1;
	Tue, 23 Jul 2024 02:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701756;
	bh=JzmI+c6Mn+oxU+oOblcr5QqnJ1lQx06hG0Nn5sYMKzw=;
	h=Date:To:From:Subject:From;
	b=XWsKdlSjJUOMfzYXj395JPwdNuin2uRugPypArl54kAy90TbwjpgxPX1luOzH0rv1
	 aGbjmHBf+i0rIvKEPzDtT4NIdv35lpY47XjOUWmp7iXfDL7Jfic5woHEPYc/0Jnl+v
	 zeA+vqG2AzELkFWOh+CztbNGsv7Olf3/E1merUVQ=
Date: Mon, 22 Jul 2024 19:29:15 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-improve-the-microlzma-kernel-doc-in-xzh.patch added to mm-nonmm-unstable branch
Message-Id: <20240723022916.2A1E3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: improve the MicroLZMA kernel-doc in xz.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-improve-the-microlzma-kernel-doc-in-xzh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-improve-the-microlzma-kernel-doc-in-xzh.patch

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
Subject: xz: improve the MicroLZMA kernel-doc in xz.h
Date: Sun, 21 Jul 2024 16:36:21 +0300

Move the description of the format into a "DOC:" comment.  Emphasize that
MicroLZMA functions aren't usually needed.

Link: https://lkml.kernel.org/r/20240721133633.47721-7-lasse.collin@tukaani.org
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

 include/linux/xz.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/xz.h~xz-improve-the-microlzma-kernel-doc-in-xzh
+++ a/include/linux/xz.h
@@ -232,9 +232,18 @@ XZ_EXTERN void xz_dec_reset(struct xz_de
  */
 XZ_EXTERN void xz_dec_end(struct xz_dec *s);
 
-/*
- * Decompressor for MicroLZMA, an LZMA variant with a very minimal header.
- * See xz_dec_microlzma_alloc() below for details.
+/**
+ * DOC: MicroLZMA decompressor
+ *
+ * This MicroLZMA header format was created for use in EROFS but may be used
+ * by others too. **In most cases one needs the XZ APIs above instead.**
+ *
+ * The compressed format supported by this decoder is a raw LZMA stream
+ * whose first byte (always 0x00) has been replaced with bitwise-negation
+ * of the LZMA properties (lc/lp/pb) byte. For example, if lc/lp/pb is
+ * 3/0/2, the first byte is 0xA2. This way the first byte can never be 0x00.
+ * Just like with LZMA2, lc + lp <= 4 must be true. The LZMA end-of-stream
+ * marker must not be used. The unused values are reserved for future use.
  *
  * These functions aren't used or available in preboot code and thus aren't
  * marked with XZ_EXTERN. This avoids warnings about static functions that
@@ -262,15 +271,6 @@ struct xz_dec_microlzma;
  * On success, xz_dec_microlzma_alloc() returns a pointer to
  * struct xz_dec_microlzma. If memory allocation fails or
  * dict_size is invalid, NULL is returned.
- *
- * The compressed format supported by this decoder is a raw LZMA stream
- * whose first byte (always 0x00) has been replaced with bitwise-negation
- * of the LZMA properties (lc/lp/pb) byte. For example, if lc/lp/pb is
- * 3/0/2, the first byte is 0xA2. This way the first byte can never be 0x00.
- * Just like with LZMA2, lc + lp <= 4 must be true. The LZMA end-of-stream
- * marker must not be used. The unused values are reserved for future use.
- * This MicroLZMA header format was created for use in EROFS but may be used
- * by others too.
  */
 extern struct xz_dec_microlzma *xz_dec_microlzma_alloc(enum xz_mode mode,
 						       uint32_t dict_size);
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

