From: akpm@linux-foundation.org
Subject: [merged] sysrq-include-interrupth-instead-of-irqh.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:03 -0800
Message-ID: <200902021937.n12Jb30a013702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbZBBThu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sysrq: include interrupt.h instead of irq.h
has been removed from the -mm tree.  Its filename was
     sysrq-include-interrupth-instead-of-irqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: include interrupt.h instead of irq.h
From: Heiko Carstens <heiko.carstens@de.ibm.com>

With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
we get this compile bug on s390:

  CC      drivers/char/sysrq.o
In file included from drivers/char/sysrq.c:38:
include/linux/irq.h: In function 'init_alloc_desc_masks':
include/linux/irq.h:442: error: dereferencing pointer to incomplete type

drivers/char/sysrq.c should include interrupt.h instead of irq.h.

Cc: Mike Travis <travis@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~sysrq-include-interrupth-instead-of-irqh drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-include-interrupth-instead-of-irqh
+++ a/drivers/char/sysrq.c
@@ -35,7 +35,7 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
do_wp_page-fix-regression-with-execute-in-place.patch
linux-next.patch
mm-unify-some-pmd_-functions-fix.patch

