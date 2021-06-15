Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EEFC2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B839D613B1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhFOAvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhFOAvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 20:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04C660E09;
        Tue, 15 Jun 2021 00:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623718188;
        bh=nXI4kcxxgW18KeCT6xgIrTNfMsiq8sUEz7KOWPS5Cvc=;
        h=Date:From:To:Subject:From;
        b=R7nmEcyyiZo1VkZnq3hAE7BmpvXl+h1LvJByLQrI9Kp9djCvGHMYc3ul0POda8OYl
         o5YXAwc4Mtw4CrbWxMFARWc+/QV6LfK6COT559tbC5R2JRITo1IBwsuLfj1vZZC+Ob
         f0pYYlB44/fr2u9vxCkffBIks5GrlD2USaTcglME=
Date:   Mon, 14 Jun 2021 17:49:48 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  [to-be-updated]
 mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch removed
 from -mm tree
Message-ID: <20210615004948.t-xCr-m1l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: use READ_ONCE() for accessing jiffies_scan_wait
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/kmemleak: use READ_ONCE() for accessing jiffies_scan_wait

The stop_scan_thread() and start_scan_thread() cannot really solve the
problem of concurrent accessing the global jiffies_scan_wait.

kmemleak_write              kmemleak_scan_thread
                              while (!kthread_should_stop())
  stop_scan_thread
  jiffies_scan_wait = xxx       timeout = jiffies_scan_wait
  start_scan_thread

We could replace these with a READ_ONCE() when reading jiffies_scan_wait. 
It also can prevent compiler from reordering the jiffies_scan_wait which
is in while loop.

Link: https://lkml.kernel.org/r/20210609155657.26972-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait
+++ a/mm/kmemleak.c
@@ -1567,7 +1567,7 @@ static int kmemleak_scan_thread(void *ar
 	}
 
 	while (!kthread_should_stop()) {
-		signed long timeout = jiffies_scan_wait;
+		signed long timeout = READ_ONCE(jiffies_scan_wait);
 
 		mutex_lock(&scan_mutex);
 		kmemleak_scan();
@@ -1812,11 +1812,8 @@ static ssize_t kmemleak_write(struct fil
 		ret = kstrtoul(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
-		stop_scan_thread();
-		if (secs) {
+		if (secs)
 			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
-			start_scan_thread();
-		}
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
 	else if (strncmp(buf, "dump=", 5) == 0)
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-kmemleak-fix-the-possible-wrong-memory-scanning-period.patch

