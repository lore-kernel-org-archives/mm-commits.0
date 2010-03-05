From: akpm@linux-foundation.org
Subject: [folded] gpio-pca953xc-add-interrupt-handling-capability-v4.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:26:28 -0800
Message-ID: <201003052126.o25LQSmQ028610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab0CEV1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:27:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maz@misterjones.org, david-b@pacbell.net, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     gpio-pca953xc-add-interrupt-handling-capability-v4
has been removed from the -mm tree.  Its filename was
     gpio-pca953xc-add-interrupt-handling-capability-v4.patch

This patch was dropped because it was folded into gpio-pca953xc-add-interrupt-handling-capability.patch

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
gpio-pca953xc-add-interrupt-handling-capability-v4.patch

