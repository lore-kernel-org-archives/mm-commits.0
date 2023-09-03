Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60351C71153
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 23:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbjICXvB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjICXvB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 19:51:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A766C101
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 16:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45322B8069C
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0153C433C8;
        Sun,  3 Sep 2023 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785055;
        bh=SXuXVtdx2ZQQtqBhtdxH5oT+PHtFMIJ58lq3LBgnsDw=;
        h=Date:To:From:Subject:From;
        b=x/AlaNL9HoAY876Q5LkyvSfVVqle+3GTvPz86QP3hKn/TS+esAI4LRPr+Hdmuckiz
         /aKJX8YMinyJCy35T60mMwekvdlssmecWZ7246TAzFUWxhicbMCW8EqjfkhW8vy5cE
         i26IKJUYjgBltFoE9topZvWmAhy7sIHNv1La/ZpM=
Date:   Sun, 03 Sep 2023 16:50:53 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + change-thread_group_empty-to-use-task_struct-thread_node.patch added to mm-nonmm-unstable branch
Message-Id: <20230903235054.E0153C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: change thread_group_empty() to use task_struct->thread_node
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     change-thread_group_empty-to-use-task_struct-thread_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/change-thread_group_empty-to-use-task_struct-thread_node.patch

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
Subject: change thread_group_empty() to use task_struct->thread_node
Date: Sat, 26 Aug 2023 13:14:06 +0200

Patch series "kill task_struct->thread_group".


This patch (of 2):

It could use list_is_singular() but this way it is cheaper.  Plus the
thread_group_leader() check makes it clear that thread_group_empty() can
only return true if p is a group leader.  This was not immediately obvious
before this patch.

task_struct->thread_group no longer has users, it can die.

Link: https://lkml.kernel.org/r/20230826111200.GA22982@redhat.com
Link: https://lkml.kernel.org/r/20230826111406.GA23238@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/signal.h~change-thread_group_empty-to-use-task_struct-thread_node
+++ a/include/linux/sched/signal.h
@@ -723,7 +723,8 @@ static inline struct task_struct *next_t
 
 static inline int thread_group_empty(struct task_struct *p)
 {
-	return list_empty(&p->thread_group);
+	return thread_group_leader(p) &&
+	       list_is_last(&p->thread_node, &p->signal->thread_head);
 }
 
 #define delay_group_leader(p) \
_

Patches currently in -mm which might be from oleg@redhat.com are

change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch

