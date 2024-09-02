Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E511013B288
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248766; cv=none; b=ZmQC1mPE9Xusha4jfYN5W58qRHh9hmna8VtyW6VZIesYmoFUNoM0G9mRB71fj0TEbAJF3B/osKJSSq20wg4NCaiwj5/6ERGlhjmp0FpQfB1VS2XDb3LyedUee4hHNlPu4aDkQScuIaobC8gomLz1oCO+svCnwg/LiVyozX3h/uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248766; c=relaxed/simple;
	bh=zkVwd4+ZhKjE03ABeTpCyAzXTcZtSh4nO2w4ClhzeSs=;
	h=Date:To:From:Subject:Message-Id; b=jNKGysetI/JuCCXRGugvL8Gc4l+ox4Fqd2UaJp54m2Ffx0CUIxccsq+oFOptohDZqcfgwqScEcPEEEM/gaVf8kZmGY3VCD1UNC6bvR5M3DAT+wfeqZivlUs8uObtq450p8uH2PUZDWXCeyyOYXV1PVZZDjnMBerBSKjHrEbCYNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPvyAlfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPvyAlfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F5EC4CEC2;
	Mon,  2 Sep 2024 03:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248765;
	bh=zkVwd4+ZhKjE03ABeTpCyAzXTcZtSh4nO2w4ClhzeSs=;
	h=Date:To:From:Subject:From;
	b=EPvyAlfR6/Zm8J8OHcjPpNyFwAU/r/y2Z+TAmTjKyXhjY15/2qf+9Tgs57xPj4TmK
	 pBWWXmpRuJH6NAgRhcBWCvOZYWraFR0TI6hEnUE7eUpRfi0QSPQXkfe4Q/ufU7cZTG
	 CAU3cHV7sEdTc4xx075nfuAl4P5n0etVv46Mdjyk=
Date: Sun, 01 Sep 2024 20:46:04 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-improve-the-microlzma-kernel-doc-in-xzh.patch removed from -mm tree
Message-Id: <20240902034605.65F5EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: improve the MicroLZMA kernel-doc in xz.h
has been removed from the -mm tree.  Its filename was
     xz-improve-the-microlzma-kernel-doc-in-xzh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


