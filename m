Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC153C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B54CB64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhBYTbI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234536AbhBYT16 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AB7A64F9A;
        Thu, 25 Feb 2021 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280586;
        bh=t2oQf8ctSFPrYmFhvpAfXudx7jm/QYnCc9mnr9SBvx0=;
        h=Date:From:To:Subject:From;
        b=yLECpFJWjnHU1V0OMYKTizOfjpT/TfklTnHbfc53CNza/h/QxfunJA6J5QIWltz5d
         q31Nw9Y64Qfbhidqu4v6m6KBySW2BK7kKIuaObXO4xnt2Dehk62yKobxMWW/t/OCxs
         TD2XPPhrUndwM1cf2nVjZBeyM7q+SGW+GRz/77oA=
Date:   Thu, 25 Feb 2021 11:16:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, yaoaili@kingsoft.com
Subject:  [merged]
 =?US-ASCII?Q?mmhwpoison-send-sigbus-to-pf=5Fmce=5Fearly-processes-on-acti?=
 =?US-ASCII?Q?on-required-events.patch?= removed from -mm tree
Message-ID: <20210225191626.EXmI3Vifz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: send SIGBUS to PF_MCE_EARLY processes on action required events
has been removed from the -mm tree.  Its filename was
     mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aili Yao <yaoaili@kingsoft.com>
Subject: mm,hwpoison: send SIGBUS to PF_MCE_EARLY processes on action required events

When a memory uncorrected error is triggered by process who accessed the
address with error, It's Action Required Case for only current process
which triggered this; This Action Required case means Action optional to
other process who share the same page.  Usually killing current process
will be sufficient, other processes sharing the same page will get be
signaled when they really touch the poisoned page.

But there is another scenario that other processes sharing the same page
want to be signaled early with PF_MCE_EARLY set.  In this case, we should
get them into kill list and signal BUS_MCEERR_AO to them.

So in this patch, task_early_kill will check current process if
force_early is set, and if not current,the code will fallback to
find_early_kill_thread() to check if there is PF_MCE_EARLY process who
cares the error.

In kill_proc(), BUS_MCEERR_AR is only send to current, other processes in
kill list will be signaled with BUS_MCEERR_AO.

Link: https://lkml.kernel.org/r/20210122132424.313c8f5f.yaoaili@kingsoft.com
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events
+++ a/mm/memory-failure.c
@@ -243,9 +243,13 @@ static int kill_proc(struct to_kill *tk,
 			pfn, t->comm, t->pid);
 
 	if (flags & MF_ACTION_REQUIRED) {
-		WARN_ON_ONCE(t != current);
-		ret = force_sig_mceerr(BUS_MCEERR_AR,
+		if (t == current)
+			ret = force_sig_mceerr(BUS_MCEERR_AR,
 					 (void __user *)tk->addr, addr_lsb);
+		else
+			/* Signal other processes sharing the page if they have PF_MCE_EARLY set. */
+			ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
+				addr_lsb, t);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
@@ -440,26 +444,26 @@ static struct task_struct *find_early_ki
  * Determine whether a given process is "early kill" process which expects
  * to be signaled when some page under the process is hwpoisoned.
  * Return task_struct of the dedicated thread (main thread unless explicitly
- * specified) if the process is "early kill," and otherwise returns NULL.
+ * specified) if the process is "early kill" and otherwise returns NULL.
  *
- * Note that the above is true for Action Optional case, but not for Action
- * Required case where SIGBUS should sent only to the current thread.
+ * Note that the above is true for Action Optional case. For Action Required
+ * case, it's only meaningful to the current thread which need to be signaled
+ * with SIGBUS, this error is Action Optional for other non current
+ * processes sharing the same error page,if the process is "early kill", the
+ * task_struct of the dedicated thread will also be returned.
  */
 static struct task_struct *task_early_kill(struct task_struct *tsk,
 					   int force_early)
 {
 	if (!tsk->mm)
 		return NULL;
-	if (force_early) {
-		/*
-		 * Comparing ->mm here because current task might represent
-		 * a subthread, while tsk always points to the main thread.
-		 */
-		if (tsk->mm == current->mm)
-			return current;
-		else
-			return NULL;
-	}
+	/*
+	 * Comparing ->mm here because current task might represent
+	 * a subthread, while tsk always points to the main thread.
+	 */
+	if (force_early && tsk->mm == current->mm)
+		return current;
+
 	return find_early_kill_thread(tsk);
 }
 
_

Patches currently in -mm which might be from yaoaili@kingsoft.com are


