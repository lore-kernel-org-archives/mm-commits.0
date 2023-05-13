Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667D4C77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbjEMA1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240883AbjEMA1Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0012686
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0E3465320
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F394EC433EF;
        Sat, 13 May 2023 00:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683937641;
        bh=69BpZ7pstEnxVVGkAfYQBz1e1pb1um8KIPZlcAA/PtY=;
        h=Date:To:From:Subject:From;
        b=ZaRyue0sHRbtwAGSsNzXLAJVAVxVj4QGZrrfiRJmMaPftjAH8jv8mPmW+LWiIA8fC
         6v67DY9bi9H8SfJXm0upYokmUdPFASCw23rZom9+CQdlG3bc316wFDm2AnvJ6H7KpK
         Fiz+Gye3Nffqjd3vueDwT/K1PfYODTQDPsd7MlZ0=
Date:   Fri, 12 May 2023 17:27:20 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        bristot@kernel.org, bigeasy@linutronix.de, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-optimize-memcg_charge_kernel_stack-a-bit.patch added to mm-nonmm-unstable branch
Message-Id: <20230513002720.F394EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: optimize memcg_charge_kernel_stack() a bit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-optimize-memcg_charge_kernel_stack-a-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-optimize-memcg_charge_kernel_stack-a-bit.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: fork: optimize memcg_charge_kernel_stack() a bit
Date: Mon, 8 May 2023 06:44:58 +0000

Since commit f1c1a9ee00e4 ("fork: Move memcg_charge_kernel_stack()
into CONFIG_VMAP_STACK"), memcg_charge_kernel_stack() has been moved
into CONFIG_VMAP_STACK block, so the CONFIG_VMAP_STACK check can be
removed.

Furthermore, memcg_charge_kernel_stack() is only invoked by
alloc_thread_stack_node() instead of dup_task_struct(). If
memcg_kmem_charge_page() fails, the uncharge process is handled in
memcg_charge_kernel_stack() itself instead of free_thread_stack(),
so remove the incorrect comments.

If memcg_charge_kernel_stack() fails to charge pages used by kernel
stack, only charged pages need to be uncharged. It's unnecessary to
uncharge those pages which memory cgroup pointer is NULL.

Link: https://lkml.kernel.org/r/20230508064458.32855-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/fork.c~fork-optimize-memcg_charge_kernel_stack-a-bit
+++ a/kernel/fork.c
@@ -252,23 +252,20 @@ static int memcg_charge_kernel_stack(str
 {
 	int i;
 	int ret;
+	int nr_charged = 0;
 
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
+	BUILD_BUG_ON(PAGE_SIZE % 1024 != 0);
 	BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
 	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 		ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL, 0);
 		if (ret)
 			goto err;
+		nr_charged++;
 	}
 	return 0;
 err:
-	/*
-	 * If memcg_kmem_charge_page() fails, page's memory cgroup pointer is
-	 * NULL, and memcg_kmem_uncharge_page() in free_thread_stack() will
-	 * ignore this page.
-	 */
-	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+	for (i = 0; i < nr_charged; i++)
 		memcg_kmem_uncharge_page(vm->pages[i], 0);
 	return ret;
 }
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

