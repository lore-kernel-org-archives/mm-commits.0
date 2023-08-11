Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68962C0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 18:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjHKSAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbjHKSAF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 14:00:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F07D30F2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 10:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E6E6784A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 17:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D693C433C7;
        Fri, 11 Aug 2023 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691776789;
        bh=hTgFTvUZLccV2qPqmgHMjAUAavDlOgtL7DUiUDOf5b4=;
        h=Date:To:From:Subject:From;
        b=fcUkEh2DIyca6Nq4NcKkgsVPCRfJX/VVDs4RKAXTR0/VIq+OmCRgl6dIHrwK1Vcch
         9nVqiC8xvmFfF9asSWV3Jf9ZBmQaHWDBDpULZ/ECP7NCPa8Ks0hCqDal8F8IvjTZFR
         D6DdjBc1k8NuPnhRixvO1c9QWaY/93q2zXARPAzo=
Date:   Fri, 11 Aug 2023 10:59:48 -0700
To:     mm-commits@vger.kernel.org, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-fix-lockdep-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20230811175949.2D693C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: Fix lockdep warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     watchdog-fix-lockdep-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-fix-lockdep-warning.patch

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

mm-add-lockdep-annotation-to-pgdat_init_all_done_comp-completer.patch
init-add-lockdep-annotation-to-kthreadd_done-completer.patch
watchdog-fix-lockdep-warning.patch

