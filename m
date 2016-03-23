From: akpm@linux-foundation.org
Subject: [merged] sparc-syscall-fix-syscall_get_arch.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:40:35 -0700
Message-ID: <56f2d513.MSlOLLg12yPCfq4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcCWRkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/syscall: fix syscall_get_arch
has been removed from the -mm tree.  Its filename was
     sparc-syscall-fix-syscall_get_arch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: sparc/syscall: fix syscall_get_arch

Sparc's syscall_get_arch was buggy: it returned the task arch, not the
syscall arch.  This could confuse seccomp and audit.

I don't think this is as bad for seccomp as it looks: sparc's 32-bit and
64-bit syscalls are numbered the same.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/syscall.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/syscall.h~sparc-syscall-fix-syscall_get_arch arch/sparc/include/asm/syscall.h
--- a/arch/sparc/include/asm/syscall.h~sparc-syscall-fix-syscall_get_arch
+++ a/arch/sparc/include/asm/syscall.h
@@ -3,6 +3,7 @@
 
 #include <uapi/linux/audit.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/sched.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
@@ -128,7 +129,13 @@ static inline void syscall_set_arguments
 
 static inline int syscall_get_arch(void)
 {
-	return is_32bit_task() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
+#if defined(CONFIG_SPARC64) && defined(CONFIG_COMPAT)
+	return in_compat_syscall() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
+#elif defined(CONFIG_SPARC64)
+	return AUDIT_ARCH_SPARC64;
+#else
+	return AUDIT_ARCH_SPARC;
+#endif
 }
 
 #endif /* __ASM_SPARC_SYSCALL_H */
_

Patches currently in -mm which might be from luto@kernel.org are


