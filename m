From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:21:33 -0700
Message-ID: <596692dd.r/2sgWpsbdBucTBP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdGLVVf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: fix fortified memcpy
has been removed from the -mm tree.  Its filename was
     include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

This patch was dropped because it was folded into include-linux-stringh-add-the-option-of-fortified-stringh-functions.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: x86: fix fortified memcpy

__memcpy3d is not available when CONFIG_FORTIFY_SOURCE is enabled,
leading to a link error on 32-bit kernels:

arch/x86/lib/memcpy_32.c: In function 'memcpy':
arch/x86/lib/memcpy_32.c:10:9: error: implicit declaration of function '__memcpy3d'; did you mean '__memcpy'? [-Werror=implicit-function-declaration]

This uses the same #ifdef around the use of the function that
now protects the definition.

Fixes: mmotm ("include/linux/string.h: add the option of fortified string.h functions")
Link: http://lkml.kernel.org/r/20170627150047.660360-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/memcpy_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/lib/memcpy_32.c~include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix arch/x86/lib/memcpy_32.c
--- a/arch/x86/lib/memcpy_32.c~include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix
+++ a/arch/x86/lib/memcpy_32.c
@@ -6,7 +6,7 @@
 
 __visible void *memcpy(void *to, const void *from, size_t n)
 {
-#ifdef CONFIG_X86_USE_3DNOW
+#if defined(CONFIG_X86_USE_3DNOW) && !defined(CONFIG_FORTIFY_SOURCE)
 	return __memcpy3d(to, from, n);
 #else
 	return __memcpy(to, from, n);
_

Patches currently in -mm which might be from arnd@arndb.de are

include-linux-stringh-add-the-option-of-fortified-stringh-functions.patch

