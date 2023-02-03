Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552DAC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjBCGu4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCGuw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:50:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F2118B04
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6237D61DBB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA972C4339B;
        Fri,  3 Feb 2023 06:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407050;
        bh=onBkx/dYNLdRol8N+GVClCIzfwz1Q5giPZIki+lNjys=;
        h=Date:To:From:Subject:From;
        b=kuwsBpy+B47lSc04Xvyi2sDLLOPyLl8x36rWFEKSAkkQhO++dllHcIsJpsM2k8b6w
         hb5THeKexjTIrdl6NtBPDi6YMiz46FfrTu24kHaWK+1MfBoP0+Nl6eBsqxYj7XXGhM
         wit6qMKgQS0CZteIaRdz0LfZU4pIP5zxEMRkvCrw=
Date:   Thu, 02 Feb 2023 22:50:50 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        jiebin.sun@intel.com, alexander.sverdlin@siemens.com,
        1vier1@web.de, manfred@colorfullife.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch removed from -mm tree
Message-Id: <20230203065050.BA972C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/percpu_counter.h: race in uniprocessor percpu_counter_add()
has been removed from the -mm tree.  Its filename was
     include-linux-percpu_counterh-race-in-uniprocessor-percpu_counter_add.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


