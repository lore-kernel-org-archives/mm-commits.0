Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A29C56201
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EC9D22202
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604034702;
	bh=Uv/a7qUuxgNSV9OXsvBVgSQicYfV0M5DZhbY2luSXCo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HJdqY3gy7bhuh+oD2I0tUWQQAgSkgfafRAV/OSaw67gOX8qNvOyogQjHQ/sfvfybC
	 Jtnn3B7Eb5Jlk2y7DIayCmAIQ7oonlIbRGzc8+lmb7/91NHfC1Q0o4XUHKxj4gQqPd
	 GKY46GagBV/L3wir9YMbCQxs920/QWuQeD7U5vVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3FLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3FLl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Oct 2020 01:11:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA0720725;
        Fri, 30 Oct 2020 05:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604034700;
        bh=Uv/a7qUuxgNSV9OXsvBVgSQicYfV0M5DZhbY2luSXCo=;
        h=Date:From:To:Subject:From;
        b=Qox9fiQnrfiiybM7dpEPdGp8CxmW0aPlTKbOsUPjXGCPjXVRgUH22ww8ZOU9/KrXF
         hqAs5YBZobmy7GK96zfyUAvgctudr/EujM+ltfJFt9rkqYNMrZGPAQm8LPRD1jgGnD
         iUggkwYUgf57puZ4WC4ZOzARc8T1APKm8cF/nvMk=
Date:   Thu, 29 Oct 2020 22:11:38 -0700
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, aryabinin@virtuozzo.com, bp@alien8.de,
        davem@davemloft.net, dvyukov@google.com, elver@google.com,
        glider@google.com, herbert@gondor.apana.org.au, hpa@zytor.com,
        joe@perches.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  +
 treewide-remove-stringification-from-__alias-macro-definition.patch added
 to -mm tree
Message-ID: <20201030051138.2u73Icltq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: remove stringification from __alias macro definition
has been added to the -mm tree.  Its filename is
     treewide-remove-stringification-from-__alias-macro-definition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/treewide-remove-stringification-from-__alias-macro-definition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/treewide-remove-stringification-from-__alias-macro-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: treewide: remove stringification from __alias macro definition

Like the old __section macro, the __alias macro uses macro #
stringification to create quotes around the symbol name used in the
__attribute__.

This can cause differences between gcc and clang when the stringification
itself contains a quote character.  So avoid these differences by always
using quotes to define the aliased symbol.

Remove the stringification and add quotes and when necessary a
stringification when existing uses have a ## concatenation.

Unlike the __section macro conversion in commit 33def8498fdd ("treewide:
Convert macro and uses of __section(foo) to __section("foo")") this one
was done by hand.

No other use of __alias exists in the kernel.

This patch does _not_ convert any uses of __attribute__((alias("<foo>")))
so it should not cause any compilation issues.

Link: https://lkml.kernel.org/r/8451df41359b52f048780d19e07b6fa4445b6392.1604026698.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/string.c       |    6 +++---
 arch/x86/include/asm/syscall_wrapper.h  |    2 +-
 drivers/firmware/efi/runtime-wrappers.c |    2 +-
 include/linux/compiler_attributes.h     |    2 +-
 kernel/kcsan/core.c                     |   10 +++++-----
 lib/crc32.c                             |    4 ++--
 lib/crypto/aes.c                        |    4 ++--
 mm/kasan/generic.c                      |    8 ++++----
 8 files changed, 19 insertions(+), 19 deletions(-)

--- a/arch/x86/boot/compressed/string.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/arch/x86/boot/compressed/string.c
@@ -75,7 +75,7 @@ void *memcpy(void *dest, const void *src
 }
 
 #ifdef CONFIG_KASAN
-extern void *__memset(void *s, int c, size_t n) __alias(memset);
-extern void *__memmove(void *dest, const void *src, size_t n) __alias(memmove);
-extern void *__memcpy(void *dest, const void *src, size_t n) __alias(memcpy);
+extern void *__memset(void *s, int c, size_t n) __alias("memset");
+extern void *__memmove(void *dest, const void *src, size_t n) __alias("memmove");
+extern void *__memcpy(void *dest, const void *src, size_t n) __alias("memcpy");
 #endif
--- a/arch/x86/include/asm/syscall_wrapper.h~treewide-remove-stringification-from-__alias-macro-definition
+++ a/arch/x86/include/asm/syscall_wrapper.h
@@ -69,7 +69,7 @@ extern long __ia32_sys_ni_syscall(const
 	long __##abi##_##name(const struct pt_regs *regs);		\
 	ALLOW_ERROR_INJECTION(__##abi##_##name, ERRNO);			\
 	long __##abi##_##name(const struct pt_regs *regs)		\
-		__alias(__do_##name);
+		__alias("__do_" #name);
 
 #define __SYS_STUBx(abi, name, ...)					\
 	long __##abi##_##name(const struct pt_regs *regs);		\
--- a/drivers/firmware/efi/runtime-wrappers.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/drivers/firmware/efi/runtime-wrappers.c
@@ -162,7 +162,7 @@ static DEFINE_SEMAPHORE(efi_runtime_lock
  * Expose the EFI runtime lock to the UV platform
  */
 #ifdef CONFIG_X86_UV
-extern struct semaphore __efi_uv_runtime_lock __alias(efi_runtime_lock);
+extern struct semaphore __efi_uv_runtime_lock __alias("efi_runtime_lock");
 #endif
 
 /*
--- a/include/linux/compiler_attributes.h~treewide-remove-stringification-from-__alias-macro-definition
+++ a/include/linux/compiler_attributes.h
@@ -42,7 +42,7 @@
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alias-function-attribute
  */
-#define __alias(symbol)                 __attribute__((__alias__(#symbol)))
+#define __alias(symbol)                 __attribute__((__alias__(symbol)))
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-aligned-function-attribute
--- a/kernel/kcsan/core.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/kernel/kcsan/core.c
@@ -814,7 +814,7 @@ EXPORT_SYMBOL(__kcsan_check_access);
 	}                                                                      \
 	EXPORT_SYMBOL(__tsan_read##size);                                      \
 	void __tsan_unaligned_read##size(void *ptr)                            \
-		__alias(__tsan_read##size);                                    \
+		__alias("__tsan_read" #size);                                  \
 	EXPORT_SYMBOL(__tsan_unaligned_read##size);                            \
 	void __tsan_write##size(void *ptr);                                    \
 	void __tsan_write##size(void *ptr)                                     \
@@ -823,7 +823,7 @@ EXPORT_SYMBOL(__kcsan_check_access);
 	}                                                                      \
 	EXPORT_SYMBOL(__tsan_write##size);                                     \
 	void __tsan_unaligned_write##size(void *ptr)                           \
-		__alias(__tsan_write##size);                                   \
+		__alias("__tsan_write" #size);                                 \
 	EXPORT_SYMBOL(__tsan_unaligned_write##size);                           \
 	void __tsan_read_write##size(void *ptr);                               \
 	void __tsan_read_write##size(void *ptr)                                \
@@ -833,7 +833,7 @@ EXPORT_SYMBOL(__kcsan_check_access);
 	}                                                                      \
 	EXPORT_SYMBOL(__tsan_read_write##size);                                \
 	void __tsan_unaligned_read_write##size(void *ptr)                      \
-		__alias(__tsan_read_write##size);                              \
+		__alias("__tsan_read_write" #size);                            \
 	EXPORT_SYMBOL(__tsan_unaligned_read_write##size)
 
 DEFINE_TSAN_READ_WRITE(1);
@@ -877,7 +877,7 @@ EXPORT_SYMBOL(__tsan_write_range);
 	}                                                                      \
 	EXPORT_SYMBOL(__tsan_volatile_read##size);                             \
 	void __tsan_unaligned_volatile_read##size(void *ptr)                   \
-		__alias(__tsan_volatile_read##size);                           \
+		__alias("__tsan_volatile_read" #size);                         \
 	EXPORT_SYMBOL(__tsan_unaligned_volatile_read##size);                   \
 	void __tsan_volatile_write##size(void *ptr);                           \
 	void __tsan_volatile_write##size(void *ptr)                            \
@@ -892,7 +892,7 @@ EXPORT_SYMBOL(__tsan_write_range);
 	}                                                                      \
 	EXPORT_SYMBOL(__tsan_volatile_write##size);                            \
 	void __tsan_unaligned_volatile_write##size(void *ptr)                  \
-		__alias(__tsan_volatile_write##size);                          \
+		__alias("__tsan_volatile_write" #size);                        \
 	EXPORT_SYMBOL(__tsan_unaligned_volatile_write##size)
 
 DEFINE_TSAN_VOLATILE_READ_WRITE(1);
--- a/lib/crc32.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/lib/crc32.c
@@ -206,8 +206,8 @@ u32 __pure __weak __crc32c_le(u32 crc, u
 EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
-u32 __pure crc32_le_base(u32, unsigned char const *, size_t) __alias(crc32_le);
-u32 __pure __crc32c_le_base(u32, unsigned char const *, size_t) __alias(__crc32c_le);
+u32 __pure crc32_le_base(u32, unsigned char const *, size_t) __alias("crc32_le");
+u32 __pure __crc32c_le_base(u32, unsigned char const *, size_t) __alias("__crc32c_le");
 
 /*
  * This multiplies the polynomials x and y modulo the given modulus.
--- a/lib/crypto/aes.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/lib/crypto/aes.c
@@ -82,8 +82,8 @@ static volatile const u8 __cacheline_ali
 	0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
 };
 
-extern const u8 crypto_aes_sbox[256] __alias(aes_sbox);
-extern const u8 crypto_aes_inv_sbox[256] __alias(aes_inv_sbox);
+extern const u8 crypto_aes_sbox[256] __alias("aes_sbox");
+extern const u8 crypto_aes_inv_sbox[256] __alias("aes_inv_sbox");
 
 EXPORT_SYMBOL(crypto_aes_sbox);
 EXPORT_SYMBOL(crypto_aes_inv_sbox);
--- a/mm/kasan/generic.c~treewide-remove-stringification-from-__alias-macro-definition
+++ a/mm/kasan/generic.c
@@ -234,7 +234,7 @@ EXPORT_SYMBOL(__asan_unregister_globals)
 		check_memory_region_inline(addr, size, false, _RET_IP_);\
 	}								\
 	EXPORT_SYMBOL(__asan_load##size);				\
-	__alias(__asan_load##size)					\
+	__alias("__asan_load" #size)					\
 	void __asan_load##size##_noabort(unsigned long);		\
 	EXPORT_SYMBOL(__asan_load##size##_noabort);			\
 	void __asan_store##size(unsigned long addr)			\
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(__asan_unregister_globals)
 		check_memory_region_inline(addr, size, true, _RET_IP_);	\
 	}								\
 	EXPORT_SYMBOL(__asan_store##size);				\
-	__alias(__asan_store##size)					\
+	__alias("__asan_store" #size)					\
 	void __asan_store##size##_noabort(unsigned long);		\
 	EXPORT_SYMBOL(__asan_store##size##_noabort)
 
@@ -258,7 +258,7 @@ void __asan_loadN(unsigned long addr, si
 }
 EXPORT_SYMBOL(__asan_loadN);
 
-__alias(__asan_loadN)
+__alias("__asan_loadN")
 void __asan_loadN_noabort(unsigned long, size_t);
 EXPORT_SYMBOL(__asan_loadN_noabort);
 
@@ -268,7 +268,7 @@ void __asan_storeN(unsigned long addr, s
 }
 EXPORT_SYMBOL(__asan_storeN);
 
-__alias(__asan_storeN)
+__alias("__asan_storeN")
 void __asan_storeN_noabort(unsigned long, size_t);
 EXPORT_SYMBOL(__asan_storeN_noabort);
 
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
treewide-remove-stringification-from-__alias-macro-definition.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch

