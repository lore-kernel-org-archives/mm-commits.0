Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1015E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbjJDUYq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245052AbjJDUXe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A2419E
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880F9C433C9;
        Wed,  4 Oct 2023 20:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451010;
        bh=yzw6T7jTjT40iL2MyVyVd10TJlrkRFWVxFO9Sk+15Qo=;
        h=Date:To:From:Subject:From;
        b=CsRMv6MOz1zOFdheArXceqGM6C/aIsT3L0k/9xB7RxH3Xf78jINQwp2JOMGPMF0xq
         nIf/Edc3eOWsf/yOMQxi7KHtFXwRj2JYKvXgAEAbCP2/LYWMZwpUK0GilcdJb5uyvl
         Z+Jkx1ykcadWWs/MnV81OTrNi/cGQBLfafq4+UB4=
Date:   Wed, 04 Oct 2023 13:23:28 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] change-next_thread-to-use-__next_thread-group_leader.patch removed from -mm tree
Message-Id: <20231004202330.880F9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: change next_thread() to use __next_thread() ?: group_leader
has been removed from the -mm tree.  Its filename was
     change-next_thread-to-use-__next_thread-group_leader.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: change next_thread() to use __next_thread() ?: group_leader
Date: Thu, 24 Aug 2023 16:32:01 +0200

This relies on fact that group leader is always the 1st entry in the
signal->thread_head list.

With or without this change, if the lockless next_thread(last_thread)
races with exec it can return the old or the new leader.

We are almost ready to kill task->thread_group, after this change its
only user is thread_group_empty().

Link: https://lkml.kernel.org/r/20230824143201.GB31222@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/signal.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/sched/signal.h~change-next_thread-to-use-__next_thread-group_leader
+++ a/include/linux/sched/signal.h
@@ -726,10 +726,9 @@ static inline struct task_struct *__next
 					thread_node);
 }
 
-static inline struct task_struct *next_thread(const struct task_struct *p)
+static inline struct task_struct *next_thread(struct task_struct *p)
 {
-	return list_entry_rcu(p->thread_group.next,
-			      struct task_struct, thread_group);
+	return __next_thread(p) ?: p->group_leader;
 }
 
 static inline int thread_group_empty(struct task_struct *p)
_

Patches currently in -mm which might be from oleg@redhat.com are


