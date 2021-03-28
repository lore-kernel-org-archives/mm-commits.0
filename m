Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89821C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339AE61951
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC1T6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhC1T5z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C788B601FD;
        Sun, 28 Mar 2021 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616961475;
        bh=g6jDVSYvhLjFLuAJeP9+hKYbG9M6JvNeF+sI64LYC9s=;
        h=Date:From:To:Subject:From;
        b=JcEhlAzpptX+17mIRQ+CrhQN5oruSB8RoYZpZreFonbHhHibUxsQRklOEt6uuXvyL
         6AYh+byBHbFeHc+PvAdthVWH2K98h8L29Ku3/0PB4LpvRlOS3/gxyLBdcMd/tvBvwu
         jXMFIS1BfwUnCRDv+ScKxJR9NMnM1pzoScGhEGVo=
Date:   Sun, 28 Mar 2021 12:57:54 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, hch@lst.de, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        song.bao.hua@hisilicon.com, tglx@linutronix.de,
        tiantao6@hisilicon.com
Subject:  [nacked]
 dma-mapping-make-map_benchmark-compile-into-module.patch removed from -mm
 tree
Message-ID: <20210328195754.8V1m6rWhF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: make map_benchmark compile into module
has been removed from the -mm tree.  Its filename was
     dma-mapping-make-map_benchmark-compile-into-module.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: dma-mapping: make map_benchmark compile into module

Under some scenarios, it is necessary to compile map_benchmark into a
module to test iommu, so this patch changes Kconfig and export_symbol to
implement map_benchmark compiled into module.

On the other hand, map_benchmark is a driver, which is supposed to be able
to run as a module.

Link: https://lkml.kernel.org/r/1616552258-22282-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Acked-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/Kconfig |    2 +-
 kernel/kthread.c   |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/dma/Kconfig~dma-mapping-make-map_benchmark-compile-into-module
+++ a/kernel/dma/Kconfig
@@ -223,7 +223,7 @@ config DMA_API_DEBUG_SG
 	  If unsure, say N.
 
 config DMA_MAP_BENCHMARK
-	bool "Enable benchmarking of streaming DMA mapping"
+	tristate "Enable benchmarking of streaming DMA mapping"
 	depends on DEBUG_FS
 	help
 	  Provides /sys/kernel/debug/dma_map_benchmark that helps with testing
--- a/kernel/kthread.c~dma-mapping-make-map_benchmark-compile-into-module
+++ a/kernel/kthread.c
@@ -455,6 +455,7 @@ void kthread_bind_mask(struct task_struc
 {
 	__kthread_bind_mask(p, mask, TASK_UNINTERRUPTIBLE);
 }
+EXPORT_SYMBOL(kthread_bind_mask);
 
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are


