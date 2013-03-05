From: akpm@linux-foundation.org
Subject: [merged] arm-wire-up-kcmp-syscall.patch removed from -mm tree
Date: Tue, 05 Mar 2013 12:15:37 -0800
Message-ID: <20130305201537.6AFBE31C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50494 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3CEUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 15:15:38 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so777984yen.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 12:15:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alekskartashov@parallels.com, gorcunov@openvz.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: wire up kcmp syscall
has been removed from the -mm tree.  Its filename was
     arm-wire-up-kcmp-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kartashov <alekskartashov@parallels.com>
Subject: arm: wire up kcmp syscall

Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/uapi/asm/unistd.h |    2 +-
 arch/arm/kernel/calls.S            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/uapi/asm/unistd.h~arm-wire-up-kcmp-syscall arch/arm/include/uapi/asm/unistd.h
--- a/arch/arm/include/uapi/asm/unistd.h~arm-wire-up-kcmp-syscall
+++ a/arch/arm/include/uapi/asm/unistd.h
@@ -404,7 +404,7 @@
 #define __NR_setns			(__NR_SYSCALL_BASE+375)
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
-					/* 378 for kcmp */
+#define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
 
 /*
diff -puN arch/arm/kernel/calls.S~arm-wire-up-kcmp-syscall arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~arm-wire-up-kcmp-syscall
+++ a/arch/arm/kernel/calls.S
@@ -387,7 +387,7 @@
 /* 375 */	CALL(sys_setns)
 		CALL(sys_process_vm_readv)
 		CALL(sys_process_vm_writev)
-		CALL(sys_ni_syscall)	/* reserved for sys_kcmp */
+		CALL(sys_kcmp)
 		CALL(sys_finit_module)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
_

Patches currently in -mm which might be from alekskartashov@parallels.com are

linux-next.patch

