From: akpm@linux-foundation.org
Subject: [patch 82/96] CRIS: gpio: move inline before return type
Date: Wed, 12 Jul 2017 14:37:10 -0700
Message-ID: <20170712213710.DmF2F7ldp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753410AbdGLVhM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jesper.nilsson@axis.com, joe@perches.com, mm-commits@vger.kernel.org, starvik@axis.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: CRIS: gpio: move inline before return type

Move inline to be like the rest of the kernel.

Link: http://lkml.kernel.org/r/6bf1bec049897c4158f698b866810f47c728f233.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/drivers/gpio.c~cris-gpio-move-inline-before-return-type arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~cris-gpio-move-inline-before-return-type
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -399,7 +399,7 @@ out:
 /* Main device API. ioctl's to read/set/clear bits, as well as to
  * set alarms to wait for using a subsequent select().
  */
-unsigned long inline setget_input(struct gpio_private *priv, unsigned long arg)
+inline unsigned long setget_input(struct gpio_private *priv, unsigned long arg)
 {
 	/* Set direction 0=unchanged 1=input,
 	 * return mask with 1=input */
@@ -450,7 +450,7 @@ unsigned long inline setget_input(struct
 	return dir_g_in_bits;
 } /* setget_input */
 
-unsigned long inline setget_output(struct gpio_private *priv, unsigned long arg)
+inline unsigned long setget_output(struct gpio_private *priv, unsigned long arg)
 {
 	if (USE_PORTS(priv)) {
 		*priv->dir = *priv->dir_shadow |=
_
