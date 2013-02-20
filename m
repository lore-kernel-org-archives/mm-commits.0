From: akpm@linux-foundation.org
Subject: + arm-wire-up-kcmp-syscall.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:16:49 -0800
Message-ID: <20130220231649.9CB7331C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35924 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3BTXQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:16:50 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so859349vch.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:16:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alekskartashov@parallels.com, gorcunov@openvz.org, linux@arm.linux.org.uk


The patch titled
     Subject: arm: wire up kcmp syscall
has been added to the -mm tree.  Its filename is
     arm-wire-up-kcmp-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arm-wire-up-kcmp-syscall.patch

