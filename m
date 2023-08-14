Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9E1EB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjHNUUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbjHNUUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:20:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCA4BC;
        Mon, 14 Aug 2023 13:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC097626BE;
        Mon, 14 Aug 2023 20:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1C1C433C8;
        Mon, 14 Aug 2023 20:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044436;
        bh=ydUt2A85dQ5YUTDoZJHyjnXlDItxilfPDwcVIwDTsdM=;
        h=Date:To:From:Subject:From;
        b=zQ31gEAJVP2SyQSUACRSb4MyZzALMP971aUcaYUS8uz1qYFnfGNfc5kac6E/ZAf/B
         dO7cqbDj4zu66FRnvKgsXXz+N/dTEK1mxrJPHOBipE50hj8JEvLHEzOXLNTBrEHGge
         uaCBnzIkpq4oETmQCh5U59ddfoNxGlSHWPjMJcN4=
Date:   Mon, 14 Aug 2023 13:20:35 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] init-add-lockdep-annotation-to-kthreadd_done-completer.patch removed from -mm tree
Message-Id: <20230814202036.1B1C1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: add lockdep annotation to kthreadd_done completer
has been removed from the -mm tree.  Its filename was
     init-add-lockdep-annotation-to-kthreadd_done-completer.patch

This patch was dropped because it was withdrawn

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

watchdog-fix-lockdep-warning.patch

