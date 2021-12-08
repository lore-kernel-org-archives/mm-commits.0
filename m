Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA603C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 23:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhLHXaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:30:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLHXaS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 18:30:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9498B8232A
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 23:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7ABC00446;
        Wed,  8 Dec 2021 23:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639006003;
        bh=9IKthosDFUSKlHYp/d5G9VCJryEEWuDiZt91OToykxc=;
        h=Date:From:To:Subject:From;
        b=CpCmY+VNSJEx4ZgIVzGNL8r5s6+iB9F2bn045tEM+oW/OK3IHidB0ad/GsHr6bu8r
         HhK1HinV6uimfFx5tTIiwmefYpvRAf0BD+TlI04+JpTpaJyVpQ8J5A5bNLklN+XNuh
         HdiAua8yW5Ue3aaAM2+T8Z5Qxle0EkY3NHNmygt0=
Date:   Wed, 08 Dec 2021 15:26:42 -0800
From:   akpm@linux-foundation.org
To:     augusto.duraes33@gmail.com, brendanhiggins@google.com,
        davidgow@google.com, dlatypov@google.com, ferreiraenzoa@gmail.com,
        geert@linux-m68k.org, isabbasso@riseup.net, lkp@intel.com,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        rodrigosiqueiramelo@gmail.com, skhan@linuxfoundation.org
Subject:  + hashh-remove-unused-define-directive.patch added to -mm
 tree
Message-ID: <20211208232642.mVjrnEvdN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hash.h: remove unused define directive
has been added to the -mm tree.  Its filename is
     hashh-remove-unused-define-directive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hashh-remove-unused-define-di=
rective.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hashh-remove-unused-define-di=
rective.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Isabella Basso <isabbasso@riseup.net>
Subject: hash.h: remove unused define directive

Patch series "test_hash.c: refactor into KUnit", v3.

We refactored the lib/test_hash.c file into KUnit as part of the student
group LKCAMP [1] introductory hackathon for kernel development.

This test was pointed to our group by Daniel Latypov [2], so its full
conversion into a pure KUnit test was our goal in this patch series, but
we ran into many problems relating to it not being split as unit tests,
which complicated matters a bit, as the reasoning behind the original
tests is quite cryptic for those unfamiliar with hash implementations.

Some interesting developments we'd like to highlight are:

- In patch 1/5 we noticed that there was an unused define directive that
  could be removed.
- In patch 4/5 we noticed how stringhash and hash tests are all under
  the lib/test_hash.c file, which might cause some confusion, and we
  also broke those kernel config entries up.

Overall KUnit developments have been made in the other patches in this
series:

In patches 2/5, 3/5 and 5/5 we refactored the lib/test_hash.c file so as
to make it more compatible with the KUnit style, whilst preserving the
original idea of the maintainer who designed it (i.e.  George Spelvin),
which might be undesirable for unit tests, but we assume it is enough for
a first patch.


This patch (of 5):

Currently, there exist hash_32() and __hash_32() functions, which were
introduced in a patch [1] targeting architecture specific optimizations.=20
These functions can be overridden on a per-architecture basis to achieve
such optimizations.  They must set their corresponding define directive
(HAVE_ARCH_HASH_32 and HAVE_ARCH__HASH_32, respectively) so that header
files can deal with these overrides properly.

As the supported 32-bit architectures that have their own hash function
implementation (i.e.  m68k, Microblaze, H8/300, pa-risc) have only been
making use of the (more general) __hash_32() function (which only lacks a
right shift operation when compared to the hash_32() function), remove the
define directive corresponding to the arch-specific hash_32()
implementation.

[1] https://lore.kernel.org/lkml/20160525073311.5600.qmail@ns.sciencehorizo=
ns.net/

Link: https://lkml.kernel.org/r/20211208183711.390454-1-isabbasso@riseup.net
Link: https://lkml.kernel.org/r/20211208183711.390454-2-isabbasso@riseup.net
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: David Gow <davidgow@google.com>
Co-developed-by: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Signed-off-by: Augusto Dur=C3=A3es Camargo <augusto.duraes33@gmail.com>
Co-developed-by: Enzo Ferreira <ferreiraenzoa@gmail.com>
Signed-off-by: Enzo Ferreira <ferreiraenzoa@gmail.com>
Signed-off-by: Isabella Basso <isabbasso@riseup.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hash.h       |    5 +----
 lib/test_hash.c            |   24 +-----------------------
 tools/include/linux/hash.h |    5 +----
 3 files changed, 3 insertions(+), 31 deletions(-)

--- a/include/linux/hash.h~hashh-remove-unused-define-directive
+++ a/include/linux/hash.h
@@ -62,10 +62,7 @@ static inline u32 __hash_32_generic(u32
 	return val * GOLDEN_RATIO_32;
 }
=20
-#ifndef HAVE_ARCH_HASH_32
-#define hash_32 hash_32_generic
-#endif
-static inline u32 hash_32_generic(u32 val, unsigned int bits)
+static inline u32 hash_32(u32 val, unsigned int bits)
 {
 	/* High bits are more random, so use them. */
 	return __hash_32(val) >> (32 - bits);
--- a/lib/test_hash.c~hashh-remove-unused-define-directive
+++ a/lib/test_hash.c
@@ -94,22 +94,7 @@ test_int_hash(unsigned long long h64, u3
 			pr_err("hash_32(%#x, %d) =3D %#x > %#x", h0, k, h1, m);
 			return false;
 		}
-#ifdef HAVE_ARCH_HASH_32
-		h2 =3D hash_32_generic(h0, k);
-#if HAVE_ARCH_HASH_32 =3D=3D 1
-		if (h1 !=3D h2) {
-			pr_err("hash_32(%#x, %d) =3D %#x !=3D hash_32_generic() "
-				" =3D %#x", h0, k, h1, h2);
-			return false;
-		}
-#else
-		if (h2 > m) {
-			pr_err("hash_32_generic(%#x, %d) =3D %#x > %#x",
-				h0, k, h1, m);
-			return false;
-		}
-#endif
-#endif
+
 		/* Test hash_64 */
 		hash_or[1][k] |=3D h1 =3D hash_64(h64, k);
 		if (h1 > m) {
@@ -227,13 +212,6 @@ test_hash_init(void)
 #else
 	pr_info("__hash_32() has no arch implementation to test.");
 #endif
-#ifdef HAVE_ARCH_HASH_32
-#if HAVE_ARCH_HASH_32 !=3D 1
-	pr_info("hash_32() is arch-specific; not compared to generic.");
-#endif
-#else
-	pr_info("hash_32() has no arch implementation to test.");
-#endif
 #ifdef HAVE_ARCH_HASH_64
 #if HAVE_ARCH_HASH_64 !=3D 1
 	pr_info("hash_64() is arch-specific; not compared to generic.");
--- a/tools/include/linux/hash.h~hashh-remove-unused-define-directive
+++ a/tools/include/linux/hash.h
@@ -62,10 +62,7 @@ static inline u32 __hash_32_generic(u32
 	return val * GOLDEN_RATIO_32;
 }
=20
-#ifndef HAVE_ARCH_HASH_32
-#define hash_32 hash_32_generic
-#endif
-static inline u32 hash_32_generic(u32 val, unsigned int bits)
+static inline u32 hash_32(u32 val, unsigned int bits)
 {
 	/* High bits are more random, so use them. */
 	return __hash_32(val) >> (32 - bits);
_

Patches currently in -mm which might be from isabbasso@riseup.net are

hashh-remove-unused-define-directive.patch
test_hashc-split-test_int_hash-into-arch-specific-functions.patch
test_hashc-split-test_hash_init.patch
lib-kconfigdebug-properly-split-hash-test-kernel-entries.patch
test_hashc-refactor-into-kunit.patch

