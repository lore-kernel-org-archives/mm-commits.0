Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1EAC4741F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8BA822202
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604706700;
	bh=JMkCLspYTQVs5M67NZBJWaK1kM+Bc2R5mB0m53RBprk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=shX7bBiz7euhI67AlroO50VqokP03ahJ2GcF+a4S8MyN6fAGnq1evYHhpb5/1V8Tl
	 Nx741o27krNJtwEDdtFJ6RYZPCAGthpTF8mzMhIRJ3G9g8Ou1NMdy5QmKuTI41JCNf
	 Swl+HlRL2vDs/VTj2JtQNSTbptCTjIl/jQrbCgiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgKFXvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgKFXv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 18:51:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99922071A;
        Fri,  6 Nov 2020 23:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604706687;
        bh=JMkCLspYTQVs5M67NZBJWaK1kM+Bc2R5mB0m53RBprk=;
        h=Date:From:To:Subject:From;
        b=ylIOz3e95ZIza0d2ipQaISHV+8le2JG7TjTz8fklHlRDAqAyoQpWqA9o+0avbJw3+
         jRr6k89BNvm8jS1FqcCU72zuWJuZdj/KkZnNfjQKDOzx1Vw+RndRdZEAHuupxn8ODf
         14zC8Lf0+MyFtpcqYWdZT5by3QKbSZ/u/xgZOml4=
Date:   Fri, 06 Nov 2020 15:51:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pmladek@suse.com, santosh@fossix.org,
        tglx@linutronix.de
Subject:  +
 kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch added to
 -mm tree
Message-ID: <20201106235126.aAvdXISKX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: fix watchdog_allowed_mask not used warning
has been added to the -mm tree.  Its filename is
     kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Sivaraj <santosh@fossix.org>
Subject: kernel/watchdog: fix watchdog_allowed_mask not used warning

Define watchdog_allowed_mask only when SOFTLOCKUP_DETECTOR is enabled.

Link: https://lkml.kernel.org/r/20201106015025.1281561-1-santosh@fossix.org
Fixes: 7feeb9cd4f5b ("watchdog/sysctl: Clean up sysctl variable name space")
Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c~kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning
+++ a/kernel/watchdog.c
@@ -44,8 +44,6 @@ int __read_mostly soft_watchdog_user_ena
 int __read_mostly watchdog_thresh = 10;
 static int __read_mostly nmi_watchdog_available;
 
-static struct cpumask watchdog_allowed_mask __read_mostly;
-
 struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
 
@@ -162,6 +160,8 @@ static void lockup_detector_update_enabl
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 #endif
 
+static struct cpumask watchdog_allowed_mask __read_mostly;
+
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
 			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
_

Patches currently in -mm which might be from santosh@fossix.org are

kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch

