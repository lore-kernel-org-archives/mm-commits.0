Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3BBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 06:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28AD61158
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 06:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345901AbhIHGlL convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 02:41:11 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:56185 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347774AbhIHGlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 02:41:08 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 3259340007;
        Wed,  8 Sep 2021 06:39:55 +0000 (UTC)
Date:   Wed, 8 Sep 2021 08:39:54 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     andriy.shevchenko@linux.intel.com, ceggers@arri.de,
        cw00.choi@samsung.com, daniel.lezcano@linaro.org, jic23@kernel.org,
        Jonathan.Cameron@huawei.com, kyungmin.park@samsung.com,
        lars@metafoo.de, linux-mm@kvack.org, linux@roeck-us.net,
        lukasz.luba@arm.com, mcoquelin.stm32@gmail.com,
        mm-commits@vger.kernel.org, myungjoo.ham@samsung.com,
        pmeerw@pmeerw.net, rafael@kernel.org, rui.zhang@intel.com,
        torvalds@linux-foundation.org
Subject: Re: [patch 092/147] mtd/drivers/nand: use HZ macros
Message-ID: <20210908083954.5cbbe868@xps13>
In-Reply-To: <20210908025811.ftBKOSYuD%akpm@linux-foundation.org>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
        <20210908025811.ftBKOSYuD%akpm@linux-foundation.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

akpm@linux-foundation.org wrote on Tue, 07 Sep 2021 19:58:11 -0700:

> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Subject: mtd/drivers/nand: use HZ macros
> 
> HZ unit conversion macros are available in units.h, use them and remove
> the duplicate definition.
> 
> Link: https://lkml.kernel.org/r/20210816114732.1834145-10-daniel.lezcano@linaro.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Christian Eggers <ceggers@arri.de>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Lukasz Luba <lukasz.luba@arm.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Peter Meerwald <pmeerw@pmeerw.net>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

A better suffix would have been "mtd: rawnand: intel:". Maybe you can
fix it when applying.

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

> ---
> 
>  drivers/mtd/nand/raw/intel-nand-controller.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/mtd/nand/raw/intel-nand-controller.c~mtd-drivers-nand-use-hz-macros
> +++ a/drivers/mtd/nand/raw/intel-nand-controller.c
> @@ -20,6 +20,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
> +#include <linux/units.h>
>  #include <asm/unaligned.h>
>  
>  #define EBU_CLC			0x000
> @@ -102,7 +103,6 @@
>  
>  #define MAX_CS	2
>  
> -#define HZ_PER_MHZ	1000000L
>  #define USEC_PER_SEC	1000000L
>  
>  struct ebu_nand_cs {
> _


Thanks,
Miquèl
