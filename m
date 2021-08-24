Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8769C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE2861368
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhHXU7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Aug 2021 16:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhHXU7t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 24 Aug 2021 16:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBBA66113B;
        Tue, 24 Aug 2021 20:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629838744;
        bh=9Sqk1qe/cs1jkkpZos448s33aoDSccOtKlDmrxhdb9Q=;
        h=Date:From:To:Subject:From;
        b=WvIuxMyNaWTjTHelZksP1e8XE3V6Wlvgaa19lcBsMNjX2alUYZMoHAZskYOFlYiMF
         gBMCEQUjqogeuFjE2A/ymXodY1RKjMMWSt4FKHpAQAw8Fh38w9j5urYMuPoBTVn6eD
         WOBmKnz8L2o3d5ALC19QABV8BqAx/yW8hDBoFaEY=
Date:   Tue, 24 Aug 2021 13:59:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangqing@vivo.com, tj@kernel.org,
        santosh@fossix.org, pmladek@suse.com, davem@davemloft.net,
        kernelfans@gmail.com
Subject:  +
 kernel-watchdog-change-prototype-of-watchdog_nmi_enable.patch added to -mm
 tree
Message-ID: <20210824205902.BbOOf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: change prototype of watchdog_nmi_enable()
has been added to the -mm tree.  Its filename is
     kernel-watchdog-change-prototype-of-watchdog_nmi_enable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-change-prototype-of-watchdog_nmi_enable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-change-prototype-of-watchdog_nmi_enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: kernel/watchdog: change prototype of watchdog_nmi_enable()

The only caller does not handle the return value of watchdog_nmi_enable().
If there is an error, it seems to be reported by arch specific code.

Hence change watchdog_nmi_enable() return value from int to void.

Link: https://lkml.kernel.org/r/20210824031435.9664-1-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/nmi.c |    8 +++-----
 include/linux/nmi.h     |    2 +-
 kernel/watchdog.c       |    3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/arch/sparc/kernel/nmi.c~kernel-watchdog-change-prototype-of-watchdog_nmi_enable
+++ a/arch/sparc/kernel/nmi.c
@@ -282,11 +282,11 @@ __setup("nmi_watchdog=", setup_nmi_watch
  * sparc specific NMI watchdog enable function.
  * Enables watchdog if it is not enabled already.
  */
-int watchdog_nmi_enable(unsigned int cpu)
+void watchdog_nmi_enable(unsigned int cpu)
 {
 	if (atomic_read(&nmi_active) == -1) {
 		pr_warn("NMI watchdog cannot be enabled or disabled\n");
-		return -1;
+		return;
 	}
 
 	/*
@@ -295,11 +295,9 @@ int watchdog_nmi_enable(unsigned int cpu
 	 * process first.
 	 */
 	if (!nmi_init_done)
-		return 0;
+		return;
 
 	smp_call_function_single(cpu, start_nmi_watchdog, NULL, 1);
-
-	return 0;
 }
 /*
  * sparc specific NMI watchdog disable function.
--- a/include/linux/nmi.h~kernel-watchdog-change-prototype-of-watchdog_nmi_enable
+++ a/include/linux/nmi.h
@@ -119,7 +119,7 @@ static inline int hardlockup_detector_pe
 void watchdog_nmi_stop(void);
 void watchdog_nmi_start(void);
 int watchdog_nmi_probe(void);
-int watchdog_nmi_enable(unsigned int cpu);
+void watchdog_nmi_enable(unsigned int cpu);
 void watchdog_nmi_disable(unsigned int cpu);
 
 /**
--- a/kernel/watchdog.c~kernel-watchdog-change-prototype-of-watchdog_nmi_enable
+++ a/kernel/watchdog.c
@@ -95,10 +95,9 @@ __setup("nmi_watchdog=", hardlockup_pani
  * softlockup watchdog start and stop. The arch must select the
  * SOFTLOCKUP_DETECTOR Kconfig.
  */
-int __weak watchdog_nmi_enable(unsigned int cpu)
+void __weak watchdog_nmi_enable(unsigned int cpu)
 {
 	hardlockup_detector_perf_enable();
-	return 0;
 }
 
 void __weak watchdog_nmi_disable(unsigned int cpu)
_

Patches currently in -mm which might be from kernelfans@gmail.com are

kernel-watchdog-change-prototype-of-watchdog_nmi_enable.patch

