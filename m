Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25930C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 18:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLPSEx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 13:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiLPSEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 13:04:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFEB69A91
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 10:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF04BB81DD8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 18:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CAEC433EF;
        Fri, 16 Dec 2022 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671213889;
        bh=QMjlrzGzsAS9cb/7GG3hflcrszgK9Zl8I1FXZtPnMrM=;
        h=Date:To:From:Subject:From;
        b=pyQOlO6XiL67zn+Xita+eU810BIoePQOipYE8xQHz7eCyKZhiaOJWBS8e/uV3wYeL
         CSzl6TGn9Pqoc1d/S0vaOsgua6u0tI0FXSG24/DkEfIFaT+EmHQsPT9SzZAWrYinaJ
         OSLZMkcft/QPRA+i9AAQ2dWRZTDiPgp1IVX6cMUc=
Date:   Fri, 16 Dec 2022 10:04:48 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        jiebin.sun@intel.com, alexander.sverdlin@siemens.com,
        1vier1@web.de, manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-irq-managec-disable_irq-might-sleep.patch added to mm-nonmm-unstable branch
Message-Id: <20221216180449.61CAEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/manage.c: disable_irq() might sleep.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-irq-managec-disable_irq-might-sleep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-irq-managec-disable_irq-might-sleep.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
kernel-irq-managec-disable_irq-might-sleep.patch

