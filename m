Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD20BC001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjGXQ4i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjGXQ4h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:56:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B905D10F8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E86E61263
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A2EC433CA;
        Mon, 24 Jul 2023 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690217777;
        bh=e5gGCrfO2Rsc281jgQ/Npf5LGo3uyQ86+Idxbm1BfaA=;
        h=Date:To:From:Subject:From;
        b=WI2iXbvUWAxG5K0BYiPdPlvN1N2aqhD4abLK9jYsDfOHXQoA70HcCtEtusb0rHIu6
         LPGc/cH4R0bH2Wygmqw2MJdFoeoFkc9GpzMDSIrTyX6uDByJ7XjSb8bVyWbCHfvXAe
         +Y26fSmcGGUus+q2W0ula43u6FDxmKXFdAaN4upI=
Date:   Mon, 24 Jul 2023 09:56:17 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, rdunlap@infradead.org,
        luca.ceresoli@bootlin.com, jszhang@kernel.org, irogers@google.com,
        guoren@kernel.org, didi.debian@cknow.org, conor@kernel.org,
        colin.i.king@gmail.com, dfustini@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-remove-thead-as-a-typo.patch added to mm-hotfixes-unstable branch
Message-Id: <20230724165617.98A2EC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: remove 'thead' as a typo
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-spellingtxt-remove-thead-as-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-remove-thead-as-a-typo.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Drew Fustini <dfustini@baylibre.com>
Subject: scripts/spelling.txt: remove 'thead' as a typo
Date: Sat, 22 Jul 2023 18:03:30 -0700

T-Head is a vendor of processor core IP, and they have recently introduced
the RISC-V TH1520 SoC.  Remove 'thead' as a typo of 'thread' to avoid
checkpatch incorrectly warning that 'thead' is typo in patches that add
support for T-Head designs in the kernel.

Link: https://lkml.kernel.org/r/20230723010329.674186-1-dfustini@baylibre.com
Link: https://www.t-head.cn/
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Acked-by: Guo Ren <guoren@kernel.org>
Cc: Conor Dooley <conor@kernel.org>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com> # versaclock5
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-remove-thead-as-a-typo
+++ a/scripts/spelling.txt
@@ -1541,7 +1541,6 @@ temeprature||temperature
 temorary||temporary
 temproarily||temporarily
 temperture||temperature
-thead||thread
 theads||threads
 therfore||therefore
 thier||their
_

Patches currently in -mm which might be from dfustini@baylibre.com are

scripts-spellingtxt-remove-thead-as-a-typo.patch

