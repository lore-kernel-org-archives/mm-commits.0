Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DB8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiATCKL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43764 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358190AbiATCKK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0001615EE
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C85C004E1;
        Thu, 20 Jan 2022 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644610;
        bh=fhYZ5de3U+PmZP5EiRTk5VD9Td7x2tkElhDTWFsWF14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kwTS3PTCgN72sZRw0X3XgshJxESGW5ID1CPDYbFnEECAbjPEZrvm0SrDmrgyrXjOi
         7XcdtsGvuztEWZULQ7eRhQ3OyxyF+1rGo/Vdm8E4eELHfzG7t6Gsgtx3XGMxdfG3wP
         D/AUPLZMa3PlGNg0wzySZP7c1QY+kzFKPI0D4bQs=
Date:   Wed, 19 Jan 2022 18:10:09 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bsingharora@gmail.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, yang.yang29@zte.com.cn,
        zealci@zte.com.cn
Subject:  [patch 46/55] delayacct: cleanup flags in struct
 task_delay_info and functions use it
Message-ID: <20220120021009.7aaRcJt-h%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
