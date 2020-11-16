Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7C4C4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01643221F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyfSSJLS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgKPSlf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPSlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:35 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91FED20855;
        Mon, 16 Nov 2020 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552093;
        bh=bkpy/6hni95GgvBF51F7cCnbB4fy/hfwGVVrllVJboQ=;
        h=Date:From:To:Subject:From;
        b=MyfSSJLSIZYmHtefN/rEK23ELoO12Gy9CUs7nUN3neiZASdr4ZIdmLmKBY9jEx7ES
         kTxoIOjBOtH+ph2NheY99Wg/4e0KlWSoCS3pNK79++2MdY4qAgY00fvk3GuNfKF/Na
         72SKpP0f10OP+3OkUoRQ252EY5kmO57Dg/8vxzDY=
Date:   Mon, 16 Nov 2020 10:41:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pmladek@suse.com, santosh@fossix.org,
        tglx@linutronix.de
Subject:  [merged]
 kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch removed
 from -mm tree
Message-ID: <20201116184133.2kWlChA2Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: fix watchdog_allowed_mask not used warning
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-fix-watchdog_allowed_mask-not-used-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


