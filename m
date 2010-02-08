From: akpm@linux-foundation.org
Subject: + gpio-pca953xc-add-interrupt-handling-capability-v4.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:08:15 -0800
Message-ID: <201002082108.o18L8FIg003048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab0BHVJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, david-b@pacbell.net, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, ncase@xes-inc.com


The patch titled
     gpio-pca953xc-add-interrupt-handling-capability-v4
has been added to the -mm tree.  Its filename is
     gpio-pca953xc-add-interrupt-handling-capability-v4.patch

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
Subject: gpio-pca953xc-add-interrupt-handling-capability-v4
From: Marc Zyngier <maz@misterjones.org>

- Fix compilation issue on anything but ARM
- Remove unnecessary inlines, courtesy of Andrew Morton

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Nate Case <ncase@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability-v4 drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability-v4
+++ a/drivers/gpio/pca953x.c
@@ -371,7 +371,11 @@ static int pca953x_irq_setup(struct pca9
 			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_edge_irq);
 			set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
+#else
+			set_irq_noprobe(irq);
+#endif
 		}
 
 		ret = request_threaded_irq(client->irq,
@@ -413,7 +417,7 @@ static int pca953x_irq_setup(struct pca9
 	return 0;
 }
 
-static inline void pca953x_irq_teardown(struct pca953x_chip *chip)
+static void pca953x_irq_teardown(struct pca953x_chip *chip)
 {
 }
 #endif
_

Patches currently in -mm which might be from maz@misterjones.org are

gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-pca953xc-add-interrupt-handling-capability-v4.patch

