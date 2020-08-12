Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CD8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99B620774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266118;
	bh=Jy3gv0kiSAPupCTvRV1pzeCYhPaUx+jB+qj9MKbcV/o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EkAWoXzkP+12b0o5eIk1keNuhuRWzDp3SgRvFNjObnbXK3sBmeRfZjJ0O6gQyGunK
	 3rdpJrTpnlpZ659S+LsZ8yjDlHWw82XQQtncKu2MJJ9o6aSSmdV2ZfgkiV+ltr3tnY
	 aAdbbKKqatGd+XKSbXP0PhgFaBaW9BcHFvdDWqJs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLVB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8591720768;
        Wed, 12 Aug 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266117;
        bh=Jy3gv0kiSAPupCTvRV1pzeCYhPaUx+jB+qj9MKbcV/o=;
        h=Date:From:To:Subject:From;
        b=1iYf5R5p3UN1gsH1apfoTItKZh/k11BiKQij9Ifugfc1pLcA6aVh9KWvnydixOXmN
         5gNzfrbI714aosHFhbKsM0T1GWgtgD9dJWKGYqXH+3su71YXuKQWZb6gMX138f89U8
         svsSSDVBGsIanaCQ6iah2jxIt5j/T2tqb2U05/O4=
Date:   Wed, 12 Aug 2020 14:01:57 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        rientjes@google.com
Subject:  [merged]
 mm-oom-show-process-exiting-information-in-__oom_kill_process.patch removed
 from -mm tree
Message-ID: <20200812210157.BwizQaxAo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: show process exiting information in __oom_kill_process()
has been removed from the -mm tree.  Its filename was
     mm-oom-show-process-exiting-information-in-__oom_kill_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, oom: show process exiting information in __oom_kill_process()

When the OOM killer finds a victim and tryies to kill it, if the victim is
already exiting, the task mm will be NULL and no process will be killed. 
But the dump_header() has been already executed, so it will be strange to
dump so much information without killing a process.  We'd better show some
helpful information to indicate why this happens.

Link: http://lkml.kernel.org/r/20200721010127.17238-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Qian Cai <cai@lca.pw>
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


