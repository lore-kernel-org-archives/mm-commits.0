Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282D8C61DD8
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30D02073C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1fZAVFGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgKNGwL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgKNGwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:52:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB7022277;
        Sat, 14 Nov 2020 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336731;
        bh=zEYtFxIkXGAzsFbtnuzralpgu2sPRq+8r/h4WDSpnIg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1fZAVFGVp/zlv9WSmMH6YC/9Wfk67Yu+3fQOt3lhLNP8xqkVnGLplY9s7b8h/rjiV
         bQUF7miXQbDiGa+wvRdtZMguGFxQ6im4yaZOZ+7t5phxYeMSe8N5xg7da7SsgRy25Y
         zjfQTwcF8gf+FeNgIncOQCR3P2mjdfpOTyjhQ6GE=
Date:   Fri, 13 Nov 2020 22:52:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pmladek@suse.com, santosh@fossix.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 10/14] kernel/watchdog: fix watchdog_allowed_mask
 not used warning
Message-ID: <20201114065210.Pih4Q7Ptk%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
