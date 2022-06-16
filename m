Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6E8C43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 19:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378172AbiFPTla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378000AbiFPTla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 15:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54A859974
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 12:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8DB61D69
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66B3C34114;
        Thu, 16 Jun 2022 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655408488;
        bh=0F1nrwMB0BiXZxXOsQ+daKraMaxHr4oanzfpAC7MADU=;
        h=Date:To:From:Subject:From;
        b=sZDgbtGDrNqm7R1dKXrIqc7/g4CEreQdXig2GNtrfXdayj6lxcmvG/OCYW3eKN/fk
         j6WfgAyKRI+EfA6He+ClZFAJwnBcYY3tsiLsFLGJXq2ZvE4C1Y8t6nCnkqjXpJvkYg
         gRnH46yRKrDJXudzL7apDee6oNTwqsZLTmyJnZzw=
Date:   Thu, 16 Jun 2022 12:41:27 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        bigeasy@linutronix.de, chenjun102@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch added to mm-nonmm-unstable branch
Message-Id: <20220616194128.A66B3C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch

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
@@ -1270,6 +1270,7 @@ config PROVE_LOCKING
 config PROVE_RAW_LOCK_NESTING
 	bool "Enable raw_spinlock - spinlock nesting checks"
 	depends on PROVE_LOCKING
+	depends on PREEMPT_RT
 	default n
 	help
 	 Enable the raw_spinlock vs. spinlock nesting checks which ensure
_

Patches currently in -mm which might be from chenjun102@huawei.com are

lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch

