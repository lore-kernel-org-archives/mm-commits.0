From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
 removed from -mm tree
Date: Wed, 29 Jul 2015 11:13:11 -0700
Message-ID: <55b917b7.cBG+Lg/KXu3proWh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbbG2SNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@kernel.org, emunson@akamai.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix up new locking syscalls
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: mm: fix up new locking syscalls

Extend the arm64 compat syscall table for the new syscalls to fix build
errors introduced by "mm: mlock: add new mlock, munlock, and munlockall
system calls":

 ../arch/arm64/include/asm/unistd32.h:801:1: error: array index in initializer exceeds array bounds
 ../arch/arm64/include/asm/unistd32.h:801:1: error: (near initialization for 'compat_sys_call_table')
 ../arch/arm64/include/asm/unistd32.h:803:1: error: array index in initializer exceeds array bounds
 ../arch/arm64/include/asm/unistd32.h:803:1: error: (near initialization for 'compat_sys_call_table')
 ../arch/arm64/include/asm/unistd32.h:805:1: error: array index in initializer exceeds array bounds
 ../arch/arm64/include/asm/unistd32.h:805:1: error: (near initialization for 'compat_sys_call_table')

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix arch/arm64/include/asm/unistd.h
--- a/arch/arm64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix
+++ a/arch/arm64/include/asm/unistd.h
@@ -44,7 +44,7 @@
 #define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
 
-#define __NR_compat_syscalls		388
+#define __NR_compat_syscalls		391
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
_

Patches currently in -mm which might be from broonie@kernel.org are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
linux-next.patch

