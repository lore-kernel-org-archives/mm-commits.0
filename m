From: akpm@linux-foundation.org
Subject: [merged]
 arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch removed from
 -mm tree
Date: Wed, 22 Jan 2014 12:12:03 -0800
Message-ID: <52e02613.Yc9N6elCFJPschC8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaAVUME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org, geert+renesas@linux-m68k.org, fengguang.wu@intel.com, gaowanlong@cn.fujitsu.com

Subject: [merged] arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch removed from -mm tree
To: gaowanlong@cn.fujitsu.com,fengguang.wu@intel.com,geert+renesas@linux-m68k.org,gregkh@linuxfoundation.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:03 -0800


The patch titled
     Subject: arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>
has been removed from the -mm tree.  Its filename was
     arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in

This is introduced by 16559ae48c7 ("kgdb: remove #include
<linux/serial_8250.h> from kgdb.h").

[geert@linux-m68k.org: reworded and reformatted]
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/kgdb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sh/kernel/kgdb.c~arch-sh-kernel-kgdbc-add-missing-include-linux-schedh arch/sh/kernel/kgdb.c
--- a/arch/sh/kernel/kgdb.c~arch-sh-kernel-kgdbc-add-missing-include-linux-schedh
+++ a/arch/sh/kernel/kgdb.c
@@ -13,6 +13,7 @@
 #include <linux/kdebug.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
 
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch

