Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96E5C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 18 Jun 2022 00:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiFRAUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383234AbiFRAUS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 20:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130CE5931A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 17:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C1A861E4E
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 00:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA53C3411D;
        Sat, 18 Jun 2022 00:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655511616;
        bh=lz6WmYtLygp7SPCdriohTwzRAEI0Er2PFwaQFacTqfk=;
        h=Date:To:From:Subject:From;
        b=DNjOnC8sAQyPAJi8gR4dF3NJ/0SnjRtiSfHtlhMMk5QhPDrn3jkb+LQJpRqIOMgO9
         i8peFPXYyNS8bpehKOn/E9/pxv+Bgw7oaUS6pv77YF0/U1uOUrJNwTvowa6L8kFaiW
         Bo2WuJNfCYI0C+Po6gsMlZPFjfgSHAjyj2xTCuok=
Date:   Fri, 17 Jun 2022 17:20:15 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        bigeasy@linutronix.de, chenjun102@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch removed from -mm tree
Message-Id: <20220618002015.EAA53C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Chen Jun <chenjun102@huawei.com>
Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
Date: Thu, 16 Jun 2022 02:29:11 +0000

CONFIG_PROVE_RAW_LOCK_NESTING is used to check two things.
1. calling spin_lock in hardirq.
2. raw_spinlock - spinlock nesting.
The error messages like below:
[   13.485711] [ BUG: Invalid wait context ]

However there is no problem on non-PREEMPT_RT kernel. The messages may be
confusing and disturbing.

Therefore, do not check raw_spinlock - spinlock nesting
on non-PREEMPT_RT kernel.

Link: https://lkml.kernel.org/r/20220616022911.35826-1-chenjun102@huawei.com
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt
+++ a/lib/Kconfig.debug
@@ -1262,6 +1262,7 @@ config PROVE_LOCKING
 config PROVE_RAW_LOCK_NESTING
 	bool "Enable raw_spinlock - spinlock nesting checks"
 	depends on PROVE_LOCKING
+	depends on PREEMPT_RT
 	default n
 	help
 	 Enable the raw_spinlock vs. spinlock nesting checks which ensure
_

Patches currently in -mm which might be from chenjun102@huawei.com are


