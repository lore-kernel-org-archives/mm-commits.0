Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD870C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9803961104
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhICU6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhICU6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FB60610F7;
        Fri,  3 Sep 2021 20:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702666;
        bh=0P+68KKrLigSi33hw6Yp6+z6u6cKgSjS9h7hHeMSS3Y=;
        h=Date:From:To:Subject:From;
        b=Rizsm1AO2Cp/YyCgI6TTrMsd1ucd6ZHcjb/PVAL9Uno1kB5Fdrm9DNvxs7/RySiZ+
         AqqnbbIKcBLs2loZ5AiEk67ceLfMEQaLfBhqUxigfYngfs8UVKP/Hio2MCWfvQQ4uP
         Ufu2PGi8QDrttwLlg0QoPjMaU5Jsurb4U5ieeJiw=
Date:   Fri, 03 Sep 2021 13:57:45 -0700
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
Subject:  [merged]
 memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch removed
 from -mm tree
Message-ID: <20210903205745.FY0zvpQyd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for new namesapces and struct nsproxy
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from vvs@virtuozzo.com are


