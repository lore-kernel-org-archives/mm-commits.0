Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6ADC43219
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D97D16112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhICU6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235926AbhICU6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C7E610F9;
        Fri,  3 Sep 2021 20:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702669;
        bh=L+U4/9M/t4/dgHQKaeVeotheEP2HkLF+o18flHY8tNY=;
        h=Date:From:To:Subject:From;
        b=r2wJWarme4pwfx6Ll/ICJLI0nXex1eCijuAxXnoEsjMq068KNNgplOjAetEBaF47h
         y5gUIVxYDbrYh8YECkT0zLod9WZL5wEiBsxMo2A9MOeCahL4RJ28/VEAULZxTJkDdS
         T6o5czun68GGrVpCcoOiWsZhIiupaA8ZL+iWQIMc=
Date:   Fri, 03 Sep 2021 13:57:48 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, adobriyan@gmail.com, avagin@gmail.com,
        axboe@kernel.dk, bfields@fieldses.org, bp@alien8.de, bp@suse.de,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hpa@zytor.com, jirislaby@kernel.org, jlayton@kernel.org,
        ktkhai@virtuozzo.com, lizefan.x@bytedance.com, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, nglaive@gmail.com,
        oleg@redhat.com, serge@hallyn.com, shakeelb@google.com,
        tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com,
        viro@zeniv.linux.org.uk, vvs@virtuozzo.com
Subject:  [merged] memcg-enable-accounting-of-ipc-resources.patch
 removed from -mm tree
Message-ID: <20210903205748.i5IvhunNi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting of ipc resources
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-of-ipc-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting of ipc resources

When user creates IPC objects it forces kernel to allocate memory for
these long-living objects.

It makes sense to account them to restrict the host's memory consumption
from inside the memcg-limited container.

This patch enables accounting for IPC shared memory segments, messages
semaphores and semaphore's undo lists.

Link: https://lkml.kernel.org/r/d6507b06-4df6-78f8-6c54-3ae86e3b5339@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 ipc/sem.c |    9 +++++----
 ipc/shm.c |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/ipc/msg.c~memcg-enable-accounting-of-ipc-resources
+++ a/ipc/msg.c
@@ -147,7 +147,7 @@ static int newque(struct ipc_namespace *
 	key_t key = params->key;
 	int msgflg = params->flg;
 
-	msq = kmalloc(sizeof(*msq), GFP_KERNEL);
+	msq = kmalloc(sizeof(*msq), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!msq))
 		return -ENOMEM;
 
--- a/ipc/sem.c~memcg-enable-accounting-of-ipc-resources
+++ a/ipc/sem.c
@@ -514,7 +514,7 @@ static struct sem_array *sem_alloc(size_
 	if (nsems > (INT_MAX - sizeof(*sma)) / sizeof(sma->sems[0]))
 		return NULL;
 
-	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL);
+	sma = kvzalloc(struct_size(sma, sems, nsems), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!sma))
 		return NULL;
 
@@ -1855,7 +1855,7 @@ static inline int get_undo_list(struct s
 
 	undo_list = current->sysvsem.undo_list;
 	if (!undo_list) {
-		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL);
+		undo_list = kzalloc(sizeof(*undo_list), GFP_KERNEL_ACCOUNT);
 		if (undo_list == NULL)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
@@ -1941,7 +1941,7 @@ static struct sem_undo *find_alloc_undo(
 
 	/* step 2: allocate new undo structure */
 	new = kvzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems,
-		       GFP_KERNEL);
+		       GFP_KERNEL_ACCOUNT);
 	if (!new) {
 		ipc_rcu_putref(&sma->sem_perm, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
@@ -2005,7 +2005,8 @@ static long do_semtimedop(int semid, str
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
+		sops = kvmalloc_array(nsops, sizeof(*sops),
+				      GFP_KERNEL_ACCOUNT);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
--- a/ipc/shm.c~memcg-enable-accounting-of-ipc-resources
+++ a/ipc/shm.c
@@ -619,7 +619,7 @@ static int newseg(struct ipc_namespace *
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
-	shp = kmalloc(sizeof(*shp), GFP_KERNEL);
+	shp = kmalloc(sizeof(*shp), GFP_KERNEL_ACCOUNT);
 	if (unlikely(!shp))
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


