From: akpm@linux-foundation.org
Subject: + sysrq-include-interrupth-instead-of-irqh.patch added to -mm tree
Date: Tue, 27 Jan 2009 15:24:08 -0800
Message-ID: <200901272324.n0RNO8WS027365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbZA0XYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 18:24:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, travis@sgi.com


The patch titled
     sysrq: include interrupt.h instead of irq.h
has been added to the -mm tree.  Its filename is
     sysrq-include-interrupth-instead-of-irqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
alpha-use-syscall-wrappers.patch
linux-next.patch
sysrq-include-interrupth-instead-of-irqh.patch
kmalloc-return-null-instead-of-link-failure.patch

