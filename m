Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EC7C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjFSX2W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjFSX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF73B1BF4
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47D26610A6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2974C433C8;
        Mon, 19 Jun 2023 23:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217175;
        bh=6w8dQT8HtzGvowFUqW+YxRkY6sDK32jQutEJ61cU6Cc=;
        h=Date:To:From:Subject:From;
        b=dzX8VoCLsqFP6hS2Iz0vKzzTl65ok0qBVuK70m4oikP0cC1AYiHeP+hkadT/9Vtsm
         oCMOgtEIzV9G7Vi+F5So9qRZt4toxI2drj4RAw3B5hEfkl1UCDfvx8BTBPi87/P0J+
         ar1Uq4vftWLJHJUUfR3F9fCLzkV2I0rmDwT4YwQE=
Date:   Mon, 19 Jun 2023 16:26:15 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy.patch removed from -mm tree
Message-Id: <20230619232615.A2974C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/buddy: simplify the dependency for HARDLOCKUP_DETECTOR_PREFER_BUDDY
has been removed from the -mm tree.  Its filename was
     watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/buddy: simplify the dependency for HARDLOCKUP_DETECTOR_PREFER_BUDDY
Date: Fri, 26 May 2023 18:41:38 -0700

The dependency for HARDLOCKUP_DETECTOR_PREFER_BUDDY was more complicated
than it needed to be.  If the "perf" detector is available and we have SMP
then we have a choice, so enable the config based on just those two config
items.

Link: https://lkml.kernel.org/r/20230526184139.8.I49d5b483336b65b8acb1e5066548a05260caf809@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~watchdog-buddy-simplify-the-dependency-for-hardlockup_detector_prefer_buddy
+++ a/lib/Kconfig.debug
@@ -1065,7 +1065,7 @@ config HAVE_HARDLOCKUP_DETECTOR_NON_ARCH
 
 config HARDLOCKUP_DETECTOR_PREFER_BUDDY
 	bool "Prefer the buddy CPU hardlockup detector"
-	depends on HAVE_HARDLOCKUP_DETECTOR_NON_ARCH && HAVE_HARDLOCKUP_DETECTOR_PERF && SMP
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF && SMP
 	help
 	  Say Y here to prefer the buddy hardlockup detector over the perf one.
 
_

Patches currently in -mm which might be from dianders@chromium.org are


