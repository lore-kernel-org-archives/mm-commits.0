Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94158C04E69
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 20:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjHNUUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjHNUU1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 16:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22BABC;
        Mon, 14 Aug 2023 13:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6540562C5F;
        Mon, 14 Aug 2023 20:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3EC433C8;
        Mon, 14 Aug 2023 20:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692044425;
        bh=vszKKPprIZGDXSUjiDkEGbEtke5awBMR7YZo5TvVaQM=;
        h=Date:To:From:Subject:From;
        b=aK6YOmfHzIkR6292iMJkZLpeDFID6yC+y8Vohju5vZ7L0E4qhu1yVuH7cCHFTHm/0
         ffYaVM1KcaN4E8h/4ljwg7p6sq02GW3fNQaSSqpn7tbfYC8BuSTAinwtbG18I/mmTn
         4QSpDBu8UqawTmI7PgjnBfiw7OyIcskaUIOfYhfs=
Date:   Mon, 14 Aug 2023 13:20:25 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-add-lockdep-annotation-to-pgdat_init_all_done_comp-completer.patch removed from -mm tree
Message-Id: <20230814202025.AFB3EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add lockdep annotation to pgdat_init_all_done_comp completer
has been removed from the -mm tree.  Its filename was
     mm-add-lockdep-annotation-to-pgdat_init_all_done_comp-completer.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: mm: add lockdep annotation to pgdat_init_all_done_comp completer
Date: Fri, 11 Aug 2023 18:06:19 +0200

Add the missing lockdep annotation to avoid this kernel warning:

 smp: Brought up 1 node, 1 CPU
 INFO: trying to register non-static key.
 The code is fine but needs lockdep annotation, or maybe
 you didn't initialize this object before use?'
 turning off the locking correctness validator.
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.0-rc5+ #683
 Hardware name: 9000/785/C3700
 Backtrace:
  [<000000004030bcd0>] show_stack+0x74/0xb0
  [<000000004146c63c>] dump_stack_lvl+0x104/0x180
  [<000000004146c6ec>] dump_stack+0x34/0x48
  [<000000004040e5b4>] register_lock_class+0xd24/0xd30
  [<000000004040c21c>] __lock_acquire.isra.0+0xb4/0xac8
  [<000000004040cd60>] lock_acquire+0x130/0x298
  [<000000004147095c>] _raw_spin_lock_irq+0x60/0xb8
  [<0000000041474a4c>] wait_for_completion+0xa0/0x2d0
  [<000000004012bf04>] page_alloc_init_late+0xf8/0x2b0
  [<0000000040102b20>] kernel_init_freeable+0x464/0x7f0
  [<000000004146df68>] kernel_init+0x64/0x3a8
  [<0000000040302020>] ret_from_kernel_thread+0x20/0x28

Link: https://lkml.kernel.org/r/ZNZce1KGxP1dxpTN@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mm_init.c~mm-add-lockdep-annotation-to-pgdat_init_all_done_comp-completer
+++ a/mm/mm_init.c
@@ -2377,6 +2377,7 @@ void __init page_alloc_init_late(void)
 	int nid;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+	init_completion(&pgdat_init_all_done_comp);
 
 	/* There will be num_node_state(N_MEMORY) threads */
 	atomic_set(&pgdat_init_n_undone, num_node_state(N_MEMORY));
_

Patches currently in -mm which might be from deller@gmx.de are

init-add-lockdep-annotation-to-kthreadd_done-completer.patch
watchdog-fix-lockdep-warning.patch

