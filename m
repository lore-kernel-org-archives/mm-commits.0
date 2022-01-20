Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1873BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377947AbiATVbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60628 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377943AbiATVbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF6EB81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C4EC340E0;
        Thu, 20 Jan 2022 21:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714296;
        bh=3SA4odW/zJExR2QpLMh7QB2lPt5HEqbRwPaJLNV/Rcw=;
        h=Date:From:To:Subject:From;
        b=cySqrhCJH8J2ZK4t9I/jINUYuh393Cp+UkbVshvOhLS6b6LICy8kzcBuflc+QCIpY
         FZ0gT/zH35dvpPZxJayI8Pzz644BjfAE85+SWV7AsfwQO636b241tfcjHLYEAMtfh1
         4A+lVr6YRObnOD0ass5MP26pPLeWjejL4l3WpgMY=
Date:   Thu, 20 Jan 2022 13:31:35 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  [merged]
 =?US-ASCII?Q?delayacct-cleanup-flags-in-struct-task=5Fdelay=5Finfo-and-fu?=
 =?US-ASCII?Q?nctions-use-it.patch?= removed from -mm tree
Message-ID: <20220120213135.rVw3TrvHy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: cleanup flags in struct task_delay_info and functions use it
has been removed from the -mm tree.  Its filename was
     delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: delayacct: cleanup flags in struct task_delay_info and functions use it

Flags in struct task_delay_info is used to distinguish the difference
between swapin and blkio delay acountings.  But after patch "delayacct:
support swapin delay accounting for swapping without blkio", there is no
need to do that since swapin and blkio delay accounting use their own
functions.

Link: https://lkml.kernel.org/r/20211124065958.36703-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/include/linux/delayacct.h~delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it
+++ a/include/linux/delayacct.h
@@ -12,7 +12,6 @@
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
 	raw_spinlock_t	lock;
-	unsigned int	flags;	/* Private per-task flags */
 
 	/* For each stat XXX, add following, aligned appropriately
 	 *
@@ -74,18 +73,6 @@ extern void __delayacct_thrashing_end(vo
 extern void __delayacct_swapin_start(void);
 extern void __delayacct_swapin_end(void);
 
-static inline void delayacct_set_flag(struct task_struct *p, int flag)
-{
-	if (p->delays)
-		p->delays->flags |= flag;
-}
-
-static inline void delayacct_clear_flag(struct task_struct *p, int flag)
-{
-	if (p->delays)
-		p->delays->flags &= ~flag;
-}
-
 static inline void delayacct_tsk_init(struct task_struct *tsk)
 {
 	/* reinitialize in case parent's non-null pointer was dup'ed*/
@@ -184,10 +171,6 @@ static inline void delayacct_swapin_end(
 }
 
 #else
-static inline void delayacct_set_flag(struct task_struct *p, int flag)
-{}
-static inline void delayacct_clear_flag(struct task_struct *p, int flag)
-{}
 static inline void delayacct_init(void)
 {}
 static inline void delayacct_tsk_init(struct task_struct *tsk)
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


