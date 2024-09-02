Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5836FA32
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248764; cv=none; b=q0hj4piGAZjygOC4fWenyVjXIo6dQ9zr6AswofiXPV4b1xu6esF6DMzIA7KL8rNVIqPz1mqO2WE/V7DQxgDQMKSLIAqlanTtjyawfdDdloODZpi7oW9caNMjvUbhjuqWRr4OIeCiZ07/X4s5fo9SeYl1IirIIomNiJQHoCS3fHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248764; c=relaxed/simple;
	bh=uK0gbccRrHnk0S0vknktS+tcJnUu1upyuSFv+Or3ccA=;
	h=Date:To:From:Subject:Message-Id; b=Zi7OEvq27yCIRtu5kV9781K993dlENOE8p1E95G0x4xXNnG+HjSstpbd0bPpjklyVtCHcnfW6MKwyK8GVH06iYnALjKDX5d9hMXph1E6y082zmti1a41MtfDerL6kyizt8C+wifIt3kDQTFk2Z0QiwGceBq5lRtJ2y31cRnC7M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkV+9qFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkV+9qFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B313C4CEC2;
	Mon,  2 Sep 2024 03:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248764;
	bh=uK0gbccRrHnk0S0vknktS+tcJnUu1upyuSFv+Or3ccA=;
	h=Date:To:From:Subject:From;
	b=MkV+9qFZNxNcWUqNxHGecfU7H6shxxWH2TwgHCGyMu8vC8Fa+TLPXchjNPnjL89DK
	 XGMOzbcVVGAbbwmQj9QXLjTDkA+hmCG6yymvNlw9sXj+ZyEziyX7FhT+B3sDZ55y2n
	 jqkdts/jeOm0oV8eLlHLPb5FQsTh7tEpoj96OhAE=
Date: Sun, 01 Sep 2024 20:46:03 -0700
To: mm-commits@vger.kernel.org,zhongjubin@huawei.com,will@kernel.org,tglx@linutronix.de,sjg@chromium.org,sam@gentoo.org,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,me@lirui.org,krzk@kernel.org,joel@jms.id.au,jmaselbas@zdiv.net,herbert@gondor.apana.org.au,gregkh@linuxfoundation.org,emil.renner.berthing@canonical.com,corbet@lwn.net,catalin.marinas@arm.com,aou@eecs.berkeley.edu,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xz-fix-kernel-doc-formatting-errors-in-xzh.patch removed from -mm tree
Message-Id: <20240902034604.2B313C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xz: fix kernel-doc formatting errors in xz.h
has been removed from the -mm tree.  Its filename was
     xz-fix-kernel-doc-formatting-errors-in-xzh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: fix kernel-doc formatting errors in xz.h
Date: Sun, 21 Jul 2024 16:36:20 +0300

The opaque structs xz_dec and xz_dec_microlzma are declared in xz.h but
their definitions are in xz_dec_lzma2.c without kernel-doc comments.  Use
regular comments for these structs in xz.h to avoid errors when building
the docs.

Add a few missing colons.

Link: https://lkml.kernel.org/r/20240721133633.47721-6-lasse.collin@tukaani.org
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

 include/linux/xz.h |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/xz.h~xz-fix-kernel-doc-formatting-errors-in-xzh
+++ a/include/linux/xz.h
@@ -142,7 +142,7 @@ struct xz_buf {
 	size_t out_size;
 };
 
-/**
+/*
  * struct xz_dec - Opaque type to hold the XZ decoder state
  */
 struct xz_dec;
@@ -240,15 +240,16 @@ XZ_EXTERN void xz_dec_end(struct xz_dec
  * marked with XZ_EXTERN. This avoids warnings about static functions that
  * are never defined.
  */
-/**
+
+/*
  * struct xz_dec_microlzma - Opaque type to hold the MicroLZMA decoder state
  */
 struct xz_dec_microlzma;
 
 /**
  * xz_dec_microlzma_alloc() - Allocate memory for the MicroLZMA decoder
- * @mode        XZ_SINGLE or XZ_PREALLOC
- * @dict_size   LZMA dictionary size. This must be at least 4 KiB and
+ * @mode:       XZ_SINGLE or XZ_PREALLOC
+ * @dict_size:  LZMA dictionary size. This must be at least 4 KiB and
  *              at most 3 GiB.
  *
  * In contrast to xz_dec_init(), this function only allocates the memory
@@ -276,15 +277,15 @@ extern struct xz_dec_microlzma *xz_dec_m
 
 /**
  * xz_dec_microlzma_reset() - Reset the MicroLZMA decoder state
- * @s           Decoder state allocated using xz_dec_microlzma_alloc()
- * @comp_size   Compressed size of the input stream
- * @uncomp_size Uncompressed size of the input stream. A value smaller
+ * @s:          Decoder state allocated using xz_dec_microlzma_alloc()
+ * @comp_size:  Compressed size of the input stream
+ * @uncomp_size:  Uncompressed size of the input stream. A value smaller
  *              than the real uncompressed size of the input stream can
  *              be specified if uncomp_size_is_exact is set to false.
  *              uncomp_size can never be set to a value larger than the
  *              expected real uncompressed size because it would eventually
  *              result in XZ_DATA_ERROR.
- * @uncomp_size_is_exact  This is an int instead of bool to avoid
+ * @uncomp_size_is_exact:  This is an int instead of bool to avoid
  *              requiring stdbool.h. This should normally be set to true.
  *              When this is set to false, error detection is weaker.
  */
@@ -294,7 +295,7 @@ extern void xz_dec_microlzma_reset(struc
 
 /**
  * xz_dec_microlzma_run() - Run the MicroLZMA decoder
- * @s           Decoder state initialized using xz_dec_microlzma_reset()
+ * @s:          Decoder state initialized using xz_dec_microlzma_reset()
  * @b:          Input and output buffers
  *
  * This works similarly to xz_dec_run() with a few important differences.
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are


