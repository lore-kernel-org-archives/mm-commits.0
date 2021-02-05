Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A8BC4332B
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C3B264FEF
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBFCjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 21:39:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhBFChI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 21:37:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C63CB64FE4;
        Fri,  5 Feb 2021 23:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612567649;
        bh=zxJMi1GT/2xLRrsIYPdTGEs4sfwZ70zlmT35BVzT+pA=;
        h=Date:From:To:Subject:From;
        b=Oa0Vrcuy9FN6RSzleL22Xmohs9JU8QGk0wlzBMrX3/aOrPpxcA8IAXMwn669jqR/H
         LmAEtN8JfYia7+8J8djl9UhbtoFC9uQpriC7UPS7WVExzmEeVlWu/aU2+s8yHxwIWf
         IK+drlBR/Txw8XR3ddAeVsGxJFwv4lGR9bnIt5Ok=
Date:   Fri, 05 Feb 2021 15:27:28 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, yaoaili@kingsoft.com
Subject:  +
 =?US-ASCII?Q?mmhwpoison-send-sigbus-to-pf=5Fmce=5Fearly-processes-on-acti?=
 =?US-ASCII?Q?on-required-events.patch?= added to -mm tree
Message-ID: <20210205232728.yFsg6kXAI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: send SIGBUS to PF_MCE_EARLY processes on action required events
has been added to the -mm tree.  Its filename is
     mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmhwpoison-send-sigbus-to-pf_mce_early-processes-on-action-required-events.patch

