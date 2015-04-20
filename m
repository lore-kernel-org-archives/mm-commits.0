From: akpm@linux-foundation.org
Subject: [merged] arm-use-asm-generic-for-seccomph.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:20:29 -0700
Message-ID: <5535517d./vhr4CRvr3ac1JBn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbDTTOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, lauraa@codeaurora.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     arm-use-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: arm: use asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions. Definitions were identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/Kbuild    |    1 +
 arch/arm/include/asm/seccomp.h |   11 -----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff -puN arch/arm/include/asm/Kbuild~arm-use-asm-generic-for-seccomph arch/arm/include/asm/Kbuild
--- a/arch/arm/include/asm/Kbuild~arm-use-asm-generic-for-seccomph
+++ a/arch/arm/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
 generic-y += scatterlist.h
+generic-y += seccomp.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += sembuf.h
diff -puN arch/arm/include/asm/seccomp.h~arm-use-asm-generic-for-seccomph /dev/null
--- a/arch/arm/include/asm/seccomp.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_ARM_SECCOMP_H
-#define _ASM_ARM_SECCOMP_H
-
-#include <linux/unistd.h>
-
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_rt_sigreturn
