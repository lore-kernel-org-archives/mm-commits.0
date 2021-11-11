Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D828C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1548861361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhKKC4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234631AbhKKC4y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862AC61108;
        Thu, 11 Nov 2021 02:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599245;
        bh=P+oo8waQbh1y5vN87UP4yK7gJt4pSwjySqPu1cK4NF8=;
        h=Date:From:To:Subject:From;
        b=RX01G0OjuONWDpbmLkvK1IEcX64Bwb839ETC6wPiKqKLyCRDn+iWoBsPSIMEvMSVP
         dg7rS7xqWwT+ilW/ZuWrdZzZJJ2nrAeooAKOLEqiYxLrIfys+gpkRVOCDGfNX+gL67
         SKH8QjnnPRA5jgLjjqsLQGwaru7uPU7vGYzDYjqI=
Date:   Wed, 10 Nov 2021 18:54:05 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  [merged]
 kcov-allocate-per-cpu-memory-on-the-relevant-node.patch removed from -mm
 tree
Message-ID: <20211111025405.t1ZSvsCtM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: allocate per-CPU memory on the relevant node
has been removed from the -mm tree.  Its filename was
     kcov-allocate-per-cpu-memory-on-the-relevant-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: kcov: allocate per-CPU memory on the relevant node

During boot kcov allocates per-CPU memory which is used later if remote/
softirq processing is enabled.

Allocate the per-CPU memory on the CPU local node to avoid cross node
memory access.

Link: https://lkml.kernel.org/r/20210923164741.1859522-4-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-4-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kcov-allocate-per-cpu-memory-on-the-relevant-node
+++ a/kernel/kcov.c
@@ -1034,8 +1034,8 @@ static int __init kcov_init(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		void *area = vmalloc(CONFIG_KCOV_IRQ_AREA_SIZE *
-				sizeof(unsigned long));
+		void *area = vmalloc_node(CONFIG_KCOV_IRQ_AREA_SIZE *
+				sizeof(unsigned long), cpu_to_node(cpu));
 		if (!area)
 			return -ENOMEM;
 		per_cpu_ptr(&kcov_percpu_data, cpu)->irq_area = area;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


