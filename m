Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B29EEC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 992C860F48
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhHNWSP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233452AbhHNWSK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D14560F4B;
        Sat, 14 Aug 2021 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979461;
        bh=3dR2uzpeFGPV/yPV2ccuVoUTXsPvPf3vtr4WDig7ZLw=;
        h=Date:From:To:Subject:From;
        b=EdzWgIsVxI5e1ht0sBHWhZlblp2sFIwOQEhdCXNl81ZcCjAD/OONR2kz3JMHqvIL2
         hzlArXHPgzEM+SGZxW8ZJHgeEySq6/9Vtet9fBYPVfEG3TMmqiecUA0c+hbm5sPRv5
         vkamRpmxGecArcQwgsKEI73TZkt0w9QCaTPVp1yo=
Date:   Sat, 14 Aug 2021 15:17:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  +
 replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch added
 to -mm tree
Message-ID: <20210814221741.PEyII%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: replace for_each_*_bit_from() with for_each_*_bit() where appropriate
has been added to the -mm tree.  Its filename is
     replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: kernel test robot <lkp@intel.com>
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

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

