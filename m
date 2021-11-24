Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC35C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhKXA0o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231515AbhKXA0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:26:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8BA2610A5;
        Wed, 24 Nov 2021 00:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713415;
        bh=PxzsDkZQCCMrPm7I8iIr0t7HqtPtaPQE3lyb/bPlmXk=;
        h=Date:From:To:Subject:From;
        b=l8EVaH7aePClosBIwr25UmsWhlzuJs5S7y78DPf/lWevFSRy3CsMVvPHU6sS+MefT
         me6LFxdvo8cFOniGiXdLj/9rbdy5FtZHBe5yZIJB3X1vHxb7hYVg0c2AyKvppjBiDF
         4XpriIOSoPS3zbViPL1R4/I4Eci6GgIC1S9AXTto=
Date:   Tue, 23 Nov 2021 16:23:34 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  +
 =?US-ASCII?Q?delayacct-fix-incomplete-disable-operation-when-switch-ena?=
 =?US-ASCII?Q?ble-to-disable.patch?= added to -mm tree
Message-ID: <20211124002334.yVOtbk7U5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: fix incomplete disable operation when switch enable to disable
has been added to the -mm tree.  Its filename is
     delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch
delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch

