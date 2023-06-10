Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57905C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjFJApr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjFJApi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8DA3AB0
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18861651D1
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68445C433D2;
        Sat, 10 Jun 2023 00:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357933;
        bh=XK9pnEDy68kPsIa+Yx8PPKhMkFFCc/PeNTFk7lV2KQc=;
        h=Date:To:From:Subject:From;
        b=CB2LHY9NHKhFmi4ABaWo8sYYVtONxGXK8h+mNzkHMG+CFYA2pp6GTRnsrbscMVKIN
         elXBwIClMMfLKwipNLyU1eW459+KlwC42mwLYqqDl9HMe44DBGbyJtbpZaYoCXmUCI
         5as26ukQ0Qh1FZ8FDYjAEFrWapkj8i/KJeiQl3Qc=
Date:   Fri, 09 Jun 2023 17:45:32 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, wens@csie.org,
        tzungbi@chromium.org, swboyd@chromium.org, sumit.garg@linaro.org,
        ricardo.neri@intel.com, rdunlap@infradead.org,
        ravi.v.shankar@intel.com, pmladek@suse.com, npiggin@gmail.com,
        msys.mizuma@gmail.com, mpe@ellerman.id.au, mka@chromium.org,
        maz@kernel.org, mark.rutland@arm.com, kernelfans@gmail.com,
        irogers@google.com, groeck@chromium.org, eranian@google.com,
        dianders@chromium.org, davem@davemloft.net,
        daniel.thompson@linaro.org, christophe.leroy@csgroup.eu,
        ccross@android.com, catalin.marinas@arm.com, ak@linux.intel.com,
        lecopzer.chen@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-remove-watchdog_default.patch removed from -mm tree
Message-Id: <20230610004533.68445C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog: remove WATCHDOG_DEFAULT
has been removed from the -mm tree.  Its filename was
     watchdog-remove-watchdog_default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lecopzer Chen <lecopzer.chen@mediatek.com>
Subject: watchdog: remove WATCHDOG_DEFAULT
Date: Fri, 19 May 2023 10:18:27 -0700

No reference to WATCHDOG_DEFAULT, remove it.

Link: https://lkml.kernel.org/r/20230519101840.v5.3.I6a729209a1320e0ad212176e250ff945b8f91b2a@changeid
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Colin Cross <ccross@android.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/watchdog.c~watchdog-remove-watchdog_default
+++ a/kernel/watchdog.c
@@ -30,10 +30,8 @@
 static DEFINE_MUTEX(watchdog_mutex);
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_NMI_WATCHDOG)
-# define WATCHDOG_DEFAULT	(SOFT_WATCHDOG_ENABLED | NMI_WATCHDOG_ENABLED)
 # define NMI_WATCHDOG_DEFAULT	1
 #else
-# define WATCHDOG_DEFAULT	(SOFT_WATCHDOG_ENABLED)
 # define NMI_WATCHDOG_DEFAULT	0
 #endif
 
_

Patches currently in -mm which might be from lecopzer.chen@mediatek.com are

watchdog-hardlockup-change-watchdog_nmi_enable-to-void.patch
watchdog-perf-adapt-the-watchdog_perf-interface-for-async-model.patch
arm64-add-hw_nmi_get_sample_period-for-preparation-of-lockup-detector.patch

