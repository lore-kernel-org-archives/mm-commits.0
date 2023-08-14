Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB47AEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjHNUVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjHNUUt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1EA11D;
        Mon, 14 Aug 2023 13:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 933D361FFE;
        Mon, 14 Aug 2023 20:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3B4C433C7;
        Mon, 14 Aug 2023 20:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044448;
        bh=zOBqUFl76cB5cuhRqFOgOcW2JxtotebwLxUY5NNQ09g=;
        h=Date:To:From:Subject:From;
        b=v23N38KQ15UuHhJZ83iAEUTBdVQVkok/Toma/rSyNE+wpLZJR6buyKRdtGN9T4og1
         PYkGi/cxxSiQYuTg0i1+59j2PiZ/v20eVbCW9OQNISAdd8k+NKFQdIzSrNuDMKy+6h
         sMqGiALw2P9okpC+nqd8TFcDLypiz8O35rgSZ41U=
Date:   Mon, 14 Aug 2023 13:20:47 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] watchdog-fix-lockdep-warning.patch removed from -mm tree
Message-Id: <20230814202047.EA3B4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog: Fix lockdep warning
has been removed from the -mm tree.  Its filename was
     watchdog-fix-lockdep-warning.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: watchdog: Fix lockdep warning
Date: Fri, 11 Aug 2023 19:11:46 +0200

Fully initialize detector_work work struct to avoid this kernel warning
when lockdep is enabled:

 =====================================
 WARNING: bad unlock balance detected!
 6.5.0-rc5+ #687 Not tainted
 -------------------------------------
 swapper/0/1 is trying to release lock (detector_work) at:
 [<000000004037e554>] __flush_work+0x60/0x658
 but there are no more locks to release!

 other info that might help us debug this:
 no locks held by swapper/0/1.

 stack backtrace:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.0-rc5+ #687
 Hardware name: 9000/785/C3700
 Backtrace:
  [<0000000041455d5c>] print_unlock_imbalance_bug.part.0+0x20c/0x230
  [<000000004040d5e8>] lock_release+0x2e8/0x3f8
  [<000000004037e5cc>] __flush_work+0xd8/0x658
  [<000000004037eb7c>] flush_work+0x30/0x60
  [<000000004011f140>] lockup_detector_check+0x54/0x128
  [<0000000040306430>] do_one_initcall+0x9c/0x408
  [<0000000040102d44>] kernel_init_freeable+0x688/0x7f0
  [<000000004146df68>] kernel_init+0x64/0x3a8
  [<0000000040302020>] ret_from_kernel_thread+0x20/0x28

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/watchdog.c~watchdog-fix-lockdep-warning
+++ a/kernel/watchdog.c
@@ -1022,5 +1022,6 @@ void __init lockup_detector_init(void)
 	else
 		allow_lockup_detector_init_retry = true;
 
+	INIT_WORK(&detector_work, lockup_detector_delay_init);
 	lockup_detector_setup();
 }
_

Patches currently in -mm which might be from deller@gmx.de are


