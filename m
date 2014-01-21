From: akpm@linux-foundation.org
Subject: + arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch
 added to -mm tree
Date: Tue, 21 Jan 2014 11:44:33 -0800
Message-ID: <52dece21./lF5g1QpmQOkb0F1%akpm__17749.4013253183$1390333484$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaAUToe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org, geert+renesas@linux-m68k.org, fengguang.wu@intel.com, gaowanlong@cn.fujitsu.com

Subject: + arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch added to -mm tree
To: gaowanlong@cn.fujitsu.com,fengguang.wu@intel.com,geert+renesas@linux-m68k.org,gregkh@linuxfoundation.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:44:33 -0800


The patch titled
     Subject: arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>
has been added to the -mm tree.  Its filename is
     arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch
linux-next.patch

