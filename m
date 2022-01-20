Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EEFC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358177AbiATCJK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358188AbiATCJI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF019C06161C
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E65F61546
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60149C004E1;
        Thu, 20 Jan 2022 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644546;
        bh=qF8Ej4NLhGs61sKvXLjCld8c5IymGUZyJ9tI+SsFFc8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CcUbwr9SkTQOA1wMoPkCcB2fdnuzVcNLcB22uGbg/F1hxUhbFwPO7LTfXFYn0Avup
         B7Wky8XT0WPy8n7Lom6N3KXwvOH5YOytVCqjChLSTYUFvCodta/D1eLiJP8XtIm0PC
         Jgzd/CXwgWw13A0IGz9IH9co5EtTPnYk+RDClTg0=
Date:   Wed, 19 Jan 2022 18:09:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, augusto.duraes33@gmail.com,
        brendanhiggins@google.com, davidgow@google.com,
        dlatypov@google.com, ferreiraenzoa@gmail.com, geert@linux-m68k.org,
        isabbasso@riseup.net, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rodrigosiqueiramelo@gmail.com,
        skhan@linuxfoundation.org, torvalds@linux-foundation.org
Subject:  [patch 26/55] test_hash.c: split test_int_hash into
 arch-specific functions
Message-ID: <20220120020905.jubAuSic8%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Isabella Basso <isabbasso@riseup.net>
Subject: test_hash.c: split test_int_hash into arch-specific functions

Split the test_int_hash function to keep its mainloop separate from
arch-specific chunks, which are only compiled as needed.  This aims at
improving readability.

Link: https://lkml.kernel.org/r/20211208183711.390454-3-isabbasso@riseup.net
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: David Gow <davidgow@google.com>
Signed-off-by: Isabella Basso <isabbasso@riseup.net>
Cc: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Enzo Ferreira <ferreiraenzoa@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hash.c |   91 +++++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 29 deletions(-)

--- a/lib/test_hash.c~test_hashc-split-test_int_hash-into-arch-specific-fun=
ctions
+++ a/lib/test_hash.c
@@ -56,6 +56,58 @@ fill_buf(char *buf, size_t len, u32 seed
 	}
 }
=20
+/* Holds most testing variables for the int test. */
+struct test_hash_params {
+        /* Pointer to integer to be hashed. */
+	unsigned long long *h64;
+        /* Low 32-bits of integer to be hashed. */
+	u32 h0;
+        /* Arch-specific hash result. */
+	u32 h1;
+        /* Generic hash result. */
+	u32 h2;
+        /* ORed hashes of given size (in bits). */
+	u32 (*hash_or)[33];
+};
+
+#ifdef HAVE_ARCH__HASH_32
+static bool __init
+test_int__hash_32(struct test_hash_params *params)
+{
+	params->hash_or[1][0] |=3D params->h2 =3D __hash_32_generic(params->h0);
+#if HAVE_ARCH__HASH_32 =3D=3D 1
+	if (params->h1 !=3D params->h2) {
+		pr_err("__hash_32(%#x) =3D %#x !=3D __hash_32_generic() =3D %#x",
+		       params->h0, params->h1, params->h2);
+		return false;
+	}
+#endif
+	return true;
+}
+#endif
+
+#ifdef HAVE_ARCH_HASH_64
+static bool __init
+test_int_hash_64(struct test_hash_params *params, u32 const *m, int *k)
+{
+	params->h2 =3D hash_64_generic(*params->h64, *k);
+#if HAVE_ARCH_HASH_64 =3D=3D 1
+	if (params->h1 !=3D params->h2) {
+		pr_err("hash_64(%#llx, %d) =3D %#x !=3D hash_64_generic() =3D %#x",
+		       *params->h64, *k, params->h1, params->h2);
+		return false;
+	}
+#else
+	if (params->h2 > *m) {
+		pr_err("hash_64_generic(%#llx, %d) =3D %#x > %#x",
+		       *params->h64, *k, params->h1, *m);
+		return false;
+	}
+#endif
+	return true;
+}
+#endif
+
 /*
  * Test the various integer hash functions.  h64 (or its low-order bits)
  * is the integer to hash.  hash_or accumulates the OR of the hash values,
@@ -69,19 +121,13 @@ static bool __init
 test_int_hash(unsigned long long h64, u32 hash_or[2][33])
 {
 	int k;
-	u32 h0 =3D (u32)h64, h1, h2;
+	struct test_hash_params params =3D { &h64, (u32)h64, 0, 0, hash_or };
=20
 	/* Test __hash32 */
-	hash_or[0][0] |=3D h1 =3D __hash_32(h0);
+	hash_or[0][0] |=3D params.h1 =3D __hash_32(params.h0);
 #ifdef HAVE_ARCH__HASH_32
-	hash_or[1][0] |=3D h2 =3D __hash_32_generic(h0);
-#if HAVE_ARCH__HASH_32 =3D=3D 1
-	if (h1 !=3D h2) {
-		pr_err("__hash_32(%#x) =3D %#x !=3D __hash_32_generic() =3D %#x",
-			h0, h1, h2);
+	if (!test_int__hash_32(&params))
 		return false;
-	}
-#endif
 #endif
=20
 	/* Test k =3D 1..32 bits */
@@ -89,37 +135,24 @@ test_int_hash(unsigned long long h64, u3
 		u32 const m =3D ((u32)2 << (k-1)) - 1;	/* Low k bits set */
=20
 		/* Test hash_32 */
-		hash_or[0][k] |=3D h1 =3D hash_32(h0, k);
-		if (h1 > m) {
-			pr_err("hash_32(%#x, %d) =3D %#x > %#x", h0, k, h1, m);
+		hash_or[0][k] |=3D params.h1 =3D hash_32(params.h0, k);
+		if (params.h1 > m) {
+			pr_err("hash_32(%#x, %d) =3D %#x > %#x", params.h0, k, params.h1, m);
 			return false;
 		}
=20
 		/* Test hash_64 */
-		hash_or[1][k] |=3D h1 =3D hash_64(h64, k);
-		if (h1 > m) {
-			pr_err("hash_64(%#llx, %d) =3D %#x > %#x", h64, k, h1, m);
+		hash_or[1][k] |=3D params.h1 =3D hash_64(h64, k);
+		if (params.h1 > m) {
+			pr_err("hash_64(%#llx, %d) =3D %#x > %#x", h64, k, params.h1, m);
 			return false;
 		}
 #ifdef HAVE_ARCH_HASH_64
-		h2 =3D hash_64_generic(h64, k);
-#if HAVE_ARCH_HASH_64 =3D=3D 1
-		if (h1 !=3D h2) {
-			pr_err("hash_64(%#llx, %d) =3D %#x !=3D hash_64_generic() "
-				"=3D %#x", h64, k, h1, h2);
+		if (!test_int_hash_64(&params, &m, &k))
 			return false;
-		}
-#else
-		if (h2 > m) {
-			pr_err("hash_64_generic(%#llx, %d) =3D %#x > %#x",
-				h64, k, h1, m);
-			return false;
-		}
-#endif
 #endif
 	}
=20
-	(void)h2;	/* Suppress unused variable warning */
 	return true;
 }
=20
_
