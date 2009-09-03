From: akpm@linux-foundation.org
Subject: + pcmcia-cleanup-fixup-patch-for-sa1100_jornada_pcmcia-driver.patch added to -mm tree
Date: Thu, 03 Sep 2009 14:37:28 -0700
Message-ID: <200909032137.n83LbS8V005996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256AbZICVhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 17:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com, linux@dominikbrodowski.net


The patch titled
     pcmcia: cleanup/fixup patch for sa1100_jornada_pcmcia driver
has been added to the -mm tree.  Its filename is
     pcmcia-cleanup-fixup-patch-for-sa1100_jornada_pcmcia-driver.patch

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
Subject: pcmcia: cleanup/fixup patch for sa1100_jornada_pcmcia driver
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Clean up the /drivers/pcmcia/sa1100_jornada.c file with respect to
formatting.  It also changes a build warning into a code comment (since
its a pain to watch every build and havent seen any problems with driver
in 3.5years).

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/sa1100_jornada720.c |  146 ++++++++++++++-------------
 1 file changed, 80 insertions(+), 66 deletions(-)

diff -puN drivers/pcmcia/sa1100_jornada720.c~pcmcia-cleanup-fixup-patch-for-sa1100_jornada_pcmcia-driver drivers/pcmcia/sa1100_jornada720.c
--- a/drivers/pcmcia/sa1100_jornada720.c~pcmcia-cleanup-fixup-patch-for-sa1100_jornada_pcmcia-driver
+++ a/drivers/pcmcia/sa1100_jornada720.c
@@ -16,89 +16,103 @@
 
 #include "sa1111_generic.h"
 
-#define SOCKET0_POWER   GPIO_GPIO0
-#define SOCKET0_3V      GPIO_GPIO2
-#define SOCKET1_POWER   (GPIO_GPIO1 | GPIO_GPIO3)
-#warning *** Does SOCKET1_3V actually do anything?
+/* Does SOCKET1_3V actually do anything? */
+#define SOCKET0_POWER	GPIO_GPIO0
+#define SOCKET0_3V	GPIO_GPIO2
+#define SOCKET1_POWER	(GPIO_GPIO1 | GPIO_GPIO3)
 #define SOCKET1_3V	GPIO_GPIO3
 
 static int jornada720_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
-  /*
-   * What is all this crap for?
-   */
-  GRER |= 0x00000002;
-  /* Set GPIO_A<3:1> to be outputs for PCMCIA/CF power controller: */
-  sa1111_set_io_dir(SA1111_DEV(skt->dev), GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0, 0);
-  sa1111_set_io(SA1111_DEV(skt->dev), GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0);
-  sa1111_set_sleep_io(SA1111_DEV(skt->dev), GPIO_A0|GPIO_A1|GPIO_A2|GPIO_A3, 0);
+	unsigned int pin = GPIO_A0 | GPIO_A1 | GPIO_A2 | GPIO_A3;
 
-  return sa1111_pcmcia_hw_init(skt);
+	/*
+	* What is all this crap for?
+	*/
+	GRER |= 0x00000002;
+	/* Set GPIO_A<3:1> to be outputs for PCMCIA/CF power controller: */
+	sa1111_set_io_dir(SA1111_DEV(skt->dev), pin, 0, 0);
+	sa1111_set_io(SA1111_DEV(skt->dev), pin, 0);
+	sa1111_set_sleep_io(SA1111_DEV(skt->dev), pin, 0);
+
+	return sa1111_pcmcia_hw_init(skt);
 }
 
 static int
 jornada720_pcmcia_configure_socket(struct soc_pcmcia_socket *skt, const socket_state_t *state)
 {
-  unsigned int pa_dwr_mask, pa_dwr_set;
-  int ret;
+	unsigned int pa_dwr_mask, pa_dwr_set;
+	int ret;
 
-printk("%s(): config socket %d vcc %d vpp %d\n", __func__,
-	skt->nr, state->Vcc, state->Vpp);
+	printk(KERN_INFO "%s(): config socket %d vcc %d vpp %d\n", __func__,
+		skt->nr, state->Vcc, state->Vpp);
 
-  switch (skt->nr) {
-  case 0:
-    pa_dwr_mask = SOCKET0_POWER | SOCKET0_3V;
-
-    switch (state->Vcc) {
-    default:
-    case 0:	pa_dwr_set = 0;					break;
-    case 33:	pa_dwr_set = SOCKET0_POWER | SOCKET0_3V;	break;
-    case 50:	pa_dwr_set = SOCKET0_POWER;			break;
-    }
-    break;
-
-  case 1:
-    pa_dwr_mask = SOCKET1_POWER;
-
-    switch (state->Vcc) {
-    default:
-    case 0:	pa_dwr_set = 0;					break;
-    case 33:	pa_dwr_set = SOCKET1_POWER;			break;
-    case 50:	pa_dwr_set = SOCKET1_POWER;			break;
-    }
-    break;
-
-  default:
-    return -1;
-  }
-
-  if (state->Vpp != state->Vcc && state->Vpp != 0) {
-    printk(KERN_ERR "%s(): slot cannot support VPP %u\n",
-	   __func__, state->Vpp);
-    return -1;
-  }
-
-  ret = sa1111_pcmcia_configure_socket(skt, state);
-  if (ret == 0) {
-    unsigned long flags;
-
-    local_irq_save(flags);
-    sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, pa_dwr_set);
-    local_irq_restore(flags);
-  }
+	switch (skt->nr) {
+	case 0:
+		pa_dwr_mask = SOCKET0_POWER | SOCKET0_3V;
+
+		switch (state->Vcc) {
+		default:
+		case  0:
+			pa_dwr_set = 0;
+			break;
+		case 33:
+			pa_dwr_set = SOCKET0_POWER | SOCKET0_3V;
+			break;
+		case 50:
+			pa_dwr_set = SOCKET0_POWER;
+			break;
+		}
+		break;
+
+	case 1:
+		pa_dwr_mask = SOCKET1_POWER;
+
+		switch (state->Vcc) {
+		default:
+		case 0:
+			pa_dwr_set = 0;
+			break;
+		case 33:
+			pa_dwr_set = SOCKET1_POWER;
+			break;
+		case 50:
+			pa_dwr_set = SOCKET1_POWER;
+			break;
+		}
+		break;
+
+	default:
+		return -1;
+	}
+
+	if (state->Vpp != state->Vcc && state->Vpp != 0) {
+		printk(KERN_ERR "%s(): slot cannot support VPP %u\n",
+			__func__, state->Vpp);
+		return -EPERM;
+	}
+
+	ret = sa1111_pcmcia_configure_socket(skt, state);
+	if (ret == 0) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		sa1111_set_io(SA1111_DEV(skt->dev), pa_dwr_mask, pa_dwr_set);
+		local_irq_restore(flags);
+	}
 
-  return ret;
+	return ret;
 }
 
 static struct pcmcia_low_level jornada720_pcmcia_ops = {
-  .owner		= THIS_MODULE,
-  .hw_init		= jornada720_pcmcia_hw_init,
-  .hw_shutdown		= sa1111_pcmcia_hw_shutdown,
-  .socket_state		= sa1111_pcmcia_socket_state,
-  .configure_socket	= jornada720_pcmcia_configure_socket,
+	.owner			= THIS_MODULE,
+	.hw_init		= jornada720_pcmcia_hw_init,
+	.hw_shutdown		= sa1111_pcmcia_hw_shutdown,
+	.socket_state		= sa1111_pcmcia_socket_state,
+	.configure_socket	= jornada720_pcmcia_configure_socket,
 
-  .socket_init		= sa1111_pcmcia_socket_init,
-  .socket_suspend	= sa1111_pcmcia_socket_suspend,
+	.socket_init		= sa1111_pcmcia_socket_init,
+	.socket_suspend		= sa1111_pcmcia_socket_suspend,
 };
 
 int __devinit pcmcia_jornada720_init(struct device *dev)
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

pcmcia-cleanup-fixup-patch-for-sa1100_jornada_pcmcia-driver.patch

