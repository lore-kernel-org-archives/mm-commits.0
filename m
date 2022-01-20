Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F41C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377946AbiATVbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiATVbf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B726B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6ADC340E0;
        Thu, 20 Jan 2022 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714292;
        bh=abIN/Y7A2lBfUsIN3CppgY+VJfvv+VrI+EHDRxqjhsg=;
        h=Date:From:To:Subject:From;
        b=SSvKADampu52eoaZ5PW+z7wxvhm3vwVjd4xT8BTtrwHo7PG9r06xYmmR69WQaZyQg
         L2UecPUH3GZQTualxGwwNuzkgCuycSvhwZLtbGurAF0+NqEI/0Gu1cwQZBNGSODU76
         o3BfG1z1ykskJGIz0Ksj22dSkTLuwA0tLQ1jduzo=
Date:   Thu, 20 Jan 2022 13:31:32 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  [merged]
 =?US-ASCII?Q?delayacct-fix-incomplete-disable-operation-when-switch-ena?=
 =?US-ASCII?Q?ble-to-disable.patch?= removed from -mm tree
Message-ID: <20220120213132.4xkvhY0lR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: fix incomplete disable operation when switch enable to disable
has been removed from the -mm tree.  Its filename was
     delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


