From: akpm@linux-foundation.org
Subject: [merged] h8300-time-add-missing-include-asm-irq_regsh.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:56 -0700
Message-ID: <20120712193656.B5077100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:57 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300/time: add missing #include <asm/irq_regs.h>
has been removed from the -mm tree.  Its filename was
     h8300-time-add-missing-include-asm-irq_regsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300/time: add missing #include <asm/irq_regs.h>

arch/h8300/kernel/time.c: In function 'h8300_timer_tick':
arch/h8300/kernel/time.c:39:2: error: implicit declaration of function 'get_irq_regs' [-Werror=implicit-function-declaration]
arch/h8300/kernel/time.c:39:42: error: invalid type argument of '->' (have 'int')

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/h8300/kernel/time.c~h8300-time-add-missing-include-asm-irq_regsh arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~h8300-time-add-missing-include-asm-irq_regsh
+++ a/arch/h8300/kernel/time.c
@@ -27,6 +27,7 @@
 #include <linux/profile.h>
 
 #include <asm/io.h>
+#include <asm/irq_regs.h>
 #include <asm/timer.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

