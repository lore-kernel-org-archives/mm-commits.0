From: akpm@linux-foundation.org
Subject: +
 include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch added to -mm tree
Date: Tue, 27 Jun 2017 13:04:24 -0700
Message-ID: <5952ba48.THalMImI/s7n9Xk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbdF0UEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 16:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: fix fortified memcpy
has been added to the -mm tree.  Its filename is
     include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch
kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

