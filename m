Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCD7C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BA36147E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhGAB7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhGAB7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4B96147D;
        Thu,  1 Jul 2021 01:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104630;
        bh=XGFDavzVD7Fn/Cellz8FUzr89lBVCuEqIFceijbBztw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lWqafO6Qp0ArxBBS0mXccD+1JrqOLxH1NvT4tlrV7EFBZcLFahD11ipzVbs/fOUfj
         wcpwxBYIIJAGfZnbVg/d0K7+7lXudYfE4oHJZDMcyAzfR9pgvI+X4d6Se2WIGGMeTH
         TyrtdSl1erD4GTIxsMj5k0EHBYYeWj801JLSci04=
Date:   Wed, 30 Jun 2021 18:57:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, dave@stgolabs.net, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, manfred@colorfullife.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        vvs@virtuozzo.com
Subject:  [patch 189/192] ipc sem: use kvmalloc for sem_undo
 allocation
Message-ID: <20210701015709.svgVwpvBh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1154,7 +1154,7 @@ static void freeary(struct ipc_namespace
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1937,7 +1937,8 @@ static struct sem_undo *find_alloc_undo(
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
+		       GFP_KERNEL);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -1949,7 +1950,7 @@ static struct sem_undo *find_alloc_undo(
 	if (!ipc_valid_object(&sma->sem_perm)) {
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
-		kfree(new);
+		kvfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
@@ -1960,7 +1961,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		kfree(new);
+		kvfree(new);
 		goto success;
 	}
 	/* step 5: initialize & link new undo structure */
@@ -2420,7 +2421,7 @@ void exit_sem(struct task_struct *tsk)
 		rcu_read_unlock();
 		wake_up_q(&wake_q);
 
-		kfree_rcu(un, rcu);
+		kvfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
_
