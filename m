Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D66C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD29361C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFT0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFT0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A131261CA8;
        Tue,  6 Jul 2021 19:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599418;
        bh=7bhn4oOmlvnNJz6WnnT8gzIK1E8c95i8RskD+MtlExM=;
        h=Date:From:To:Subject:From;
        b=ww/etFxPzJ/AOTUKQSmDQU0IdSPA2hoH73ao4x458kKGiNIrcHKCCbAuRaZ8Nvhkr
         Kifg9M9tvWWAizqDLNQqskRkd4qn2t68bnWMjmzKlYeqqzs2DDQ50YLZg2fYxncYrp
         XxSRUzNQhb8BVFb2qyDgxafCgGo4XxAT5vVLNOdE=
Date:   Tue, 06 Jul 2021 12:23:37 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, adobriyan@gmail.com, dave@stgolabs.net,
        guro@fb.com, hannes@cmpxchg.org, manfred@colorfullife.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [merged]
 ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch removed from -mm tree
Message-ID: <20210706192337.2ibajw1mX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: use kmalloc for msg_queue and shmid_kernel
has been removed from the -mm tree.  Its filename was
     ipc-use-kmalloc-for-msg_queue-and-shmid_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


