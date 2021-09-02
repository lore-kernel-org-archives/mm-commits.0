Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD12C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDBD610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbhIBV4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347930AbhIBV4b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B5D6610CF;
        Thu,  2 Sep 2021 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619728;
        bh=JtgFrOMchZQpFx6VBe+IgiGiuSSZ04IU1jtYP7U2Jds=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RuBK0yAaGdJK+osej6dUPH7CUnH1YTBC7JsH4M5RvQ4qI8cM7YrpqRRi7Vvr5uzN/
         7kv6UJz0C8McllC/MJpgo3bNsz7NuKOq/6BfWXWh/2B6MxMO9vxQJD3dYcHTtovgCV
         gqwm9HZC+WHrV9YZj/FC2YQR09lFLrxy/7x5t5DM=
Date:   Thu, 02 Sep 2021 14:55:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, avagin@gmail.com, axboe@kernel.dk,
        bfields@fieldses.org, bp@alien8.de, bp@suse.de,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hpa@zytor.com, jirislaby@kernel.org, jlayton@kernel.org,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, lizefan.x@bytedance.com,
        mhocko@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        nglaive@gmail.com, oleg@redhat.com, serge@hallyn.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        viro@zeniv.linux.org.uk, vvs@virtuozzo.com
Subject:  [patch 103/212] memcg: enable accounting for new
 namesapces and struct nsproxy
Message-ID: <20210902215527.DBCAAzGHe%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Shakeel Butt <shakeelb@google.com>
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
@@ -3307,7 +3307,7 @@ static struct mnt_namespace *alloc_mnt_n
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
