Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3057CC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 22:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D6A20771
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 22:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595371391;
	bh=1O0wFPa5EqFW1vX7bCUqsLtAwzCJ1ZxGJ0Vb2ktYoQY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=W1Kv9I039ZA9EQ7PErYSd9xm4533HDgcl3jJ3oDb/YDvslb5uisVXFS2g9TvlyaJ/
	 xrOoI15h533l3DHYblftTSWhwTGChPBenVTgMV4LcpqycpwyhRjcHGf99siCtp962r
	 2ikRtScHelH0e9CWYpos8hEx98Q6XxKd/XoU0PPo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgGUWnK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jul 2020 18:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgGUWnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jul 2020 18:43:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B3B2073A;
        Tue, 21 Jul 2020 22:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595371389;
        bh=1O0wFPa5EqFW1vX7bCUqsLtAwzCJ1ZxGJ0Vb2ktYoQY=;
        h=Date:From:To:Subject:From;
        b=xwWQiJcnEUZgEPnS56p0hfABngXyVuuHFrWcEg+DD/+rQ6Arj215hSnBb9HlAMxkZ
         vrVfAaEWrECFfmeHlivHIjPk8CfrLnFGFj7WjnFUmHev7nUgxBmxKGGlcYKD7qg2/W
         gNSdp1/SGDKv8i9iLvlneT57Blgw5bwU+4T5XUu8=
Date:   Tue, 21 Jul 2020 15:43:09 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        rientjes@google.com
Subject:  +
 mm-oom-show-process-exiting-information-in-__oom_kill_process.patch added
 to -mm tree
Message-ID: <20200721224309.v74dgvTsA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: show process exiting information in __oom_kill_process()
has been added to the -mm tree.  Its filename is
     mm-oom-show-process-exiting-information-in-__oom_kill_process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-show-process-exiting-information-in-__oom_kill_process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-show-process-exiting-information-in-__oom_kill_process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, oom: show process exiting information in __oom_kill_process()

When the OOM killer finds a victim and tryies to kill it, if the victim is
already exiting, the task mm will be NULL and no process will be killed. 
But the dump_header() has been already executed, so it will be strange to
dump so much information without killing a process.  We'd better show some
helpful information to indicate why this happens.

Link: http://lkml.kernel.org/r/20200721010127.17238-1-laoar.shao@gmail.com
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Qian Cai <cai@lca.pw>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c~mm-oom-show-process-exiting-information-in-__oom_kill_process
+++ a/mm/oom_kill.c
@@ -861,6 +861,8 @@ static void __oom_kill_process(struct ta
 
 	p = find_lock_task_mm(victim);
 	if (!p) {
+		pr_info("%s: OOM victim %d (%s) is already exiting. Skip killing the task\n",
+			message, task_pid_nr(victim), victim->comm);
 		put_task_struct(victim);
 		return;
 	} else if (victim != p) {
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch
memcg-oom-check-memcg-margin-for-parallel-oom.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch
mm-oom-show-process-exiting-information-in-__oom_kill_process.patch

