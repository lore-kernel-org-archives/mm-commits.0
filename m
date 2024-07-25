Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B652D299
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 21:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721941559; cv=none; b=liVyKw5PqG/S0uEFctDbLuK/SX8MFpgpizlXiL87zRkxJYRyks7s82ZTTlFKq2effLKhlS5H8jwRKGy8RBELUZ/aE5lf4sy+9BuyPq3Qgs9/RG+JkGsQ0S7hGt0Jzo7zuCIbWgVJqZpTW13K1Fbd1K8xvG+GCa37kapeQn7LH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721941559; c=relaxed/simple;
	bh=7F+w0rNnQLDP9y1FF2TFEim7lV9sN4F3pPfid0eoXqs=;
	h=Date:To:From:Subject:Message-Id; b=mu4oysgRfrdf3NC3SWdqP0NgVU83aiIHB6Eb/s7ftLEf9dwDkSwwOH8fTTSFMMOauJYR4lHi12CNCChicnMEhh4Vh3T3HteRdC4jHLxiK/ZJNbScVkQ0kLk6ujY0CZPPdKtDGglOOAfh+ZWa+Mo2oYu4s2TKb56lrDEBn+TrUa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ty9Js8w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ty9Js8w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D99C116B1;
	Thu, 25 Jul 2024 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721941558;
	bh=7F+w0rNnQLDP9y1FF2TFEim7lV9sN4F3pPfid0eoXqs=;
	h=Date:To:From:Subject:From;
	b=ty9Js8w5caXjX6zW6aunB/NWiLegjQOuZwC77O53/sgTA1DmwqMWdS2tOaS1B49KI
	 227+ZHxOOzybSlP6/yt60i73LGW0/31TCoPtETINQ5+K19d8qRdxF19741MiVKtuW6
	 JvXHuACcUf4FcBIj8IVXu7Z3MlDQAiwwgGi+/YCo=
Date: Thu, 25 Jul 2024 14:05:58 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,arnd@arndb.de,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uapi-define-genmask_u128.patch added to mm-nonmm-unstable branch
Message-Id: <20240725210558.A7D99C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uapi: define GENMASK_U128
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uapi-define-genmask_u128.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uapi-define-genmask_u128.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: uapi: define GENMASK_U128
Date: Thu, 25 Jul 2024 11:18:07 +0530

Patch series "uapi: Add support for GENMASK_U128()", v2.

This adds support for GENMASK_U128() and some corresponding tests as well.
GENMASK_U128() generated 128 bit masks will be required later on the
arm64 platform for enabling FEAT_SYSREG128 and FEAT_D128 features.

Because GENMAKS_U128() depends on __int128 data type being supported in
the compiler, its usage needs to be protected with
CONFIG_ARCH_SUPPORTS_INT128.


This patch (of 2):

This adds GENMASK_U128() and __GENMASK_U128() macros using __BITS_PER_U128
and __int128 data types. These macros will be used in providing support for
generating 128 bit masks.

Link: https://lkml.kernel.org/r/20240725054808.286708-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20240725054808.286708-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bits.h                   |    2 ++
 include/uapi/asm-generic/bitsperlong.h |    2 ++
 include/uapi/linux/bits.h              |    3 +++
 include/uapi/linux/const.h             |    1 +
 4 files changed, 8 insertions(+)

--- a/include/linux/bits.h~uapi-define-genmask_u128
+++ a/include/linux/bits.h
@@ -35,5 +35,7 @@
 	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
 #define GENMASK_ULL(h, l) \
 	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
+#define GENMASK_U128(h, l) \
+	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_U128(h, l))
 
 #endif	/* __LINUX_BITS_H */
--- a/include/uapi/asm-generic/bitsperlong.h~uapi-define-genmask_u128
+++ a/include/uapi/asm-generic/bitsperlong.h
@@ -28,4 +28,6 @@
 #define __BITS_PER_LONG_LONG 64
 #endif
 
+#define __BITS_PER_U128 128
+
 #endif /* _UAPI__ASM_GENERIC_BITS_PER_LONG */
--- a/include/uapi/linux/bits.h~uapi-define-genmask_u128
+++ a/include/uapi/linux/bits.h
@@ -12,4 +12,7 @@
         (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
          (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
 
+#define __GENMASK_U128(h, l) \
+	((_BIT128((h) + 1)) - (_BIT128(l)))
+
 #endif /* _UAPI_LINUX_BITS_H */
--- a/include/uapi/linux/const.h~uapi-define-genmask_u128
+++ a/include/uapi/linux/const.h
@@ -27,6 +27,7 @@
 
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
+#define _BIT128(x)	((unsigned __int128)(1) << (x))
 
 #define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

uapi-define-genmask_u128.patch
lib-test_bitsc-add-tests-for-genmask_u128.patch

