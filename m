Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5A0C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259C72312D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgLPEo6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgLPEo6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:58 -0500
Date:   Tue, 15 Dec 2020 20:44:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093858;
        bh=LMlRxdvcwxTv/+vkbMYwBrOMOQUzcoLXDtIrYmwa96k=;
        h=From:To:Subject:In-Reply-To:From;
        b=iN5K/wDMhP2xXUFZYmbzAuDxRo40KV/xi32Dfq04bWyYl026G2Q8pxjOKq3XK+mk4
         44DaZzNY3aE/btNdNmWKt1N3d6CThzl8GUcQTIzf/+X39h0EuhAq81YRg4XnUtKZL8
         Cn6ziOQOh6sOiJCNV0belh5WlZEm4B3tuQSml54A=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        linux-mm@kvack.org, michal.simek@xilinx.com,
        mm-commits@vger.kernel.org, syednwaris@gmail.com,
        torvalds@linux-foundation.org, vilhelm.gray@gmail.com
Subject:  [patch 36/95] gpio: xilinx: utilize generic
 bitmap_get_value and _set_value
Message-ID: <20201216044417.jxrGP_B8A%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Syed Nayyar Waris <syednwaris@gmail.com>
Subject: gpio: xilinx: utilize generic bitmap_get_value and _set_value

Reimplement the xgpio_set_multiple() function in
drivers/gpio/gpio-xilinx.c to use the new generic functions:
bitmap_get_value() and bitmap_set_value().  The code is now simpler to
read and understand.  Moreover, instead of looping for each bit in
xgpio_set_multiple() function, now we can check each channel at a time and
save cycles.

Link: https://lkml.kernel.org/r/15a044d3ba23f00c31fd09437bdd3e5924bb91cd.1603055402.git.syednwaris@gmail.com
Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpio-xilinx.c |   61 +++++++++++++++++------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

--- a/drivers/gpio/gpio-xilinx.c~gpio-xilinx-utilize-generic-bitmap_get_value-and-_set_value
+++ a/drivers/gpio/gpio-xilinx.c
@@ -138,37 +138,37 @@ static void xgpio_set_multiple(struct gp
 {
 	unsigned long flags;
 	struct xgpio_instance *chip = gpiochip_get_data(gc);
-	int index = xgpio_index(chip, 0);
-	int offset, i;
+	u32 *const state = chip->gpio_state;
+	unsigned int *const width = chip->gpio_width;
 
-	spin_lock_irqsave(&chip->gpio_lock[index], flags);
-
-	/* Write to GPIO signals */
-	for (i = 0; i < gc->ngpio; i++) {
-		if (*mask == 0)
-			break;
-		/* Once finished with an index write it out to the register */
-		if (index !=  xgpio_index(chip, i)) {
-			xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET +
-				       index * XGPIO_CHANNEL_OFFSET,
-				       chip->gpio_state[index]);
-			spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
-			index =  xgpio_index(chip, i);
-			spin_lock_irqsave(&chip->gpio_lock[index], flags);
-		}
-		if (__test_and_clear_bit(i, mask)) {
-			offset =  xgpio_offset(chip, i);
-			if (test_bit(i, bits))
-				chip->gpio_state[index] |= BIT(offset);
-			else
-				chip->gpio_state[index] &= ~BIT(offset);
-		}
-	}
+	DECLARE_BITMAP(old, 64);
+	DECLARE_BITMAP(new, 64);
+	DECLARE_BITMAP(changed, 64);
+
+	spin_lock_irqsave(&chip->gpio_lock[0], flags);
+	spin_lock(&chip->gpio_lock[1]);
+
+	bitmap_set_value(old, state[0], 0, width[0]);
+	bitmap_set_value(old, state[1], width[0], width[1]);
+	bitmap_replace(new, old, bits, mask, gc->ngpio);
+
+	bitmap_set_value(old, state[0], 0, 32);
+	bitmap_set_value(old, state[1], 32, 32);
+	state[0] = bitmap_get_value(new, 0, width[0]);
+	state[1] = bitmap_get_value(new, width[0], width[1]);
+	bitmap_set_value(new, state[0], 0, 32);
+	bitmap_set_value(new, state[1], 32, 32);
+	bitmap_xor(changed, old, new, 64);
+
+	if (((u32 *)changed)[0])
+		xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET,
+				state[0]);
+	if (((u32 *)changed)[1])
+		xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET +
+				XGPIO_CHANNEL_OFFSET, state[1]);
 
-	xgpio_writereg(chip->regs + XGPIO_DATA_OFFSET +
-		       index * XGPIO_CHANNEL_OFFSET, chip->gpio_state[index]);
-
-	spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
+	spin_unlock(&chip->gpio_lock[1]);
+	spin_unlock_irqrestore(&chip->gpio_lock[0], flags);
 }
 
 /**
@@ -292,6 +292,7 @@ static int xgpio_probe(struct platform_d
 		chip->gpio_width[0] = 32;
 
 	spin_lock_init(&chip->gpio_lock[0]);
+	spin_lock_init(&chip->gpio_lock[1]);
 
 	if (of_property_read_u32(np, "xlnx,is-dual", &is_dual))
 		is_dual = 0;
@@ -313,8 +314,6 @@ static int xgpio_probe(struct platform_d
 		if (of_property_read_u32(np, "xlnx,gpio2-width",
 					 &chip->gpio_width[1]))
 			chip->gpio_width[1] = 32;
-
-		spin_lock_init(&chip->gpio_lock[1]);
 	}
 
 	chip->gc.base = -1;
_
