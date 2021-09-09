Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48464C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D1A6103D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345073AbhIIU6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhIIU6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B12761026;
        Thu,  9 Sep 2021 20:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221044;
        bh=FS25rS99ViFoKJp9SQhomSw48UnMu1ucwMkccF3wbnE=;
        h=Date:From:To:Subject:From;
        b=jHeVbRa1f+tA5e7uSlGnnN2vWgs5w7v3Vr/jGHrmLihMOlMJqfwlc/fhkLj61gilA
         MQ/DSd1tC1JYoSRYPbqpRAx2Z+bgq73czeLmOE+UrnjduMQo+OpCFWXwQ1JQHkDR6o
         4d/+xPJ9pzG4QxQL75AgK+5epofx+uLtxXD+hskI=
Date:   Thu, 09 Sep 2021 13:57:24 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [to-be-updated]
 replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
 removed from -mm tree
Message-ID: <20210909205724.M6u42nSpS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: replace for_each_*_bit_from() with for_each_*_bit() where appropriate
has been removed from the -mm tree.  Its filename was
     replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

Patches currently in -mm which might be from yury.norov@gmail.com are

mm-percpu-micro-optimize-pcpu_is_populated.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

