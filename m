Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE14C35273
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82A82333F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLPEoa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgLPEoa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:30 -0500
Date:   Tue, 15 Dec 2020 20:44:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093855;
        bh=03XT0vjJeFUar5ErfJbHa+1zfPUTS+fTCEl3NHhXjXg=;
        h=From:To:Subject:In-Reply-To:From;
        b=agwRxC5AEAm29+1HN4gcRlPEbYxtTQZB+xALVnMEPeXrz1YcgVauTIG9v+YfX1Lap
         jsWPGDFsVOK+XbmeA2fCVzRoyWpdpezQ49jQa4srVL5ccuG9CDNj3FBt9px57CqnMw
         8b7zQbxsL7phjgBYKAwza1WnmlQRPc8mMHgM/Vcg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rrichter@marvell.com, syednwaris@gmail.com,
        torvalds@linux-foundation.org, vilhelm.gray@gmail.com
Subject:  [patch 35/95] gpio: thunderx: utilize for_each_set_clump
 macro
Message-ID: <20201216044414.-fLj5Q97z%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
