From: akpm@linux-foundation.org
Subject: [merged] kcmp-make-it-depend-on-checkpoint_restore.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:18:13 -0800
Message-ID: <20130228201813.B42F931C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47934 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3B1USO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:14 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246954yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:18:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, hpa@zytor.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp: make it depend on CHECKPOINT_RESTORE
has been removed from the -mm tree.  Its filename was
     kcmp-make-it-depend-on-checkpoint_restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: kcmp: make it depend on CHECKPOINT_RESTORE

Since kcmp syscall has been implemented (initially on x86 architecture) a
number of other archs wire it up as well: xtensa, sparc, sh, s390, mips,
microblaze, m68k (not taking into account those who uses
<asm-generic/unistd.h> for syscall numbers definitions).

But the Makefile, which turns kcmp.o generation on still depends on former
config-x86.  Thus get rid of this limitation and make kcmp.o depend on
CHECKPOINT_RESTORE option.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/Makefile~kcmp-make-it-depend-on-checkpoint_restore kernel/Makefile
--- a/kernel/Makefile~kcmp-make-it-depend-on-checkpoint_restore
+++ a/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
arm-wire-up-kcmp-syscall.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

