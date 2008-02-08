From: akpm@linux-foundation.org
Subject: - m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:00 -0800
Message-ID: <200802080808.m1888f5u014675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYBHITD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: build fix of arch/m32r/kernel/smpboot.c
has been removed from the -mm tree.  Its filename was
     m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: build fix of arch/m32r/kernel/smpboot.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch is for Mathieu Desnoyers's include/asm-m32r/local.h.
Applying the new include/asm-m32r/local.h, inclusion of linux/sched.h
is needed to fix a build error of arch/m32r/kernel/smpboot.c.

<--  snip  -->
  ...
  CC      arch/m32r/kernel/smpboot.o
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'do_boot_cpu':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: error: implicit declaration of function 'fork_idle'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: warning: assignment makes pointer from integer without a cast
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:283: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:289: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: implicit declaration of function 'task_thread_info'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: invalid type argument of '->'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'start_secondary':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:429: error: implicit declaration of function 'cpu_init'
make[2]: *** [arch/m32r/kernel/smpboot.o] Error 1
<--  snip  -->

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/kernel/smpboot.c~m32r-build-fix-of-arch-m32r-kernel-smpbootc arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-build-fix-of-arch-m32r-kernel-smpbootc
+++ a/arch/m32r/kernel/smpboot.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/irq.h>
 #include <linux/bootmem.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
