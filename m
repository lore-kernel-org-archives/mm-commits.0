Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E50C07E95
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D174613E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhGPEJM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 00:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhGPEJL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 00:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B728613BB;
        Fri, 16 Jul 2021 04:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626408376;
        bh=SMdgNAr81qVcbEKeAK0i22Q1M2tjxMb9+xiP2JfEaWM=;
        h=Date:From:To:Subject:From;
        b=NC897fPeNFD9Zhvt+h8xgOasKig/m9JZL/e01RG45FqBCp9UGZeXjF60k5Jv2pmrO
         BYoaOV9fMWKZqvUuQbZRYojMpEvwnqPWmUYq1OxnkCcHQfWUodIK4Vy2DaZQb4PPBI
         inflP8m+NARnDcTq10/aIkv+FhcaHj8nz37afuyI=
Date:   Thu, 15 Jul 2021 21:06:16 -0700
From:   akpm@linux-foundation.org
To:     cminyard@mvista.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  +
 oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch
 added to -mm tree
Message-ID: <20210716040616.y2O3p7PA_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: oom_kill: oom_score_adj broken for processes with small memory usage
has been added to the -mm tree.  Its filename is
     oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -233,8 +233,11 @@ long oom_badness(struct task_struct *p,
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

oom_kill-oom_score_adj-broken-for-processes-with-small-memory-usage.patch

