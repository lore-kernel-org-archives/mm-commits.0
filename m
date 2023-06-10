Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C65C7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjFJApN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjFJApI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA54A3A99
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C57C60FDC
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C4C433D2;
        Sat, 10 Jun 2023 00:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357907;
        bh=boEVczF7yKitU0kqi1MKGKiz44lMtbUOLqKlE6WNETQ=;
        h=Date:To:From:Subject:From;
        b=aVt5wFZoGI3LgFVq6ZH6lfLmbMt0EMdQmV/iWCcuXrgX9HzX2k7XJCtJdS+L0rAPz
         YeuqxfGX6bV2380h3L4PdstLZLh4YLf6Pk5ITInDyM7PAmikZwQaS28Hf0pi+TiJDb
         w2d8o/8+b/EFj7PNVBIKO+RrCUCL8YuNz8VSZDS0=
Date:   Fri, 09 Jun 2023 17:45:06 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        bristot@kernel.org, bigeasy@linutronix.de, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-optimize-memcg_charge_kernel_stack-a-bit.patch removed from -mm tree
Message-Id: <20230610004506.E82C4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fork: optimize memcg_charge_kernel_stack() a bit
has been removed from the -mm tree.  Its filename was
     fork-optimize-memcg_charge_kernel_stack-a-bit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove assertion that PAGE_SIZE is a multiple of 1k]
Link: https://lkml.kernel.org/r/20230508064458.32855-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/kernel/fork.c~fork-optimize-memcg_charge_kernel_stack-a-bit
+++ a/kernel/fork.c
@@ -252,23 +252,19 @@ static int memcg_charge_kernel_stack(str
 {
 	int i;
 	int ret;
+	int nr_charged = 0;
 
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
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


