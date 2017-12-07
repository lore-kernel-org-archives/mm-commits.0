From: akpm@linux-foundation.org
Subject: + kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch
 added to -mm tree
Date: Wed, 06 Dec 2017 16:53:04 -0800
Message-ID: <5a2890f0.zJSyv4VKjeVkXMSm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbdLGAxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:53:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, hpa@zytor.com, labbott@redhat.com, mark.rutland@arm.com, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: make STRICT_DEVMEM default-y on x86 and arm64
has been added to the -mm tree.  Its filename is
     kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Kconfig: make STRICT_DEVMEM default-y on x86 and arm64

Distros have been shipping with CONFIG_STRICT_DEVMEM=y for years now.  It
is probably time to flip this default for x86 and arm64.

Link: http://lkml.kernel.org/r/20171201201000.GA44539@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~kconfig-make-strict_devmem-default-y-on-x86-and-arm64 lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-make-strict_devmem-default-y-on-x86-and-arm64
+++ a/lib/Kconfig.debug
@@ -1985,7 +1985,7 @@ config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
 	depends on MMU && DEVMEM
 	depends on ARCH_HAS_DEVMEM_IS_ALLOWED
-	default y if TILE || PPC
+	default y if TILE || PPC || X86 || ARM64
 	---help---
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
_

Patches currently in -mm which might be from keescook@chromium.org are

makefile-move-stack-protector-compiler-breakage-test-earlier.patch
makefile-move-stack-protector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch

