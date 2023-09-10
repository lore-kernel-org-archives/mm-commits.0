Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E21C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 19:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjIJTVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 15:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjIJTVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 15:21:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DEE184
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 12:21:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B5AC433C8;
        Sun, 10 Sep 2023 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694373693;
        bh=03NmbFmzpj3NQKOGGWZtr111HXfvot88gPHfKuE0QSw=;
        h=Date:To:From:Subject:From;
        b=B5GpdN5MeTFGRl94iP6ZdMnV32ATzDzXf8Rf5ti9GZsYu0J9fkmMvZP+Vk5EVN9yO
         DthkbMasj2cySLhOPYNMf9LTnoT+NECZ0y9G5bB5PH1l4GvKt5dUfSPTfWh+Qj8HsL
         +AL38jzJ42gc/03vw4SUYZp09mCQntP12lcUpWIw=
Date:   Sun, 10 Sep 2023 12:21:32 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + getrusage-use-__for_each_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20230910192133.65B5AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: getrusage: use __for_each_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     getrusage-use-__for_each_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/getrusage-use-__for_each_thread.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: getrusage: use __for_each_thread()
Date: Sat, 9 Sep 2023 19:26:29 +0200

do/while_each_thread should be avoided when possible.

Plus this change allows to avoid lock_task_sighand(), we can use rcu
and/or sig->stats_lock instead.

Link: https://lkml.kernel.org/r/20230909172629.GA20454@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/sys.c~getrusage-use-__for_each_thread
+++ a/kernel/sys.c
@@ -1830,10 +1830,8 @@ void getrusage(struct task_struct *p, in
 		r->ru_oublock += sig->oublock;
 		if (maxrss < sig->maxrss)
 			maxrss = sig->maxrss;
-		t = p;
-		do {
+		__for_each_thread(sig, t)
 			accumulate_thread_rusage(t, r);
-		} while_each_thread(p, t);
 		break;
 
 	default:
_

Patches currently in -mm which might be from oleg@redhat.com are

introduce-__next_thread-fix-next_tid-vs-exec-race.patch
change-next_thread-to-use-__next_thread-group_leader.patch
change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch
__kill_pgrp_info-simplify-the-calculation-of-return-value.patch
getrusage-add-the-signal_struct-sig-local-variable.patch
getrusage-use-__for_each_thread.patch
taskstats-fill_stats_for_tgid-use-for_each_thread.patch

