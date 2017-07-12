From: akpm@linux-foundation.org
Subject: [patch 65/96] random,stackprotect: introduce
 get_random_canary function
Date: Wed, 12 Jul 2017 14:36:17 -0700
Message-ID: <20170712213617.kvCnuA6E8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdGLVgT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, tytso@mit.edu, ysato@users.sourceforge.jp

From: Rik van Riel <riel@redhat.com>
Subject: random,stackprotect: introduce get_random_canary function

Patch series "stackprotector: ascii armor the stack canary", v2.

Zero out the first byte of the stack canary value on 64 bit systems,
in order to mitigate unterminated C string overflows.

The null byte both prevents C string functions from reading the
canary, and from writing it if the canary value were guessed or
obtained through some other means.
    
Reducing the entropy by 8 bits is acceptable on 64-bit systems,
which will still have 56 bits of entropy left, but not on 32
bit systems, so the "ascii armor" canary is only implemented on
64-bit systems.

Inspired by the "ascii armor" code in execshield and Daniel Micay's
linux-hardened tree.

Also see https://github.com/thestinger/linux-hardened/


This patch (of 5):

Introduce get_random_canary(), which provides a random unsigned long
canary value with the first byte zeroed out on 64 bit architectures, in
order to mitigate non-terminated C string overflows.

The null byte both prevents C string functions from reading the canary,
and from writing it if the canary value were guessed or obtained through
some other means.

Reducing the entropy by 8 bits is acceptable on 64-bit systems, which will
still have 56 bits of entropy left, but not on 32 bit systems, so the
"ascii armor" canary is only implemented on 64-bit systems.

Inspired by the "ascii armor" code in the old execshield patches, and
Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170524155751.424-2-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/random.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN include/linux/random.h~randomstackprotect-introduce-get_random_canary-function include/linux/random.h
--- a/include/linux/random.h~randomstackprotect-introduce-get_random_canary-function
+++ a/include/linux/random.h
@@ -57,6 +57,27 @@ static inline unsigned long get_random_l
 #endif
 }
 
+/*
+ * On 64-bit architectures, protect against non-terminated C string overflows
+ * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
+ */
+#ifdef CONFIG_64BIT
+# ifdef __LITTLE_ENDIAN
+#  define CANARY_MASK 0xffffffffffffff00UL
+# else /* big endian, 64 bits: */
+#  define CANARY_MASK 0x00ffffffffffffffUL
+# endif
+#else /* 32 bits: */
+# define CANARY_MASK 0xffffffffUL
+#endif
+
+static inline unsigned long get_random_canary(void)
+{
+	unsigned long val = get_random_long();
+
+	return val & CANARY_MASK;
+}
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
_
