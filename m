Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8FEC7EE29
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjFJA1e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFJA1e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:27:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D18BF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4097464869
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850B0C433EF;
        Sat, 10 Jun 2023 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356852;
        bh=qF6DE0M4WousFSduitD1Ya2sqg6GL6zcfW2uhybTass=;
        h=Date:To:From:Subject:From;
        b=TO8kUv1sEF6WRZDTn2AM6SAgQJCG+0ns3+LizSHhk6TWcAXF1Ont8yvQASq8rA+/m
         DYNaKBU1T/llt6CQwlWqo3tTYg0LQvrFpg0qbUZZZnamrtP/Yjz2vuX1gxsNj0LZuB
         GJUPGbLc+01kapy0WX8NZ2KNixailfuNOSXx3JYg=
Date:   Fri, 09 Jun 2023 17:27:31 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        haifeng.xu@shopee.com, bristot@kernel.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch removed from -mm tree
Message-Id: <20230610002732.850B0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fork-optimize-memcg_charge_kernel_stack-a-bit-fix
has been removed from the -mm tree.  Its filename was
     fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

This patch was dropped because it was folded into fork-optimize-memcg_charge_kernel_stack-a-bit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fork-optimize-memcg_charge_kernel_stack-a-bit-fix
Date: Fri May 12 05:26:41 PM PDT 2023

remove assertion that PAGE_SIZE is a multiple of 1k

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/fork.c~fork-optimize-memcg_charge_kernel_stack-a-bit-fix
+++ a/kernel/fork.c
@@ -254,7 +254,6 @@ static int memcg_charge_kernel_stack(str
 	int ret;
 	int nr_charged = 0;
 
-	BUILD_BUG_ON(PAGE_SIZE % 1024 != 0);
 	BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
 	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

