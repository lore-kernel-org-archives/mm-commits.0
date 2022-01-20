Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F859C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiATCKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiATCKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D42B6145A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9623DC340E4;
        Thu, 20 Jan 2022 02:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644606;
        bh=H0CEFoSISCPFCDRFnMeFFAH/fy/VQv/ddBxTwfNzOPM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1SKMbPS2it3P40OtYmkm163JY0QvN0SJgE/Bb/Pe5eBEndUmQBlMKmVSQGjRGTyQ/
         c+cdNRbAl5R8WT+6Wno+46sX/TcxZdYveoYrAdykHpxAJ35fiH6lYQw6J/1jbZaBJD
         s+DAQ8S9NYZg6++q97NDYPThhS6wJsXvdZqp5gO8=
Date:   Wed, 19 Jan 2022 18:10:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bsingharora@gmail.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, yang.yang29@zte.com.cn,
        zealci@zte.com.cn
Subject:  [patch 45/55] delayacct: fix incomplete disable operation
 when switch enable to disable
Message-ID: <20220120021006.cVLJPygAt%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Yang <yang.yang29@zte.com.cn>
Subject: delayacct: fix incomplete disable operation when switch enable to disable

When a task is created after delayacct is enabled, kernel will do all the
delay accountings for that task.  The problems is if user disables
delayacct by set /proc/sys/kernel/task_delayacct to zero, only blkio delay
accounting is disabled.

Now disable all the kinds of delay accountings when
/proc/sys/kernel/task_delayacct sets to zero.

Link: https://lkml.kernel.org/r/20211123140342.32962-1-ran.xiaokai@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/delayacct.h~delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable
+++ a/include/linux/delayacct.h
@@ -131,36 +131,54 @@ static inline __u64 delayacct_blkio_tick
 
 static inline void delayacct_freepages_start(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_freepages_start();
 }
 
 static inline void delayacct_freepages_end(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_freepages_end();
 }
 
 static inline void delayacct_thrashing_start(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_thrashing_start();
 }
 
 static inline void delayacct_thrashing_end(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_thrashing_end();
 }
 
 static inline void delayacct_swapin_start(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_swapin_start();
 }
 
 static inline void delayacct_swapin_end(void)
 {
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
 	if (current->delays)
 		__delayacct_swapin_end();
 }
_
