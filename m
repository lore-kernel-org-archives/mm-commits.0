Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422D3C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 18:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBMSjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 13:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBMSjl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 13:39:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED66219F2E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F03BFCE1CEC
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFBCC4339B;
        Mon, 13 Feb 2023 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676313572;
        bh=Fgom2Emd73IPVl6J1L2a8S7VX7SkKhG3ghVoyiisGYI=;
        h=Date:To:From:Subject:From;
        b=x5NM6d2Wf5QgDfyd/R3/6GfYYLrZ/Nwkqql4b6ZR/1DDc6xvz3TLpI8tFX6seu3Cy
         sEGqP998lWdQ5hrQpYPMl+9+Fe+PDOP8Pvgd7f2jaZLWb8jOBr9SsmpBoI4YmjxniJ
         7awE06OJ+vxa5+vupDs9yC0DetrTTWaJiC8GGIr0=
Date:   Mon, 13 Feb 2023 10:39:31 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        david@redhat.com, wang.yong12@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond.patch added to mm-nonmm-unstable branch
Message-Id: <20230213183932.3BFBCC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: improve the average delay precision of getdelay tool to microsecond
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond.patch

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
From: Wang Yong <wang.yong12@zte.com.cn>
Subject: delayacct: improve the average delay precision of getdelay tool to microsecond
Date: Mon, 13 Feb 2023 14:08:08 +0800 (CST)

Improve the average delay precision of getdelay tool to microsecond.  When
using the getdelay tool, it is sometimes found that the average delay
except CPU is not 0, but display is 0, because the precison is too low. 
For example, see delay average of SWAP below when using ZRAM.

print delayacct stats ON
PID	32915
CPU             count     real total  virtual total    delay total  delay average
               339202     2793871936     9233585504        7951112          0.000ms
IO              count    delay total  delay average
                   41      419296904             10ms
SWAP            count    delay total  delay average
               242589     1045792384              0ms

This wrong display is misleading, so improve the millisecond precision of
the average delay to microsecond just like CPU.  Then user would get more
accurate information of delay time.

Link: https://lkml.kernel.org/r/202302131408087983857@zte.com.cn
Signed-off-by: Wang Yong <wang.yong12@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/accounting/delay-accounting.rst~delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond
+++ a/Documentation/accounting/delay-accounting.rst
@@ -109,17 +109,17 @@ Get sum of delays, since system boot, fo
 	CPU             count     real total  virtual total    delay total  delay average
 	                    8        7000000        6872122        3382277          0.423ms
 	IO              count    delay total  delay average
-		            0              0              0ms
+                   0              0          0.000ms
 	SWAP            count    delay total  delay average
-	                    0              0              0ms
+                       0              0          0.000ms
 	RECLAIM         count    delay total  delay average
-		            0              0              0ms
+                   0              0          0.000ms
 	THRASHING       count    delay total  delay average
-	                    0              0              0ms
+                       0              0          0.000ms
 	COMPACT         count    delay total  delay average
-	                    0              0              0ms
-        WPCOPY          count    delay total  delay average
-                            0              0              0ms
+                       0              0          0.000ms
+   WPCOPY          count    delay total  delay average
+                       0              0          0.000ms
 
 Get IO accounting for pid 1, it works only with -p::
 
--- a/Documentation/translations/zh_CN/accounting/delay-accounting.rst~delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond
+++ a/Documentation/translations/zh_CN/accounting/delay-accounting.rst
@@ -91,15 +91,15 @@ 获取所有tgid为5的任务从系统�
 	CPU             count     real total  virtual total    delay total  delay average
 	                    8        7000000        6872122        3382277          0.423ms
 	IO              count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	SWAP            count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	RECLAIM         count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	THRASHING       count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	COMPACT         count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 
 获取pid为1的IO计数，它只和-p一起使用::
 	# ./getdelays -i -p 1
--- a/tools/accounting/getdelays.c~delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond
+++ a/tools/accounting/getdelays.c
@@ -198,17 +198,17 @@ static void print_delayacct(struct tasks
 	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
 	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
 	       "IO    %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "SWAP  %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "RECLAIM  %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "THRASHING%12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "COMPACT  %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "WPCOPY   %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n",
+          "      %15llu%15llu%15.3fms\n",
 	       "count", "real total", "virtual total",
 	       "delay total", "delay average",
 	       (unsigned long long)t->cpu_count,
@@ -219,27 +219,27 @@ static void print_delayacct(struct tasks
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
-	       average_ms(t->blkio_delay_total, t->blkio_count),
+          average_ms((double)t->blkio_delay_total, t->blkio_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
-	       average_ms(t->swapin_delay_total, t->swapin_count),
+          average_ms((double)t->swapin_delay_total, t->swapin_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->freepages_count,
 	       (unsigned long long)t->freepages_delay_total,
-	       average_ms(t->freepages_delay_total, t->freepages_count),
+          average_ms((double)t->freepages_delay_total, t->freepages_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->thrashing_count,
 	       (unsigned long long)t->thrashing_delay_total,
-	       average_ms(t->thrashing_delay_total, t->thrashing_count),
+          average_ms((double)t->thrashing_delay_total, t->thrashing_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->compact_count,
 	       (unsigned long long)t->compact_delay_total,
-	       average_ms(t->compact_delay_total, t->compact_count),
+          average_ms((double)t->compact_delay_total, t->compact_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->wpcopy_count,
 	       (unsigned long long)t->wpcopy_delay_total,
-	       average_ms(t->wpcopy_delay_total, t->wpcopy_count));
+          average_ms((double)t->wpcopy_delay_total, t->wpcopy_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are

delayacct-improve-the-average-delay-precision-of-getdelay-tool-to-microsecond.patch

