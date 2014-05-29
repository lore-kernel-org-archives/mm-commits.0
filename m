From: akpm@linux-foundation.org
Subject: + idle-remove-cpu_idle-forward-declarations.patch added to -mm
 tree
Date: Thu, 29 May 2014 16:00:36 -0700
Message-ID: <5387bc14.s/EL5cNBtRh4Chp0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaE2XAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 19:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, geert+renesas@glider.be

Subject: + idle-remove-cpu_idle-forward-declarations.patch added to -mm tree
To: geert+renesas@glider.be,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 16:00:36 -0700


The patch titled
     Subject: idle: remove cpu_idle() forward declarations
has been added to the -mm tree.  Its filename is
     idle-remove-cpu_idle-forward-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idle-remove-cpu_idle-forward-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idle-remove-cpu_idle-forward-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: idle: remove cpu_idle() forward declarations

After all architectures were converted to the generic idle framework,
d190e8195b90 ("idle: Remove GENERIC_IDLE_LOOP config switch") removed the
last caller of cpu_idle().  The forward declarations in header files were
forgotten.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    1 -
 include/linux/smp.h |    2 --
 2 files changed, 3 deletions(-)

diff -puN include/linux/cpu.h~idle-remove-cpu_idle-forward-declarations include/linux/cpu.h
--- a/include/linux/cpu.h~idle-remove-cpu_idle-forward-declarations
+++ a/include/linux/cpu.h
@@ -256,7 +256,6 @@ enum cpuhp_state {
 };
 
 void cpu_startup_entry(enum cpuhp_state state);
-void cpu_idle(void);
 
 void cpu_idle_poll_ctrl(bool enable);
 
diff -puN include/linux/smp.h~idle-remove-cpu_idle-forward-declarations include/linux/smp.h
--- a/include/linux/smp.h~idle-remove-cpu_idle-forward-declarations
+++ a/include/linux/smp.h
@@ -13,8 +13,6 @@
 #include <linux/init.h>
 #include <linux/llist.h>
 
-extern void cpu_idle(void);
