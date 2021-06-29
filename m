Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBBBC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66AAD61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2Cgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhF2Cgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D437361CEF;
        Tue, 29 Jun 2021 02:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934058;
        bh=rswmDrldNMshx/np3nZiROCT/xMNhSjNCzNa/qghuwo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=w+BNx4u0SP5/XLmUF2Alu75rLrEDc3JbU7zbdNBqvS/vnqfF6CcRhOwJZdditw5SZ
         wHX1vLvc+PeILPo45BMuz9JyQ8hapAhac2ej+EjXdDaz8RVwrtopReegoBInw4Pk0K
         D6MkGFeT4DRvev4R/jgBZpOaKI6WMs7EJTJcvthc=
Date:   Mon, 28 Jun 2021 19:34:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, gpiccoli@canonical.com,
        joe@perches.com, keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, qais.yousef@arm.com, rdunlap@infradead.org,
        santosh@fossix.org, steve@sk2.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, wangqing@vivo.com
Subject:  [patch 019/192] kernel: watchdog: modify the explanation
 related to watchdog thread
Message-ID: <20210629023417.9KCC9Dwv4%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Subject: kernel: watchdog: modify the explanation related to watchdog thread

The watchdog thread has been replaced by cpu_stop_work, modify the
explanation related.

Link: https://lkml.kernel.org/r/1619687073-24686-2-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Qais Yousef <qais.yousef@arm.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/watchdog.c~kernel-watchdog-modify-the-explanation-related-to-watchdog-thread
+++ a/kernel/watchdog.c
@@ -92,7 +92,7 @@ __setup("nmi_watchdog=", hardlockup_pani
  * own hardlockup detector.
  *
  * watchdog_nmi_enable/disable can be implemented to start and stop when
- * softlockup watchdog threads start and stop. The arch must select the
+ * softlockup watchdog start and stop. The arch must select the
  * SOFTLOCKUP_DETECTOR Kconfig.
  */
 int __weak watchdog_nmi_enable(unsigned int cpu)
@@ -335,7 +335,7 @@ static DEFINE_PER_CPU(struct completion,
 static DEFINE_PER_CPU(struct cpu_stop_work, softlockup_stop_work);
 
 /*
- * The watchdog thread function - touches the timestamp.
+ * The watchdog feed function - touches the timestamp.
  *
  * It only runs once every sample_period seconds (4 seconds by
  * default) to reset the softlockup timestamp. If this gets delayed
@@ -558,11 +558,7 @@ static void lockup_detector_reconfigure(
 }
 
 /*
- * Create the watchdog thread infrastructure and configure the detector(s).
- *
- * The threads are not unparked as watchdog_allowed_mask is empty.  When
- * the threads are successfully initialized, take the proper locks and
- * unpark the threads in the watchdog_cpumask if the watchdog is enabled.
+ * Create the watchdog infrastructure and configure the detector(s).
  */
 static __init void lockup_detector_setup(void)
 {
@@ -628,7 +624,7 @@ void lockup_detector_soft_poweroff(void)
 
 #ifdef CONFIG_SYSCTL
 
-/* Propagate any changes to the watchdog threads */
+/* Propagate any changes to the watchdog infrastructure */
 static void proc_watchdog_update(void)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
_
