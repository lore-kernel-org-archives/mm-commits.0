Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D658BC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5329224F4
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgLVUnP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgLVUnP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:43:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70CCE22ADC;
        Tue, 22 Dec 2020 20:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608669754;
        bh=vvuzxTGqFanXVloTf73t9bVqgBuJ6Jj3FPI15UUdIbY=;
        h=Date:From:To:Subject:From;
        b=EnKu9U6wYvxNyNjp282rTRIZFlP0qvvfkC8+c0HldOLbAhahH2iVvo3h42zxKgHKj
         jiS+69O/oip9YdLBaE584RTpde5lDLTnOBWwFl8ukVb4LzJhBxw8B1Z1JJ105rLyWh
         f3sEy8oINlC6+LMHXdH3jIphplHVJSBlyTAqqfOs=
Date:   Tue, 22 Dec 2020 12:42:34 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vilhelm.gray@gmail.com,
        rrichter@marvell.com, bgolaszewski@baylibre.com,
        syednwaris@gmail.com
Subject:  [to-be-updated]
 gpio-thunderx-utilize-for_each_set_clump-macro.patch removed from -mm tree
Message-ID: <20201222204234.v9eJb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gpio: thunderx: utilize for_each_set_clump macro
has been removed from the -mm tree.  Its filename was
     gpio-thunderx-utilize-for_each_set_clump-macro.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Syed Nayyar Waris <syednwaris@gmail.com>
Subject: gpio: thunderx: utilize for_each_set_clump macro

Reimplement the thunderx_gpio_set_multiple function in
drivers/gpio/gpio-thunderx.c to use the new for_each_set_clump macro. 
Instead of looping for each bank in thunderx_gpio_set_multiple function,
now we can skip bank which is not set and save cycles.

Link: https://lkml.kernel.org/r/5e94ad3c156b98d2ed28617b2ca25bacadc189d5.1603055402.git.syednwaris@gmail.com
Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpio-thunderx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-thunderx.c~gpio-thunderx-utilize-for_each_set_clump-macro
+++ a/drivers/gpio/gpio-thunderx.c
@@ -275,12 +275,15 @@ static void thunderx_gpio_set_multiple(s
 				       unsigned long *bits)
 {
 	int bank;
-	u64 set_bits, clear_bits;
+	unsigned long set_bits, clear_bits, gpio_mask;
+	unsigned long offset;
+
 	struct thunderx_gpio *txgpio = gpiochip_get_data(chip);
 
-	for (bank = 0; bank <= chip->ngpio / 64; bank++) {
-		set_bits = bits[bank] & mask[bank];
-		clear_bits = ~bits[bank] & mask[bank];
+	for_each_set_clump(offset, gpio_mask, mask, chip->ngpio, 64) {
+		bank = offset / 64;
+		set_bits = bits[bank] & gpio_mask;
+		clear_bits = ~bits[bank] & gpio_mask;
 		writeq(set_bits, txgpio->register_base + (bank * GPIO_2ND_BANK) + GPIO_TX_SET);
 		writeq(clear_bits, txgpio->register_base + (bank * GPIO_2ND_BANK) + GPIO_TX_CLR);
 	}
_

Patches currently in -mm which might be from syednwaris@gmail.com are

gpio-xilinx-utilize-generic-bitmap_get_value-and-_set_value.patch

