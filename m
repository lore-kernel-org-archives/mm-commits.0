Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD089E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbjJDUYl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbjJDUX0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CDF115
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE73C433C7;
        Wed,  4 Oct 2023 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451002;
        bh=wQ60CBfmSjz6g3Qc9hG8tmMSfW0Xlkt30ne0hr5yl2s=;
        h=Date:To:From:Subject:From;
        b=11PDNIPY+22kRoUlDBGTLwZleXOK12TlqjY5dbRIvGCqFxJnx7lFnk6A+u2ApBLWh
         clanzN3THEf7IKabwsQO27IDzLt2sdVlvMxpfWnY4JSZVRVsTHyi1+yKJC7eLu/gqP
         aYqsaTphP6BKA6u8pc+OiyMiSirAjEStFEIUDT3g=
Date:   Wed, 04 Oct 2023 13:23:21 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] change-thread_group_empty-to-use-task_struct-thread_node.patch removed from -mm tree
Message-Id: <20231004202322.9AE73C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: change thread_group_empty() to use task_struct->thread_node
has been removed from the -mm tree.  Its filename was
     change-thread_group_empty-to-use-task_struct-thread_node.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/signal.h~change-thread_group_empty-to-use-task_struct-thread_node
+++ a/include/linux/sched/signal.h
@@ -733,7 +733,8 @@ static inline struct task_struct *next_t
 
 static inline int thread_group_empty(struct task_struct *p)
 {
-	return list_empty(&p->thread_group);
+	return thread_group_leader(p) &&
+	       list_is_last(&p->thread_node, &p->signal->thread_head);
 }
 
 #define delay_group_leader(p) \
_

Patches currently in -mm which might be from oleg@redhat.com are


