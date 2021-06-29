Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50072C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39EBB61A2B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhF2Ch3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhF2Ch2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C2461D02;
        Tue, 29 Jun 2021 02:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934102;
        bh=4cE/8HJP5sT8ERsgvJylaiUPxIW4s+gi1dcR86jyYok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jC4PtGh4iaJp2vfXE1CmmK5zR96MsIEFOKbjzc44b1bgpFVhc8EPObC71BC7o2MSD
         LcRinc3dvasFLORgF2+uCUHS5i2Cjxlb5s3mfdZAenqSvOYhkjMwT2KqrzaYtHD3aH
         IE4NzIdF5zgqltA0skz9BCMtiKKAo1I2LTsxunAU=
Date:   Mon, 28 Jun 2021 19:35:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yanfei.xu@windriver.com
Subject:  [patch 033/192] mm/kmemleak: fix possible wrong memory
 scanning period
Message-ID: <20210629023501.ZQbWNxCiI%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/kmemleak: fix possible wrong memory scanning period

This commit contains 3 modifications:

1. Convert the type of jiffies_scan_wait to "unsigned long".

2. Use READ/WRITE_ONCE() for accessing "jiffies_scan_wait".

3. Fix the possible wrong memory scanning period.  If you set a large
   memory scanning period like blow, then the "secs" variable will be
   non-zero, however the value of "jiffies_scan_wait" will be zero.

    echo "scan=0x10000000" > /sys/kernel/debug/kmemleak

It is because the type of the msecs_to_jiffies()'s parameter is "unsigned
int", and the "secs * 1000" is larger than its max value.  This in turn
leads a unexpected jiffies_scan_wait, maybe zero.  We corret it by
replacing kstrtoul() with kstrtouint(), and check the msecs to prevent it
larger than UINT_MAX.

Link: https://lkml.kernel.org/r/20210613174022.23044-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-the-possible-wrong-memory-scanning-period
+++ a/mm/kmemleak.c
@@ -219,7 +219,7 @@ static struct task_struct *scan_thread;
 static unsigned long jiffies_min_age;
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
-static signed long jiffies_scan_wait;
+static unsigned long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
@@ -1567,7 +1567,7 @@ static int kmemleak_scan_thread(void *ar
 	}
 
 	while (!kthread_should_stop()) {
-		signed long timeout = jiffies_scan_wait;
+		signed long timeout = READ_ONCE(jiffies_scan_wait);
 
 		mutex_lock(&scan_mutex);
 		kmemleak_scan();
@@ -1807,14 +1807,20 @@ static ssize_t kmemleak_write(struct fil
 	else if (strncmp(buf, "scan=off", 8) == 0)
 		stop_scan_thread();
 	else if (strncmp(buf, "scan=", 5) == 0) {
-		unsigned long secs;
+		unsigned secs;
+		unsigned long msecs;
 
-		ret = kstrtoul(buf + 5, 0, &secs);
+		ret = kstrtouint(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
+
+		msecs = secs * MSEC_PER_SEC;
+		if (msecs > UINT_MAX)
+			msecs = UINT_MAX;
+
 		stop_scan_thread();
-		if (secs) {
-			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
+		if (msecs) {
+			WRITE_ONCE(jiffies_scan_wait, msecs_to_jiffies(msecs));
 			start_scan_thread();
 		}
 	} else if (strncmp(buf, "scan", 4) == 0)
_
