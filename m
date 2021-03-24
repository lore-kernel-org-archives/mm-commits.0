Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061E5C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF82661A1E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhCXWLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238744AbhCXWK4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B3361A18;
        Wed, 24 Mar 2021 22:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616623855;
        bh=IHFqDLKTs3TvO4omVGltcp6FVPhApS77hHkSWc/Rw80=;
        h=Date:From:To:Subject:From;
        b=1/gAHtpo/GAaLWLvUBK6vJ9eJts0dt6YPMRpd29V64gtXLoYoXCvDjUfweQ5MEZD9
         Nqb5Y3NS0EzjLTX0bNXZSmeSH40KjYMqZ7flVuMVZTOodrjXTmg1mQofhOt/FOWjlo
         sPUNijbKVs0L5KsEnoqMQ1PpALNNiPXJxUsCjMRM=
Date:   Wed, 24 Mar 2021 15:10:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        song.bao.hua@hisilicon.com, rostedt@goodmis.org,
        peterz@infradead.org, paulmck@kernel.org, m.szyprowski@samsung.com,
        hch@lst.de, ast@kernel.org, tiantao6@hisilicon.com
Subject:  + dma-mapping-make-map_benchmark-compile-into-module.patch
 added to -mm tree
Message-ID: <20210324221053.2wANM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: make map_benchmark compile into module
has been added to the -mm tree.  Its filename is
     dma-mapping-make-map_benchmark-compile-into-module.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-make-map_benchmark-compile-into-module.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-make-map_benchmark-compile-into-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-mapping-make-map_benchmark-compile-into-module.patch

