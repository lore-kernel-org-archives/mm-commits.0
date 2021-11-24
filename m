Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D6FC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhKXW0N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:26:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235361AbhKXW0N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD81B6104F;
        Wed, 24 Nov 2021 22:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637792583;
        bh=TfhMJH0jycEK0YnfgVUcifbHZ2wm2v68v6RGDLTjwWE=;
        h=Date:From:To:Subject:From;
        b=AaPz/e//Svr542+2YconDteff7XclMl5zGFw5cd26LAl3IcRr5Vq7yCZeWfOqtXN9
         6bHGC53z4YF0lRUVccVfDBBcQ7Kqf+31RRJgsMjdfb3+FaLsBLJxHAfttd270FEK46
         ljcgtOc77keUMJQz8NQiEpuEwJZaPivjwv4wGdJs=
Date:   Wed, 24 Nov 2021 14:23:02 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  +
 =?US-ASCII?Q?delayacct-cleanup-flags-in-struct-task=5Fdelay=5Finfo-and-fu?=
 =?US-ASCII?Q?nctions-use-it.patch?= added to -mm tree
Message-ID: <20211124222302.3nsJtbIaa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: cleanup flags in struct task_delay_info and functions use it
has been added to the -mm tree.  Its filename is
     delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch

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

delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch
delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch
delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch

