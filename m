Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2309DC7113B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 20:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjHWUK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 16:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbjHWUJ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 16:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBF510CF
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 13:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0E162B71
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 20:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34A7C433C7;
        Wed, 23 Aug 2023 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692821394;
        bh=8c+E3umWamec74PQiHTfomjV1mAnG+ZXk6/rhm93PiM=;
        h=Date:To:From:Subject:From;
        b=gI3fECMTazNYpVT1rO0f488dDXYClYsqlbz7nECNBryqa8a7wD3A0dbT8u3zUQCqM
         J67VDXA7C/dx/ECQJikFT82gZqvo9E5fVr0xcQzjdz7ob/hyYQZmMVloRL8Z3e/b43
         BhVq8+AFz4ROdWojh6z7GBofsFjXqRrUVSC/MlY8=
Date:   Wed, 23 Aug 2023 13:09:53 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + document-while_each_thread-change-first_tid-to-use-for_each_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20230823200954.B34A7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: document while_each_thread(), change first_tid() to use for_each_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     document-while_each_thread-change-first_tid-to-use-for_each_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/document-while_each_thread-change-first_tid-to-use-for_each_thread.patch

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
Subject: document while_each_thread(), change first_tid() to use for_each_thread()
Date: Wed, 23 Aug 2023 19:08:06 +0200

Add the comment to explain that while_each_thread(g,t) is not rcu-safe
unless g is stable (e.g.  current).  Even if g is a group leader and thus
can't exit before t, t or another sub-thread can exec and remove g from
the thread_group list.

The only lockless user of while_each_thread() is first_tid() and it is
fine in that it can't loop forever, yet for_each_thread() looks better and
I am going to change while_each_thread/next_thread.

Link: https://lkml.kernel.org/r/20230823170806.GA11724@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c               |    5 ++---
 include/linux/sched/signal.h |    4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c~document-while_each_thread-change-first_tid-to-use-for_each_thread
+++ a/fs/proc/base.c
@@ -3814,11 +3814,10 @@ static struct task_struct *first_tid(str
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
 	 */
-	pos = task = task->group_leader;
-	do {
+	for_each_thread(task, pos) {
 		if (!nr--)
 			goto found;
-	} while_each_thread(task, pos);
+	};
 fail:
 	pos = NULL;
 	goto out;
--- a/include/linux/sched/signal.h~document-while_each_thread-change-first_tid-to-use-for_each_thread
+++ a/include/linux/sched/signal.h
@@ -648,6 +648,10 @@ extern void flush_itimer_signals(void);
 
 extern bool current_is_single_threaded(void);
 
+/*
+ * Without tasklist/siglock it is only rcu-safe if g can't exit/exec,
+ * otherwise next_thread(t) will never reach g after list_del_rcu(g).
+ */
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
_

Patches currently in -mm which might be from oleg@redhat.com are

document-while_each_thread-change-first_tid-to-use-for_each_thread.patch

