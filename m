Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26033C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 19:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjAPTA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 14:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjAPTA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 14:00:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BF0234D5
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 11:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5557661118
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 19:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22DCC433F0;
        Mon, 16 Jan 2023 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673895623;
        bh=iUOFAZ6DM+uEb/mkZkpZjcLvVkrsFaQ3iMaHoET7nwQ=;
        h=Date:To:From:Subject:From;
        b=OjX7XMbE7dHFRYIZS5w5KVQfaEt9uKZWZF57/hvMpW4snj1D2F6n4ulLgjkwYT/y6
         zJCNBORW2lpYyhRBU1rG1GrVIfnBbstUwb/EZV+f6OuI0yliGWEhYZ5vzmYyRg8eL+
         GnnJb9mmVBZFUolJWNFUt3DsMrNfukb41suEnYsM=
Date:   Mon, 16 Jan 2023 11:00:22 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, jiebin.sun@intel.com,
        hpa@zytor.com, alexander.sverdlin@siemens.com, 1vier1@web.de,
        manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-irq-managec-disable_irq-might-sleep.patch removed from -mm tree
Message-Id: <20230116190023.A22DCC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/irq/manage.c: disable_irq() might sleep.
has been removed from the -mm tree.  Its filename was
     kernel-irq-managec-disable_irq-might-sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: kernel/irq/manage.c: disable_irq() might sleep.
Date: Fri, 16 Dec 2022 16:04:41 +0100

With the introduction of threaded interrupt handlers, it is virtually
never safe to call disable_irq() from non-premptible context.

Thus: Update the documentation, add a might_sleep() to catch any
offenders.

Link: https://lkml.kernel.org/r/20221216150441.200533-3-manfred@colorfullife.com
Fixes: 3aa551c9b4c4 ("genirq: add threaded interrupt handler support")
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
Cc: <1vier1@web.de>
Cc: "Sun, Jiebin" <jiebin.sun@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/irq/manage.c~kernel-irq-managec-disable_irq-might-sleep
+++ a/kernel/irq/manage.c
@@ -723,10 +723,13 @@ EXPORT_SYMBOL(disable_irq_nosync);
  *	to complete before returning. If you use this function while
  *	holding a resource the IRQ handler may need you will deadlock.
  *
- *	This function may be called - with care - from IRQ context.
+ *	Can only be called from preemptible code as it might sleep when
+ *	an interrupt thread is associated to @irq.
+ *
  */
 void disable_irq(unsigned int irq)
 {
+	might_sleep();
 	if (!__disable_irq_nosync(irq))
 		synchronize_irq(irq);
 }
_

Patches currently in -mm which might be from manfred@colorfullife.com are

lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch
include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch

