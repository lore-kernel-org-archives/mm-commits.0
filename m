Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B5EC001B2
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 18:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiLPSEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 13:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPSEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 13:04:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B9269A8F
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 10:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBDBC621B8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 18:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50226C433EF;
        Fri, 16 Dec 2022 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671213887;
        bh=gywVDfxABaSF9vyC9jOjawJDxOpBD11DNy8jmeUF0nc=;
        h=Date:To:From:Subject:From;
        b=yf+5h7F1CuB1lc1b6BJBY1A/sjIeEGKr1eZfS4jma8cLe1otZRl0bgQHHEjSHjWXM
         Ye9vPEgrzUBhSllRAx5/nsixHgZAVXEM34hVDz5zWVmksdwh7wjnq/fecCxwCvEVJ8
         10hNv99JnVUEWZcIYRUrCatwPc+JSA9WXzYDWHKw=
Date:   Fri, 16 Dec 2022 10:04:46 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        jiebin.sun@intel.com, alexander.sverdlin@siemens.com,
        1vier1@web.de, manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch added to mm-nonmm-unstable branch
Message-Id: <20221216180447.50226C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/percpu_counter.h: race in uniprocessor percpu_counter_add()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch

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
Subject: include/linux/percpu_counter.h: race in uniprocessor percpu_counter_add()
Date: Fri, 16 Dec 2022 16:04:40 +0100

The percpu interface is supposed to be preempt and irq safe.

But:
The uniprocessor implementation of percpu_counter_add() is not irq safe:
if an interrupt happens during the +=, then the result is undefined.

Therefore: switch from preempt_disable() to local_irq_save().
This prevents interrupts from interrupting the +=, and as a side effect
prevents preemption.

Link: https://lkml.kernel.org/r/20221216150441.200533-2-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: "Sun, Jiebin" <jiebin.sun@intel.com>
Cc: <1vier1@web.de>
Cc: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/percpu_counter.h~include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add
+++ a/include/linux/percpu_counter.h
@@ -152,9 +152,11 @@ __percpu_counter_compare(struct percpu_c
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	fbc->count += amount;
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /* non-SMP percpu_counter_add_local is the same with percpu_counter_add */
_

Patches currently in -mm which might be from manfred@colorfullife.com are

lib-percpu_counter-percpu_counter_add_batch-overflow-underflow.patch
include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch
kernel-irq-managec-disable_irq-might-sleep.patch

