Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDCFC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 21:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 752046124A
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 21:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhKDV44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhKDV4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Nov 2021 17:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E446109F;
        Thu,  4 Nov 2021 21:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636062857;
        bh=goF+RVwTBpu9VaY4hrIAMUdvBGhq5GUD7Bw5kAr2TCs=;
        h=Date:From:To:Subject:From;
        b=RJ6yQa80EdpCEp5Lu0Uk8WPdiRYTpCCcrI6wj85mCy3v9UCh5VdDbKSxDgGs4aknn
         859vZEQ0nWSkdL3BCFR0L/qx0rc+UuY2paKn4vxl2HQRI47Cfa0745H7zxT/IGgLZu
         /yaK0Y4mluz54Mk0BUbETE2FrK5ii8xceTbYQ7LU=
Date:   Thu, 04 Nov 2021 14:54:16 -0700
From:   akpm@linux-foundation.org
To:     cminyard@mvista.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  [nacked]
 oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch
 removed from -mm tree
Message-ID: <20211104215416.VupfEn1k6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: oom_kill: oom_score_adj broken for processes with small memory usage
has been removed from the -mm tree.  Its filename was
     oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: oom_kill: oom_score_adj broken for processes with small memory usage

If you have a process with less than 1000 totalpages, the calculation:

  adj = (long)p->signal->oom_score_adj;
  ...
  adj *= totalpages / 1000;

will always result in adj being zero no matter what oom_score_adj is,
which could result in the wrong process being picked for killing.

Fix by adding 1000 to totalpages before dividing.


I ran across this trying to diagnose another problem where I set up a
cgroup with a small amount of memory and couldn't get a test program to
work right.

I'm not sure this is quite right, to keep closer to the current behavior
you could do:

	if (totalpages >= 1000) adj *= totalpages / 1000;

but that would map 0-1999 to the same value.  But this at least shows the
issue.  I can provide a test program the shows the issue, but I think it's
pretty obvious from the code.  

Link: https://lkml.kernel.org/r/20210701125430.836308-1-minyard@acm.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage
+++ a/mm/oom_kill.c
@@ -234,8 +234,11 @@ long oom_badness(struct task_struct *p,
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
-	/* Normalize to oom_score_adj units */
-	adj *= totalpages / 1000;
+	/*
+	 * Normalize to oom_score_adj units.  You should never
+	 * multiply by zero here, or oom_score_adj will not work.
+	 */
+	adj *= (totalpages + 1000) / 1000;
 	points += adj;
 
 	return points;
_

Patches currently in -mm which might be from cminyard@mvista.com are


