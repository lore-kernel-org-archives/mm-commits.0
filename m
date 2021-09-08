Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4468CC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2433C61152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhIHDAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347450AbhIHDAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D571460E52;
        Wed,  8 Sep 2021 02:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069973;
        bh=dXeTS8e085pXg1q5+Li5PsMMTf7If4iABjUP1UT9Z0k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FsevSG06WeS6QeJ8Q/ZDH3MuVOcrOuEkFFHkSLrIRIKAFfBs6R/l+sLjfv7CLi9wj
         Qx9WMjterUbacAOPsw5sCZtJWrnAWqrG/KmYGoMsaXboorzrKBWR9qKHLgNzSB9W6T
         wfz4RZfbq9r/JNVlDuOJxBeEb1NQ8A/qjWT0zq9s=
Date:   Tue, 07 Sep 2021 19:59:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 118/147] bitops: replace for_each_*_bit_from()
 with for_each_*_bit() where appropriate
Message-ID: <20210908025932.4t3elGTdP%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: bitops: replace for_each_*_bit_from() with for_each_*_bit() where appropriate

A couple of kernel functions call for_each_*_bit_from() with start bit
equal to 0.  Replace them with for_each_*_bit().

No functional changes, but might improve on readability.

Link: https://lkml.kernel.org/r/20210814211713.180533-13-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/vector.c         |    4 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |    4 ++--
 drivers/hwmon/ltc2992.c               |    3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/apic/vector.c~replace-for_each__bit_from-with-for_each__bit-where-appropriate
+++ a/arch/x86/kernel/apic/vector.c
@@ -760,9 +760,9 @@ void __init lapic_update_legacy_vectors(
 
 void __init lapic_assign_system_vectors(void)
 {
-	unsigned int i, vector = 0;
+	unsigned int i, vector;
 
-	for_each_set_bit_from(vector, system_vectors, NR_VECTORS)
+	for_each_set_bit(vector, system_vectors, NR_VECTORS)
 		irq_matrix_assign_system(vector_matrix, vector, false);
 
 	if (nr_legacy_irqs() > 1)
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c~replace-for_each__bit_from-with-for_each__bit-where-appropriate
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1032,7 +1032,7 @@ pm_put:
 
 void etnaviv_gpu_recover_hang(struct etnaviv_gpu *gpu)
 {
-	unsigned int i = 0;
+	unsigned int i;
 
 	dev_err(gpu->dev, "recover hung GPU!\n");
 
@@ -1045,7 +1045,7 @@ void etnaviv_gpu_recover_hang(struct etn
 
 	/* complete all events, the GPU won't do it after the reset */
 	spin_lock(&gpu->event_spinlock);
-	for_each_set_bit_from(i, gpu->event_bitmap, ETNA_NR_EVENTS)
+	for_each_set_bit(i, gpu->event_bitmap, ETNA_NR_EVENTS)
 		complete(&gpu->event_free);
 	bitmap_zero(gpu->event_bitmap, ETNA_NR_EVENTS);
 	spin_unlock(&gpu->event_spinlock);
--- a/drivers/hwmon/ltc2992.c~replace-for_each__bit_from-with-for_each__bit-where-appropriate
+++ a/drivers/hwmon/ltc2992.c
@@ -248,8 +248,7 @@ static int ltc2992_gpio_get_multiple(str
 
 	gpio_status = reg;
 
-	gpio_nr = 0;
-	for_each_set_bit_from(gpio_nr, mask, LTC2992_GPIO_NR) {
+	for_each_set_bit(gpio_nr, mask, LTC2992_GPIO_NR) {
 		if (test_bit(LTC2992_GPIO_BIT(gpio_nr), &gpio_status))
 			set_bit(gpio_nr, bits);
 	}
_
