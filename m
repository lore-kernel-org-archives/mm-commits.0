Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F223BC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC3CA60F94
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhG0VIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234920AbhG0VIQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94CB60F9D;
        Tue, 27 Jul 2021 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420096;
        bh=EsqlQ5IUXYfvNteV1HT16T5Tc6htqoX4HV6rXZsNimk=;
        h=Date:From:To:Subject:From;
        b=pQIQLF6JrGK6iDs5p0saEX0RSn53tfA6+uI1Wqn0tf8IZhtrW2kiJUpnAoXf5Xkcr
         gaSdIqV3ATjJQsqIUrlaJDNKqxsSfgpCwJ6ao3eq5fnzCVam4ad4CvK1Mp2r3Wc22D
         OhJBvWF/G1zGxCfg+Qq1sh/n67jIsw9liIHuwIxc=
Date:   Tue, 27 Jul 2021 14:08:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vdavydov.dev@gmail.com, tj@kernel.org, tglx@linutronix.de,
        shakeelb@google.com, serge@hallyn.com, oleg@redhat.com,
        nglaive@gmail.com, mingo@redhat.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, ktkhai@virtuozzo.com, jlayton@kernel.org,
        jirislaby@kernel.org, hpa@zytor.com, hannes@cmpxchg.org,
        guro@fb.com, gregkh@linuxfoundation.org, ebiederm@xmission.com,
        christian.brauner@ubuntu.com, bp@suse.de, bp@alien8.de,
        bfields@fieldses.org, axboe@kernel.dk, avagin@gmail.com,
        adobriyan@gmail.com, 0x7f454c46@gmail.com, vvs@virtuozzo.com
Subject:  +
 memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch added to
 -mm tree
Message-ID: <20210727210815.YEjWC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for new namesapces and struct nsproxy
has been added to the -mm tree.  Its filename is
     memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch

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
Subject: memcg: enable accounting for new namesapces and struct nsproxy

Container admin can create new namespaces and force kernel to allocate up
to several pages of memory for the namespaces and its associated
structures.

Net and uts namespaces have enabled accounting for such allocations.  It
makes sense to account for rest ones to restrict the host's memory
consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/5525bcbf-533e-da27-79b7-158686c64e13@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c            |    2 +-
 ipc/namespace.c           |    2 +-
 kernel/cgroup/namespace.c |    2 +-
 kernel/nsproxy.c          |    2 +-
 kernel/pid_namespace.c    |    2 +-
 kernel/time/namespace.c   |    4 ++--
 kernel/user_namespace.c   |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/fs/namespace.c
@@ -3289,7 +3289,7 @@ static struct mnt_namespace *alloc_mnt_n
 	if (!ucounts)
 		return ERR_PTR(-ENOSPC);
 
-	new_ns = kzalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
+	new_ns = kzalloc(sizeof(struct mnt_namespace), GFP_KERNEL_ACCOUNT);
 	if (!new_ns) {
 		dec_mnt_namespaces(ucounts);
 		return ERR_PTR(-ENOMEM);
--- a/ipc/namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/ipc/namespace.c
@@ -42,7 +42,7 @@ static struct ipc_namespace *create_ipc_
 		goto fail;
 
 	err = -ENOMEM;
-	ns = kzalloc(sizeof(struct ipc_namespace), GFP_KERNEL);
+	ns = kzalloc(sizeof(struct ipc_namespace), GFP_KERNEL_ACCOUNT);
 	if (ns == NULL)
 		goto fail_dec;
 
--- a/kernel/cgroup/namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/kernel/cgroup/namespace.c
@@ -24,7 +24,7 @@ static struct cgroup_namespace *alloc_cg
 	struct cgroup_namespace *new_ns;
 	int ret;
 
-	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
+	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL_ACCOUNT);
 	if (!new_ns)
 		return ERR_PTR(-ENOMEM);
 	ret = ns_alloc_inum(&new_ns->ns);
--- a/kernel/nsproxy.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/kernel/nsproxy.c
@@ -568,6 +568,6 @@ out:
 
 int __init nsproxy_cache_init(void)
 {
-	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
+	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC|SLAB_ACCOUNT);
 	return 0;
 }
--- a/kernel/pid_namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/kernel/pid_namespace.c
@@ -450,7 +450,7 @@ const struct proc_ns_operations pidns_fo
 
 static __init int pid_namespaces_init(void)
 {
-	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACCOUNT);
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	register_sysctl_paths(kern_path, pid_ns_ctl_table);
--- a/kernel/time/namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/kernel/time/namespace.c
@@ -88,13 +88,13 @@ static struct time_namespace *clone_time
 		goto fail;
 
 	err = -ENOMEM;
-	ns = kmalloc(sizeof(*ns), GFP_KERNEL);
+	ns = kmalloc(sizeof(*ns), GFP_KERNEL_ACCOUNT);
 	if (!ns)
 		goto fail_dec;
 
 	refcount_set(&ns->ns.count, 1);
 
-	ns->vvar_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	ns->vvar_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!ns->vvar_page)
 		goto fail_free;
 
--- a/kernel/user_namespace.c~memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy
+++ a/kernel/user_namespace.c
@@ -1385,7 +1385,7 @@ const struct proc_ns_operations userns_o
 
 static __init int user_namespaces_init(void)
 {
-	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
+	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC | SLAB_ACCOUNT);
 	return 0;
 }
 subsys_initcall(user_namespaces_init);
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch
memcg-enable-accounting-for-mnt_cache-entries.patch
memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch
memcg-enable-accounting-for-file-lock-caches.patch
memcg-enable-accounting-for-fasync_cache.patch
memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch
memcg-enable-accounting-of-ipc-resources.patch
memcg-enable-accounting-for-signals.patch
memcg-enable-accounting-for-posix_timers_cache-slab.patch
memcg-enable-accounting-for-tty-related-objects.patch
memcg-enable-accounting-for-ldt_struct-objects.patch

