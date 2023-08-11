Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C130EB64DD
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 16:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbjHKQob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 12:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjHKQo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 12:44:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0C830D0;
        Fri, 11 Aug 2023 09:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E80D676DE;
        Fri, 11 Aug 2023 16:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A503AC433C7;
        Fri, 11 Aug 2023 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691772264;
        bh=cNImMeihwyG6XN4zpOCUhrGAk9stXWPIHNBzFJ9hTfU=;
        h=Date:To:From:Subject:From;
        b=TrbtakyZlHyx0Lv+lYeDFXL3NYA4W2jZxrW4GmM9x6OJDMgsx3pDP07pM2hjJNaMo
         eoXu4C/6YPHP1lfVWJZXZngnPHsQcJPz4ZQmKm39cS+DeFzqMXU5tmJT23mPPj0F34
         hug9FlPH279bwCveZjrOoq+1WFoTy9QRnFMtIblE=
Date:   Fri, 11 Aug 2023 09:44:24 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-add-lockdep-annotation-to-kthreadd_done-completer.patch added to mm-hotfixes-unstable branch
Message-Id: <20230811164424.A503AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: add lockdep annotation to kthreadd_done completer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-add-lockdep-annotation-to-kthreadd_done-completer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-add-lockdep-annotation-to-kthreadd_done-completer.patch

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
Subject: init: add lockdep annotation to kthreadd_done completer
Date: Fri, 11 Aug 2023 18:04:22 +0200

Add the missing lockdep annotation to avoid this warning:

 INFO: trying to register non-static key.
 The code is fine but needs lockdep annotation, or maybe
 you didn't initialize this object before use?
 turning off the locking correctness validator.
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.0-rc5+ #681
 Hardware name: 9000/785/C3700
 Backtrace:
  [<000000004030bcd0>] show_stack+0x74/0xb0
  [<0000000041469c7c>] dump_stack_lvl+0x104/0x180
  [<0000000041469d2c>] dump_stack+0x34/0x48
  [<000000004040e5b4>] register_lock_class+0xd24/0xd30
  [<000000004040c21c>] __lock_acquire.isra.0+0xb4/0xac8
  [<000000004040cd60>] lock_acquire+0x130/0x298
  [<000000004146df54>] _raw_spin_lock_irq+0x60/0xb8
  [<0000000041472044>] wait_for_completion+0xa0/0x2d0
  [<000000004146b544>] kernel_init+0x48/0x3a8
  [<0000000040302020>] ret_from_kernel_thread+0x20/0x28

Link: https://lkml.kernel.org/r/ZNZcBkiVkm87+Tvr@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/init/main.c~init-add-lockdep-annotation-to-kthreadd_done-completer
+++ a/init/main.c
@@ -682,6 +682,8 @@ noinline void __ref __noreturn rest_init
 	struct task_struct *tsk;
 	int pid;
 
+	init_completion(&kthreadd_done);
+
 	rcu_scheduler_starting();
 	/*
 	 * We need to spawn init first so that it obtains pid 1, however
_

Patches currently in -mm which might be from deller@gmx.de are

mm-add-lockdep-annotation-to-pgdat_init_all_done_comp-completer.patch
init-add-lockdep-annotation-to-kthreadd_done-completer.patch

