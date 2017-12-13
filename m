From: akpm@linux-foundation.org
Subject: [merged]
 kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch removed from
 -mm tree
Date: Wed, 13 Dec 2017 14:26:06 -0800
Message-ID: <20171213222606.i3FO70_q0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdLMW0I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 17:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, keescook@chromium.org, labbott@redhat.com, mark.rutland@arm.com, mingo@elte.hu, mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com


The patch titled
     Subject: Kconfig: make STRICT_DEVMEM default-y on x86 and arm64
has been removed from the -mm tree.  Its filename was
     kconfig-make-strict_devmem-default-y-on-x86-and-arm64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1991,7 +1991,7 @@ config STRICT_DEVMEM
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

