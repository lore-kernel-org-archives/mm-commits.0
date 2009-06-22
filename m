From: akpm@linux-foundation.org
Subject: + serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch added to -mm tree
Date: Mon, 22 Jun 2009 14:54:52 -0700
Message-ID: <200906222154.n5MLsqM1029308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbZFVV4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, stable@kernel.org


The patch titled
     serial: bfin_5xx: fix building as module when early printk is enabled
has been added to the -mm tree.  Its filename is
     serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch

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
Subject: serial: bfin_5xx: fix building as module when early printk is enabled
From: Mike Frysinger <vapier@gentoo.org>

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled
+++ a/drivers/serial/bfin_5xx.c
@@ -38,6 +38,10 @@
 #include <asm/cacheflush.h>
 #endif
 
+#ifdef CONFIG_SERIAL_BFIN_MODULE
+# undef CONFIG_EARLY_PRINTK
+#endif
+
 /* UART name and device definitions */
 #define BFIN_SERIAL_NAME	"ttyBF"
 #define BFIN_SERIAL_MAJOR	204
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-add-missing-spin_lock-init.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch

