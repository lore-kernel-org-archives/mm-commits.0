Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D377C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C8361361
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhEJB0l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJB0l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0917B6103E;
        Mon, 10 May 2021 01:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620609936;
        bh=/IiCJsqqh64Erk0XZxSzb8CKLHEcwbLWNYsEDL/MG8Q=;
        h=Date:From:To:Subject:From;
        b=lldaLd/02zMd75kMzG2TvEU/a17/4s+Ndl1PbYB1kNSSOY98ScX+puf3cBLvUnwiL
         rCE/58lEKNC+Dv13WS/A/vliSU/tVXMevuZJ/55pgQPh4rKOukYwQN5uX93sFu8PGJ
         65S4vzjEtdAQBqZCPc8Dh9xRos0i0IAJdIjuRc14=
Date:   Sun, 09 May 2021 18:25:35 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, adobriyan@gmail.com, dave@stgolabs.net,
        guro@fb.com, hannes@cmpxchg.org, manfred@colorfullife.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  + ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch
 added to -mm tree
Message-ID: <20210510012535.BHb12o1wN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc sem: use kvmalloc for sem_undo allocation
has been added to the -mm tree.  Its filename is
     ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: ipc sem: use kvmalloc for sem_undo allocation

Patch series "ipc: allocations cleanup", v2.

Some ipc objects use the wrong allocation functions: small objects can use
kmalloc(), and vice versa, potentially large objects can use kmalloc().


This patch (of 2):

Size of sem_undo can exceed one page and with the maximum possible nsems =
32000 it can grow up to 64Kb.  Let's switch its allocation to kvmalloc to
avoid user-triggered disruptive actions like OOM killer in case of
high-order memory shortage.

User triggerable high order allocations are quite a problem on heavily
fragmented systems.  They can be a DoS vector.

Link: https://lkml.kernel.org/r/ebc3ac79-3190-520d-81ce-22ad194986ec@virtuozzo.com
Link: https://lkml.kernel.org/r/a6354fd9-2d55-2e63-dd4d-fa7dc1d11134@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/ipc/sem.c~ipc-sem-use-kvmalloc-for-sem_undo-allocation
+++ a/ipc/sem.c
@@ -1152,7 +1152,7 @@ static void freeary(struct ipc_namespace
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1935,7 +1935,8 @@ static struct sem_undo *find_alloc_undo(
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
+		       GFP_KERNEL);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -1947,7 +1948,7 @@ static struct sem_undo *find_alloc_undo(
 	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
-		kfree(new);
+		kvfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
@@ -1958,7 +1959,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		kfree(new);
+		kvfree(new);
 		goto success;
 	}
 	/* step 5: initialize & link new undo structure */
@@ -2418,7 +2419,7 @@ void exit_sem(struct task_struct *tsk)
 		rcu_read_unlock();
 		wake_up_q(&wake_q);
 
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch
ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch

