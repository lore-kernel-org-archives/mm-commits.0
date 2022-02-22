Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0A4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiBVCsp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:48:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiBVCso (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EAC25C6B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 205D6B81754
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AFCC340E9;
        Tue, 22 Feb 2022 02:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645498097;
        bh=g7kD7Wpzg/E4SsKJOurIYfx/nEvP+lm5gN1lW1D9HU4=;
        h=Date:To:From:Subject:From;
        b=vpAgCQQTL1y0yJzN/QtPT+b2zGDWD8S7gMcducGZRsfWLD3ouKWVG2S8Si/wld5SZ
         t3+dMeX7+kKmTVoiLloUWnGQWmSv/501VnTBA3VJkpwKhh84wrFb2pirL4meUQGfhj
         4Xw6cDQNFqPb3jWdYL2JuXH6n8gJXpPZzU0FJJAE=
Date:   Mon, 21 Feb 2022 18:48:17 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, tangmeng@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-remove-unnecessary-config_kasan-option.patch added to -mm tree
Message-Id: <20220222024817.A3AFCC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: remove unnecessary CONFIG_KASAN option
has been added to the -mm tree.  Its filename is
     mm-kasan-remove-unnecessary-config_kasan-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-remove-unnecessary-config_kasan-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-remove-unnecessary-config_kasan-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: tangmeng <tangmeng@uniontech.com>
Subject: mm/kasan: remove unnecessary CONFIG_KASAN option

In mm/Makefile has:
obj-$(CONFIG_KASAN)     += kasan/

So that we don't need 'obj-$(CONFIG_KASAN) :=' in mm/kasan/Makefile,
delete it from mm/kasan/Makefile.

Link: https://lkml.kernel.org/r/20220221065421.20689-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/Makefile~mm-kasan-remove-unnecessary-config_kasan-option
+++ a/mm/kasan/Makefile
@@ -35,7 +35,7 @@ CFLAGS_shadow.o := $(CC_FLAGS_KASAN_RUNT
 CFLAGS_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 
-obj-$(CONFIG_KASAN) := common.o report.o
+obj-y := common.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += init.o generic.o report_generic.o shadow.o quarantine.o
 obj-$(CONFIG_KASAN_HW_TAGS) += hw_tags.o report_hw_tags.o tags.o report_tags.o
 obj-$(CONFIG_KASAN_SW_TAGS) += init.o report_sw_tags.o shadow.o sw_tags.o tags.o report_tags.o
_

Patches currently in -mm which might be from tangmeng@uniontech.com are

mm-kasan-remove-unnecessary-config_kasan-option.patch
mm-kfence-remove-unnecessary-config_kfence-option.patch

