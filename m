Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C80C43460
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D716103E
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhEJB0n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJB0n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD54161132;
        Mon, 10 May 2021 01:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620609939;
        bh=uhv24Mlw/lQ0WokllF/pg4tquvhlOZC3RbmkVd1ra10=;
        h=Date:From:To:Subject:From;
        b=jwv3H1fSDU7Mupel2k35/OZ4mxeahv0GuB9wbINlWfJktbHws4fbv3qzVJVFrs7SX
         uRGlEwIBNDKjWV5aep778Qkik0IkvZ4rQTa0mAOw80BqcWtttYSWLZNkBlROCu8qZT
         g93kh+3MRCbSvbIulemHLO/PcN7ZG98q/KHAbFnU=
Date:   Sun, 09 May 2021 18:25:38 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, adobriyan@gmail.com, dave@stgolabs.net,
        guro@fb.com, hannes@cmpxchg.org, manfred@colorfullife.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  + ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch
 added to -mm tree
Message-ID: <20210510012538.YS05fWzaT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: use kmalloc for msg_queue and shmid_kernel
has been added to the -mm tree.  Its filename is
     ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch

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
Subject: ipc: use kmalloc for msg_queue and shmid_kernel

msg_queue and shmid_kernel are quite small objects, no need to use
kvmalloc for them.  mhocko@: "Both of them are 256B on most 64b systems."

Previously these objects was allocated via ipc_alloc/ipc_rcu_alloc(),
common function for several ipc objects.  It had kvmalloc call inside(). 
Later, this function went away and was finally replaced by direct kvmalloc
call, and now we can use more suitable kmalloc/kfree for them.

Link: https://lkml.kernel.org/r/0d0b6c9b-8af3-29d8-34e2-a565c53780f3@virtuozzo.com
Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    6 +++---
 ipc/shm.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/ipc/msg.c~ipc-use-kmalloc-for-msg_queue-and-shmid_kernel
+++ a/ipc/msg.c
@@ -130,7 +130,7 @@ static void msg_rcu_free(struct rcu_head
 	struct msg_queue *msq = container_of(p, struct msg_queue, q_perm);
 
 	security_msg_queue_free(&msq->q_perm);
-	kvfree(msq);
+	kfree(msq);
 }
 
 /**
@@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = kvmalloc(sizeof(*msq), GFP_KERNEL);
+	msq = kmalloc(sizeof(*msq), GFP_KERNEL);
 	if (unlikely(!msq))
 		return -ENOMEM;
 
@@ -157,7 +157,7 @@ static int newque(struct ipc_namespace *
 	msq->q_perm.security = NULL;
 	retval = security_msg_queue_alloc(&msq->q_perm);
 	if (retval) {
-		kvfree(msq);
+		kfree(msq);
 		return retval;
 	}
 
--- a/ipc/shm.c~ipc-use-kmalloc-for-msg_queue-and-shmid_kernel
+++ a/ipc/shm.c
@@ -222,7 +222,7 @@ static void shm_rcu_free(struct rcu_head
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
 	security_shm_free(&shp->shm_perm);
-	kvfree(shp);
+	kfree(shp);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = kvmalloc(sizeof(*shp), GFP_KERNEL);
+	shp = kmalloc(sizeof(*shp), GFP_KERNEL);
 	if (unlikely(!shp))
 		return -ENOMEM;
 
@@ -630,7 +630,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_perm.security = NULL;
 	error = security_shm_alloc(&shp->shm_perm);
 	if (error) {
-		kvfree(shp);
+		kfree(shp);
 		return error;
 	}
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

ipc-sem-use-kvmalloc-for-sem_undo-allocation.patch
ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch

